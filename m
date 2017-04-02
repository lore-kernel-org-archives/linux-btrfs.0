Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56026 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdDBAOW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 20:14:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuT9l-0001Pa-MA
        for linux-btrfs@vger.kernel.org; Sun, 02 Apr 2017 02:14:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mix ssd and hdd in single volume
Date: Sun, 2 Apr 2017 00:13:59 +0000 (UTC)
Message-ID: <pan$dda3$b8e27938$5de5fd9$136342b5@cox.net>
References: <CAEgruXvAEBfpQaAxCi42Vq6v8w7v1dqthpn9TpE3FDDHoTWRcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

UGlee posted on Sat, 01 Apr 2017 14:06:11 +0800 as excerpted:

> We are working on a small NAS server for home user. The product is
> equipped with a small fast SSD (around 60-120GB) and a large HDD (2T to
> 4T).
> 
> We have two choices:
> 
> 1. using bcache to accelerate io operation 2. combining SSD and HDD into
> a single btrfs volume.
> 
> Bcache is certainly designed for our purpose. But bcache requires
> complex configuration and can only start from clean disk. Also in our
> test in Ubuntu 16.04, data inconsistence was observed at least once,
> resulting total HDD data lost.
> 
> So we wonder if simply putting SSD and HDD into a single btrfs volume,
> in whatever mode, the general read operation (mostly readdir and
> getxattr) will also be significantly faster than a single HDD without
> SSD.

At present, bcache, or possibly the lvmcache alternative, are the only 
recommended way of creating a single btrfs out of a mixed-size ssd/hdd 
multi-volume.

The problem is that while they've been considered, there's no present 
method of telling btrfs to use the smaller ssd for hotter content.  The 
btrfs chunk allocator simply doesn't have that option at present.

Which would leave you with the choice of single, raid1 or raid0 modes.  
Raid1 requires two copies on separate devices which would mean the extra 
space on the larger hdd would be wasted/unusable, and the read-mode 
mirror choice algorithm is purely even/odd PID-based so on single reads 
you'd have a 50% chance of fast ssd reads, 50% chance slow hdd.  With 
single mode the allocator allocates to the device with the most space 
available first, so until the free space equalized between the two, all 
chunks would end up on the larger/slower hdd.  And raid0 would allocate 
evenly (allocate-wide policy) to both, again wasting the extra space on 
the larger device while only giving you overall about the same speed as 
two hdds would give you, tho less predictably you'd get the full speed of 
the ssd.

The default two-device setup, FWIW, is raid1-mode metadata for safety, 
single-mode data.  

As you can see, none of those are ideal from a fast-small-ssd as cache to 
a large-slow-hdd perspective, thus the recommendation of bcache or 
lvmcache if that's what you want/need.

The other alternative, of course, is separate filesystems, using a 
combination of symlinks, partitioning and bind-mounts, to arrange for 
frequently accessed and performance-critical stuff such as root and /home 
to be on the smaller/faster ssd, while the larger/slower hdd is used for 
stuff like a user's multimedia partition/filesystem.  That's actually 
what I've done here and I'm *very* happy with the result, but it's the 
type of solution that must either be customized per-installation, or 
perhaps be setup by a special-purpose distro installer designed with that 
sort of use-case target in mind.  It's /not/ the sort of thing you can do 
in a NAS product and expect mass-market users to actually read and 
understand the docs in ordered to use the product in an optimal way.


Meanwhile, since you appear to be designing a mass-market product, it's 
worth mentioning that btrfs is considered, certainly by its devs and 
users on this list, to be "still stabilizing, not fully stable and 
mature."  As such, making and having backups at the ready for any data 
considered to be more valuable than the time and resources necessary to 
make those backups is strongly recommended, even more so than when the 
filesystem is considered stable and mature (tho certainly the rule 
applies even then, but try telling that to a mass-market user...).

Additionally, since btrfs /is/ still stabilizing, we recommend that users 
run relatively new kernels, we best support the latest kernels in either 
of the current kernel series (thus 4.10 and 4.9 at present) or the 
mainline LTS series (thus 4.9 and 4.4 at present), and further recommend 
that users at least loosely follow the list in ordered to keep up with 
current btrfs developments and possible issues they may confront.

That doesn't sound like a particularly good choice for a mass-market NAS 
product to me.  Of course there's rockstor and others out there already 
shipping such products, but they're risking their reputation and the 
safety of their customer's data in the process, altho there's certainly a 
few customers out there with the time, desire and technical know-how to 
ensure the recommended backups and following current kernel and list, and 
that's exactly the sort of people you'll find already here.  But that's 
not sufficiently mass-market to appeal to most vendors.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

