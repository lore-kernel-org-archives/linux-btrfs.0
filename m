Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61144 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2JOVHK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 17:07:10 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3199079eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 14:07:09 -0700 (PDT)
Message-ID: <507C7B12.8010708@gmail.com>
Date: Mon, 15 Oct 2012 23:07:30 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Goffredo Baroncelli <kreijack@inwind.it>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Move parse_size() in utils.c
References: <1350299942-23468-1-git-send-email-sbehrens@giantdisaster.de> <1350328523-7465-1-git-send-email-kreijack@gmail.com> <1350328523-7465-2-git-send-email-kreijack@gmail.com> <507C73D7.6010904@giantdisaster.de>
In-Reply-To: <507C73D7.6010904@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

On 2012-10-15 22:36, Stefan Behrens wrote:
> Hi Goffredo
>
> On 10/15/2012 21:15, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> Move parse_size() in utils.c, because it is used both from
>> cmds-filesystem.c and mkfs.c.
>
> Makes sense.
> (Jan also sent such a patch on 1 Feb 2011 
> <http://permalink.gmane.org/gmane.comp.file-systems.btrfs/9016>, as 
> part of the patch for speed profiles and dedicated log devices. But 
> the whole patch series was not integrated.)
>
>> Moreover added check about overflow, support to further units (
>> t=tera, e=exa, z=zetta, y=yotta).
>
> Don't make it too complicated, please. Btrfs cannot handle more than 
> 2^64 bytes.

yeaa I didn't resisted :-)
>
>> Correct a bug which happens if a value like 123MB is passed: before
>> the function returned 123 instead of 123*1024*1024
>
> Yes, that should be fixed. 'B' is taken as the size multiplier 'byte' 
> (times one) and 'M' is silently ignored. 


> [....]
>>
>> +/*
>> + *  see http://gurmeet.net/puzzles/fast-bit-counting-routines/ for
>> + *  further algorithms, I used the only one which I understood :-)
>> + */
>> +static int bitcount(u64 v)
>> +{
>> +    int    n;
>> +    for(n=0; v ; n++, v >>= 1) ;
>> +
>> +    return n;
>> +}
>
> IMO, something like bitcount() is not needed, much too complicated for 
> such a minor issue.

I fear that if somebody pass something like 16E, it got un-predicible 
results. Let me to wait a day to see if anyone has a different opinion 
on it. If nobody tell otherwise I will remove this check.

>
>> +
>> +u64 parse_size(char *s)
>> +{
>> +    int shift = 0;
>> +    u64 ret;
>> +    int n, i;
>> +
>> +    s = strdup(s);
>
> Either don't call strdup() or free() the memory at the end.

This was a my BUG, I removed the needing of strdup(), but I don't remove 
the strdup() itself :-)
Thanks to catch it.

>
>> +
>> +    for( i = 0 ; s[i] && isdigit(s[i]) ; i++ ) ;
>> +    switch (tolower(s[i])) {
>> +        /* note: the yobibyte and the zebibyte don't fit
>> +           in a u64, they need an u128 !!! */
>
> If the comment is correct, please remove yobi, zebi and the comment :)

ok... (but zfs supports zettabyte filesystem.... )

>
>> +        case 'y':    /* yobibyte */
>> +            shift += 10;
>> +        case 'z':    /* zebibyte */
>> +            shift += 10;
>> +        case 'e':    /* exbibyte */
>> +            shift += 10;
>> +        case 'p':    /* pebibyte */
>> +            shift += 10;
>> +        case 't':    /* tetibyte */
>> +            shift += 10;
>> +        case 'g':    /* gibibyte */
>> +            shift += 10;
>> +        case 'm':    /* mebibyte */
>> +            shift += 10;
>> +        case 'k':    /* kibibyte */
>> +            shift += 10;
>> +        case 0:
>
> This should be "case 'b'" at the end in order to maintain backward 
> compatibility.
Ok, this make sense
>
>> +            break;
>> +        default:
>> +            fprintf(stderr, "ERROR: Unknown size descriptor %c\n",
>> +                s[i]);
>> +            exit(1);
>> +    }
>> +    ret = strtoull(s, 0, 0);
>> +    n = bitcount(ret);
>> +
>> +    if( ( n + shift ) > ( sizeof(u64) * CHAR_BIT )) {
>> +        fprintf(stderr, "ERROR: Overflow, the value '%s' is too big\n",
>> +            s);
>> +        fprintf(stderr, "ERROR: Abort\n");
>> +        exit(1);
>> +    }
>
> IMO, bitcount() and the check afterwards should be removed.
>
>> +
>> +    return ret << shift;
>> +}
>> +
>> +
>> diff --git a/utils.h b/utils.h
>> index 3a0368b..180b3f9 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -46,4 +46,5 @@ int check_label(char *input);
>>   int get_mountpt(char *dev, char *mntpt, size_t size);
>>
>>   int btrfs_scan_block_devices(int run_ioctl);
>> +u64 parse_size(char *s);
>>   #endif
>>
>
>

I updated the patch on my repo (see first email), if someone want to 
make some tests. As explained above I will wait a day, then I will 
re-issue the patch.

BR
G.Baroncelli

