Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41130 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752254AbaEUPV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 11:21:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53410 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wn8L9-002hNf-15
	for linux-btrfs@vger.kernel.org; Wed, 21 May 2014 09:21:59 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs check, btrfsck, fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140521034731.3f7b7764@ws>
Date: Wed, 21 May 2014 09:21:57 -0600
Message-Id: <8D6E4872-EBDC-4521-815D-A3456DB64C47@colorremedies.com>
References: <9B5A4230-5A2F-4C00-AC4F-D9CA36A91620@colorremedies.com> <pan$bfe22$348a9807$13d86fd5$5784dae1@cox.net> <4QT21o01E1EMSLa01QT4fM> <20140521034731.3f7b7764@ws>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 21, 2014, at 4:47 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> On Tue, 20 May 2014 18:26:59 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> That ought to be true, but at least on a systemd 212-4 system, it
>> assumes the system root needs to be fsck'd before mounting it. Since
>> the fs isn't mounted, fstab isn't available. And the fstab.empty file
>> I found in the initramfs is in fact empty. So even with fs_passno set
>> to 0, systemd is trying to run fsck.btrfs, which it fails to find,
>> warns about, then moves on.
>> 
>> I filed that bug here:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1098799
> 
> 
> Hmm... it isn't doing so here.  dracut-037, systemd-212-r4 (the -r4
> indicating four gentoo package level revision bumps since the initial
> in-tree release of the upstream 037 version).

systemd 212 and dracut 037 here also.


> But I have an install-customized dracut config (tho I no longer use
> host-only as explained in my last post, to the degraded boot and
> systemd thread), all kernel modules built-in, etc.  If you're running a
> generic everything-including-the-kitchen-sink dracut, that might
> explain it, since I guess on most filesystems (not reiserfs/xfs/btrfs,
> however) it would need to be run.

I've tried both types of initramfs's. The fsck on root is always called, the difference being fsck.btrfs is not in the host-only initramfs, but is in the no-host-only one.

[    1.779007] localhost systemd[1]: Failed to load configuration for systemd-fsck-root.service: No such file or directory
[…snip…]
[    1.780811] localhost systemd[1]: Installed new job initrd-root-fs.target/start as 30
[    1.780818] localhost systemd[1]: Installed new job sysroot.mount/start as 31
[    1.780826] localhost systemd[1]: Installed new job dev-disk-by\x2duuid-d372e5d1\x2d386f\x2d460c\x2db036\x2d611469e0155e.device/start as 32
[    1.780834] localhost systemd[1]: Installed new job systemd-fsck@dev-disk-by\x2duuid-d372e5d1\x2d386f\x2d460c\x2db036\x2d611469e0155e.service/start as 33

The first and last entries are mysteries. There is a /usr/lib/systemd/system/systemd-fsck-root.service so I don't know why it fails to load. The last entry looks like it occurs not by systemd-fsck-root.service but rather /usr/lib/systemd/system/systemd-fsck@.service, which is in the same directory. It reads:

[Unit]
Description=File System Check on %f
Documentation=man:systemd-fsck@.service(8)
DefaultDependencies=no
BindsTo=%i.device
After=systemd-readahead-collect.service systemd-readahead-replay.service %i.device systemd-fsck-root.service
Before=shutdown.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/lib/systemd/systemd-fsck %f
StandardOutput=journal+console
TimeoutSec=0

So I'm not sure what's going on.


Chris Murphy

