Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36889 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab2EZHc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 03:32:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SYBU8-00079J-UH
	for linux-btrfs@vger.kernel.org; Sat, 26 May 2012 09:32:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 09:32:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 09:32:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Cant mount multi-subvolume via fstab
Date: Sat, 26 May 2012 07:32:14 +0000 (UTC)
Message-ID: <pan.2012.05.26.07.32.14@cox.net>
References: <20120523120002.79a23bed@hercules.fisnuc.intranet.ufba.br>
	<4FBD1F05.4080000@libero.it> <20120524233315.GA2838@matrix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rogerio Bastos posted on Thu, 24 May 2012 20:33:16 -0300 as excerpted:

> On Wed, May 23, 2012 at 07:31:49PM +0200, Goffredo Baroncelli wrote:
>> Hi Rogerio,
>> 
>> On 05/23/2012 05:00 PM, Rogerio Bastos wrote:
>> > Hi,
>> > 
>> > I'm trying mount many subvolume during boot via fstab:
>> > 
>> > UUID=xxx /usr btrfs subvol=usr,ro,nodev 0 0 UUID=xxx /home btrfs
>> > subvol=home,nodev,nosuid 0 0 UUID=xxx /var btrfs subvol=var,nodev 0 0
>> > UUID=xxx /var/tmp btrfs subvol=var-tmp,nodev,noexec,nosuid 0 0
>> > 
>> > But only the first one is mounted. When try to mount the others
>> > subvolumes, I get this error:
>> 
>> I did some tests. It seems that the problem is that you want to mount
>> different subvolumes *of the same filesystem* (/dev/sda3) both in RO
>> (first entry) and RW (the other entries).
>> 
>> Please try to removing the 'RO' for the first entry, and let know us
>> what happens.
> 
> You are right, without RO I can mount all subvolume.

If you need the different rw/ro mounts you can use mount --bind.  There's 
a bit of a catch, however, in that an initial mount --bind will always 
have the same ro/rw as the original mount.  You thus have to mount it 
with a mount-bind, then do a remount, to change that.

I do something similar here, not with btrfs (which I tried but had 
problems with, I'll let it mature a few kernels and try again) but with 
some mount-binds into a chroot, before I start the app (named aka bind) I 
run in it.

My fstab has entries like this:

/etc/bind  /m/cbind/etc/bind  none  bind,ro,noexec,nodev,noatime  0 0
/var/bind  /m/cbind/var/bind  none  bind,rw,noexec,nodev,noatime  0 0

But they're on the same source filesystem so the mount -a mounts them 
both the same (rw in my case).  I thus have an initscript "stub" that 
runs between the localmount initscript and the named/bind initscript, 
that does a mount -o,remount.  Since they're setup with the correct 
options in fstab and the initial mount simply ignores them, a simple 
remount gives me the correct options, with ro/rw now kernel enforced.

So while a direct btrfs subvolume mount won't track ro/rw separately, a 
mount-bind, followed by an appropriate remount, should.

But I'd not try that for btrfs specific mount options, autodefrag, 
nodatacow, etc, as I'm not sure how btrfs would react to that.  Just 
generic options such as rw/rw, exec/noexec, etc, which I believe are 
enforced at the block layer, not the filesystem layer itself.

See the mount (8) manpage for more on bind-mounts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

