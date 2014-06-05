Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49578 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626AbaFESAn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 14:00:43 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:65209 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wsbxy-001OUC-RM
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 12:00:42 -0600
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Using BTRFS on SSD now ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2215647.hErg5R77lo@zafu>
Date: Thu, 5 Jun 2014 12:00:41 -0600
Message-Id: <D14F1903-6E0B-4CD5-B00C-CA9585ED1C86@colorremedies.com>
References: <2215647.hErg5R77lo@zafu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 5, 2014, at 7:30 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Hi,
> 
> I just received a new laptop with a Micron 256GB SSD, and I plan to install 
> Fedora 20 onto it.
> 
> I'm considering either BTRFS or ext4 (over LUKS-encrypted LVM) for this 
> machine, but I'm afraid BTRFS might generate too much writes and shorten the 
> SSD lifespan... Or am I mistaken ?

Is it certain Btrfs single profile writes more metadata than other file systems? Since the journal is the file system, I'd expect the same or less writes with Btrfs than other file systems which repetitively write a separate journal. In any case it's a really minor consideration. SSD wear is to the point you'd have to practically be abusing the drive (enterprise demand workloads on a consumer SSD).

Btrfs does work over dm layers including on LVM and dmcrypt and both. There have been some problems recently reported on the list that involve LVM and dmcrypt but I have no idea if those are contributing or merely complicating factors. Unless you have a really specific requirement offered by LVM,  or you're just looking to test with intent to break to help make the combination better for everyone, I'd advise against using it. Btrfs on dmcrypt should definitely work (I've done it for a few years and haven't had issues). There's some advantage of LVM thinp LVs, I'm not sure if Btrfs is going to offer its own thin provisioning, if not then Btrfs on LVM thinp needs to work to but I've only done a little bit of testing with this. It works, but with obscenely sized virtual LVs with totally insufficient backing, I've had some problems, ergo if you want to go this route you basically are signing up for detailed and concise problem reporting.

> Is there any pro/cons currently, on a 3.14 kernel, about using BTRFS along 
> with an SSD ?

If anything, more even wear on older devices that don't do their own wear leveling.

> Is there specific advice about leaf size, use of compression, snapshots, 
> (auto-)defrag etc, that might be relevant especially for SSDs ?

Defaults are fine. Longer term discard and autodefrag mount options will have some clearer benefits.

I pretty much gave up on discard with a Samsung 830 SSD. In both Linux and OS X I'd get these short hangs, maybe just a couple seconds or so. They were more annoying on OS X than on Linux.

Fragmentation is probably not a big performance problem on SSDs. At least on my hardware I haven't noticed a difference with even highly fragmented VM images that I haven't set xattr +C (nodatacow) on. Neverthless I've done some testing of both +C on /var/log/journal since systemd journals quickly get very fragmented on Btrfs as do VM images. I'm pretty sure all the bugs I reported about that were long ago fixed, I haven't had any recurrences. So now I'm not using +C but rather autodefrag for the past 8 months. A few months ago I had some systemd journal corruptions but I can't point the finger at either Btrfs or autodefrag because the corruptions coincided with unclean shutdowns. And it even could be an issue with systemd-journald. If I manage to reproduce the corruption, then I'll have to see about also reproducing it on either ext4 or xfs.

Compression I no longer use. I'd probably not use forced compression on an SSD because it'll probably just slow things down. 

Snapshots haven't been a problem, I'm even doing my own atomic yum/dnf updates by creating rw snapshots, chrooting them, and then running the update in the chroot. So the snapshots are what get the system update, if it fails I can just blow away the snapshots, and if it succeeds I haven't changed anything on the running OS mounted system, I can point grub to the new subvolume to boot from and reboot to the updated system whenever I want.

For what it's worth, Fedora 20's installer doesn't let you have a /boot on Btrfs. It must be on ext4. So if you want /boot on Btrfs you get to do this post-install. The current bug there being worked on (patches upstream) is kernel updates depend on grubby adding the proper entry in grub.cfg which fails with /boot is on Btrfs. As a work around to the grubby message you get when doing kernel updates, you can just run grub2-mkconfig -o <grub.cfg location> to create a new correct grub.cfg. I'm expecting this to all "just work" in Fedora 21.


Chris Murphy