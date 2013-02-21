Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3BUQLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 11:11:07 -0500
Message-ID: <51264711.1010804@redhat.com>
Date: Thu, 21 Feb 2013 10:10:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: Hugo Mills <hugo@carfax.org.uk>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS fails defragging
References: <51263363.9020203@petaramesh.org> <20130221150120.GC14283@carfax.org.uk> <512638F6.3090305@petaramesh.org>
In-Reply-To: <512638F6.3090305@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/21/13 9:10 AM, Swâmi Petaramesh wrote:
> Le 21/02/2013 16:01, Hugo Mills a écrit :
>> That's a success. The return code for defrag is broken, and for some
>> reason returns 20 on success. 
> 
> Thanks for the quick reply Hugo. So should I script that "for now and
> the future", $? 20 = OK ?

Heh:

static int cmd_defrag(int argc, char **argv)
{

<snip>
        if (errors) {
                fprintf(stderr, "total %d failures\n", errors);
                exit(1);
        }

        return errors + 20;
}

what the . . .   It's the only command in the file that adds
some random number to the 0 success return.  I have no idea
what that could possibly be for.

Unless someone can document & explain the rationale for all these crazy
error values I think they need to be ripped out & sanitized.

For scripting I suppose I'd say "0 or 20 is OK"

-Eric

>> This is pretty good. You can't guarantee that any given file will be
>> defragmented completely. I think if the file is large (bigger than a
>> block group), then it'll be split across the block group boundaries.
>> I'd say 3 fragments is pretty good, unless it's a couple of KiB in
>> size... Hugo. 
> 
> Isn't filefrag supposed to report only non-consecutive fragments ?
> 
> If not, at which number of fragments would you advise me to defrag a file ?
> 
> (Another question would be : How to check directory fragmentation ?)
> 
> Something extremely weird happened here : I just ran filefrag -v twice
> on this very file, and it gave me very different results... I don't
> expect the file to have changed although, as this is an initramfs which
> gets updated only when critical packages are - and no update of any kind
> took place between the 2 very different reports... Any clue ?
> 
> Once :
> 
> # filefrag -v /boot/initrd.img-3.5.0-24-generic
> Filesystem type is: 9123683e
> File size of /boot/initrd.img-3.5.0-24-generic is 22809774 (5569 blocks,
> blocksize 4096)
>  ext logical physical expected length flags
>    0       0    94048             128
>    1     128    94176             128
>    2     256    94304             128
>    3     384    94432             128
>    4     512    94560             128
>    5     640    94688             128
>    6     768    94816             128
>    7     896    94944             128
>    8    1024    95072             128
>    9    1152    95200             128
>   10    1280    95328             128
>   11    1408    95456             128
>   12    1536    95584             128
>   13    1664    95712             128
>   14    1792   127044    95840    128
>   15    1920   127172             128
>   16    2048   127300             128
>   17    2176   127428             128
>   18    2304   127556             128
>   19    2432   127684             128
>   20    2560   127812             128
>   21    2688   127940             128
>   22    2816   128068             128
>   23    2944   128196             128
>   24    3072   128324             128
>   25    3200   128452             128
>   26    3328   128580             128
>   27    3456   128708             128
>   28    3584   128836             128
>   29    3712   128964             128
>   30    3840   129092             128
>   31    3968   129220             128
>   32    4096   129348             128
>   33    4224   129476             128
>   34    4352   129604             128
>   35    4480   129732             128
>   36    4608   129860             128
>   37    4736   129988             128
>   38    4864   130116             128
>   39    4992   130244             128
>   40    5120   130372             128
>   41    5248   130500             128
>   42    5376   130628             128
>   43    5504    21832   130756     65 eof
> /boot/initrd.img-3.5.0-24-generic: 3 extents found
> 
> ...and then...:
> 
> # filefrag -v /boot/initrd.img-3.5.0-24-generic
> Filesystem type is: 9123683e
> File size of /boot/initrd.img-3.5.0-24-generic is 22809774 (5569 blocks,
> blocksize 4096)
>  ext logical physical expected length flags
>    0       0    94048            1792
>    1    1792   127044    95840   3712
>    2    5504    21832   130756     65 eof
> /boot/initrd.img-3.5.0-24-generic: 3 extents found
> 
> I'm puzzled...
> 

