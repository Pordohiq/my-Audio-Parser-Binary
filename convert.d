module convert;

import core.stdc.stdlib : malloc;

string join_array(string[] arr, string delim = ", ")
{
    if (arr.length == 0) return null;

    size_t totalLen = 0;
    foreach (i, s; arr)
    {
        totalLen += s.length;
        if (i < arr.length - 1)
        {
            totalLen += delim.length;
        }
    }

    char* buffer = cast(char*)malloc(totalLen);
    if (!buffer) return null;

    size_t offset = 0;
    foreach (i, s; arr)
    {
        foreach (j; 0 .. s.length)
        {
            buffer[offset + j] = s[j];
        }
        offset += s.length;

        if (i < arr.length - 1)
        {
            foreach (j; 0 .. delim.length)
            {
                buffer[offset + j] = delim[j];
            }
            offset += delim.length;
        }
    }

    return cast(string)buffer[0 .. totalLen];
}
