Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34545 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbcIKKX2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 06:23:28 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Waxhead <waxhead@online.no>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Date: Sun, 11 Sep 2016 12:23:23 +0200
Message-ID: <13278435.QSGp0b77ZB@merkaba>
In-Reply-To: <57D51BF9.2010907@online.no>
References: <57D51BF9.2010907@online.no>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 10:55:21 CEST schrieb Waxhead:
> I have been following BTRFS for years and have recently been starting to
> use BTRFS more and more and as always BTRFS' stability is a hot topic.
> Some says that BTRFS is a dead end research project while others claim
> the opposite.

First off: On my systems BTRFS definately runs too stable for a research 
project. Actually: I have zero issues with stability of BTRFS on *any* of my 
systems at the moment and in the last half year.

The only issue I had till about half an year ago was BTRFS getting stuck at 
seeking free space on a highly fragmented RAID 1 + compress=lzo /home. This 
went away with either kernel 4.4 or 4.5.

Additionally I never ever lost even a single byte of data on my own BTRFS 
filesystems. I had a checksum failure on one of the SSDs, but BTRFS RAID 1 
repaired it.


Where do I use BTRFS?

1) On this ThinkPad T520 with two SSDs. /home and / in RAID 1, another data 
volume as single. In case you can read german, search blog.teamix.de for 
BTRFS.

2) On my music box ThinkPad T42 for /home. I did not bother to change / so far 
and may never to so for this laptop. It has a slow 2,5 inch harddisk.

3) I used it on Workstation at work as well for a data volume in RAID 1. But 
workstation is no more (not due to a filesystem failure).

4) On a server VM for /home with Maildirs and Owncloud data. /var is still on 
Ext4, but I want to migrate it as well. Whether I ever change /, I don´t know.

5) On another server VM, a backup VM which I currently use with borgbackup. 
With borgbackup I actually wouldn´t really need BTRFS, but well…

6) On *all* of my externel eSATA based backup harddisks for snapshotting older 
states of the backups.

> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
> of warnings and recommendations and is for me a bit better than the
> official BTRFS wiki when it comes to how to decide what features to use.

Nice page. I wasn´t aware of this one.

If you use BTRFS with Debian, I suggest to usually use the recent backport 
kernel, currently 4.6.

Hmmm, maybe I better remove that compress=lzo mount option. Never saw any 
issue with it, tough. Will research what they say about it.

> The Nouveau graphics driver have a nice feature matrix on it's webpage
> and I think that BTRFS perhaps should consider doing something like that
> on it's official wiki as well

BTRFS also has a feature matrix. The links to it are in the "News" section 
however:

https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature

Thing is: This just seems to be when has a feature been implemented matrix. 
Not when it is considered to be stable. I think this could be done with colors 
or so. Like red for not supported, yellow for implemented and green for 
production ready.

Another hint you can get by reading SLES 12 releasenotes. SUSE dares to 
support BTRFS since quite a while – frankly, I think for SLES 11 SP 3 this was 
premature, at least for the initial release without updates, I have a VM that 
with BTRFS I can break very easily having BTRFS say it is full, while it is 
has still 2 GB free. But well… this still seems to happen for some people 
according to the threads on BTRFS mailing list.

SUSE doesn´t support all of BTRFS. They even put features they do not support 
behind a "allow_unsupported=1" module option:

https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-314697

But they even seem to contradict themselves by claiming they support RAID 0, 
RAID 1 and RAID10, but not RAID 5 or RAID 6, but then putting RAID behind that 
module option – or I misunderstood their RAID statement

"Btrfs is supported on top of MD (multiple devices) and DM (device mapper) 
configurations. Use the YaST partitioner to achieve a proper setup. 
Multivolume Btrfs is supported in RAID0, RAID1, and RAID10 profiles in SUSE 
Linux Enterprise 12, higher RAID levels are not yet supported, but might be 
enabled with a future service pack."

and they only support BTRFS on MD for RAID. They also do not support 
compression yet. They even do not support big metadata.

https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221

Interestingly enough RedHat only supports BTRFS as a technology preview, even 
with RHEL 7.

> For example something along the lines of .... (the statuses are taken
> our of thin air just for demonstration purposes)

I´d say feel free to work with the feature matrix already there and fill in 
information about stability. I think it makes sense tough to discuss first on 
how to do it with still keeping it manageable.

Thanks,
-- 
Martin
