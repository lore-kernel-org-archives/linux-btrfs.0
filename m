Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60976 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbcBHNFR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 08:05:17 -0500
Subject: Re: Fwd: Unmountable fs after power outage
To: Hugo Mills <hugo@carfax.org.uk>, Radek Sprta <radek.sprta@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
 <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com>
 <20160122152530.GX422@carfax.org.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56B89285.7070303@gmx.com>
Date: Mon, 8 Feb 2016 21:05:09 +0800
MIME-Version: 1.0
In-Reply-To: <20160122152530.GX422@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/22/2016 11:25 PM, Hugo Mills wrote:
> On Fri, Jan 22, 2016 at 04:11:53PM +0100, Radek Sprta wrote:
>> Hello everybody,
>>
>> after a recent power outage attempting to mount a my btrfs partition
>> fails with the following error:
>>
>> mount: wrong fs type, bad option, bad superblock on /dev/sda8,
>>         missing codepage or helper program, or other error
>>
>> This is what dmesg shows:
>> [ 1035.236081] BTRFS (device sda8): parent transid verify failed on
>> 410124288 wanted 85753 found 85755
>> [ 1035.240756] BTRFS (device sda8): parent transid verify failed on
>> 410124288 wanted 85753 found 85755
>> [ 1035.240780] BTRFS: failed to read tree root on sda8
>> [ 1035.252025] BTRFS: open_ctree failed
>
>     Try mounting with -orecovery. That's the main approach for dealing
> with transid failures.

IIRC, current "recovery" will only try to use backup roots.
And that's why I am going to rename the mount option to "usebackuproot" 
in next kernel release.

It's quite strange that current kernel doesn't have mount option to 
ignore transid error any longer.
Just grep "RECOVERY" in btrfs modules sources, and it should be quite 
easy to find this fact.

>
>> Below is the result of btrfs check:
>> Checking filesystem on /dev/sda8
>> UUID: b0486700-ff9f-4979-8735-257ff1428a0d
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 311702978854 bytes used err is 0
>> total csum bytes: 271057636
>> total tree bytes: 1859862528
>> total fs tree bytes: 1473953792
>> total extent tree bytes: 72876032
>> btree space waste bytes: 377740163
>> file data blocks allocated: 11278336921600
>>   referenced 975937630208
>> btrfs-progs v4.0
>
>     That looks reasonably promising -- nothing seriously damaged that
> btrfs check could find, at least.

Quite strange.
IIRC, btrfsck should at least report transid error.
As written in disk-io.c, verify_parent_transid() function.

Since btrfsck reports no error, I think btrfs-image could dump the 
metadata without problem.

So, would you please dump a btrfs-image dump, by the following command?
# btrfs-image -c9 /dev/sda8

Such dump will only contain your metadata(dir/file hierarchy including 
dir/file names), no data will be dump.

And if you think the filename can leak important data, you can use '-ss' 
or '-s' to sanitize them.

Thanks,
Qu

>
>> I tried googling the "open_ctree failed" error, but couldn't find any
>> definite answers. Here's some additional info:
>
>     "open_ctree failed" is a really generic error message,
> unfortunately. Almost every case that leads to a failure to mount will
> output that message, so there's no single solution you can find from
> just that error. The "parent transid verify failed" is a much better
> indication of what's happened here, and the small difference in
> transid numbers would indicate that -orecovery might actually have a
> chance of working.
>
>     Hugo.
>
>> uname -a:
>> Linux Computer 4.2.0-22-generic #27-Ubuntu SMP Thu Dec 17 22:57:08 UTC
>> 2015 x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs fi show:
>> Label: none  uuid: b0486700-ff9f-4979-8735-257ff1428a0d
>> Total devices 1 FS bytes used 290.37GiB
>> devid    1 size 301.32GiB used 295.04GiB path /dev/sda8
>>
>> Thanks in advance for any help,
>> Radek
>
