Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34768 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbdAZLBd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 06:01:33 -0500
Received: by mail-wm0-f43.google.com with SMTP id f73so4012026wmf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jan 2017 03:01:32 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
Date: Thu, 26 Jan 2017 12:01:29 +0100
MIME-Version: 1.0
In-Reply-To: <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>    It's on line 248 of the paste:
> 
> 246.   key (5547032576 EXTENT_ITEM 204800) block 596426752 (36403) gen 20441
> 247.   key (5561905152 EXTENT_ITEM 184320) block 596443136 (36404) gen 20441
> 248.   key (15606380089319694336 UNKNOWN.76 303104) block 596459520 (36405) gen 20441
> 249.   key (5726711808 EXTENT_ITEM 524288) block 596475904 (36406) gen 20441
> 250.   key (5820571648 EXTENT_ITEM 524288) block 350322688 (21382) gen 20427
> 
>    I was wrong in my assumption: this isn't a simple bitflip. It looks
> like a small random write of data over the item key. That's not to say
> that bad hardware isn't the culprit -- it's worth checking anyway --
> but it could also be a bug in... well, almost anything.
> 
>    It's not corruption on the disk, because that would be caught by
> the checksum mechanism. This data was corrupted in RAM, before it was
> checksummed and written to disk. That could have happened as a result
> of some rogue piece of kernel code writing to an incorrect address, or
> as a result of some _other_ memory corruption affecting an address
> which is then used to write something to.
In the past, I used the nvidia binary blob on that machine, which would of course be a potential culprit - but since a few months, the machine uses nouveau and the kernel is not tainted. 

In case somebody encounters something similar in the future, a few more details:
The only not-so-common kernel code running on that machine was zram, which I have unloaded just now. Apart from that, there's only very common hardware with in-tree modules (realtek ethernet card, intel chipset + CPU, VIA USB3 controller)
in the machine. Special kernel options are "iommu=soft zswap.enabled=1", I am running Gentoo, no kernel patches apart from those by Gentoo upstream (i.e. I use sys-kernel/gentoo-sources-4.9.0). 

I'm also running 'memtester 12G' right now, which at least tests 2/3 of the memory. I'll leave that running for a day or so, but of course it will not provide a clear answer... 

> 
>    Looking at the data, I think this should be manually fixable, with
> sufficient effort (and a hex editor).
> 
> Looking at the item value:
> 
>>>> hex(15606380089319694336)
> '0xd89500014da12000'
> 
> Compared to the preceding key's value:
> 
>>>> hex(5561905152)
> '0x14b83f000'
> 
> It looks like it's just the top couple of bytes in this field that are
> affected, so those (d8, 95) can be zeroed. The second field should
> clearly be EXTENT_ITEM, which is 0xa8. The offset field (the third
> one) looks OK to me -- the bottom byte is 0.
> 
>    We can probably talk you through fixing this by hand with a decent
> hex editor. I've done it before...
> 
That would be nice! Is it fine via the mailing list? 
Potentially, the instructions could be helpful for future reference, and "real" IRC is not accessible from my current location. 

Do you have suggestions for a decent hexeditor for this job? Until now, I have been mainly using emacs, 
classic hexedit (http://rigaux.org/hexedit.html), or okteta (beware, it's graphical!), but of course these were made for a few MiB of files and are not so well suited for a block device. 

The first thing to do would then probably just be to jump to the offset where 0xd89500014da12000 is written (can I get that via inspect-internal, or do I have to search for it?), fix that to read 
0x00a800014da12000
(if I understood correctly) and then probably adapt a checksum? 

>    Bear in mind that if it is unreliable hardware, then continued use
> of the FS in read-write operation is likely to cause additional
> damage.
Of course. 
I would then, in any case, after the filesystem is up again, clean up, do a fresh external backup, scratch the FS and recreate it. I think it is already over 2 years old, so it has survived several generations of kernels. 

Oliver
