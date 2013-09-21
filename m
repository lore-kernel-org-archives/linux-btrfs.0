Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34374 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3IUIy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Sep 2013 04:54:57 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted filesystem
Date: Sat, 21 Sep 2013 10:54:55 +0200
Message-ID: <2354718.ZY0jrbsDUo@merkaba>
In-Reply-To: <20130921023415.GE5672@localhost.localdomain>
References: <5021349.IU75SGaY0J@merkaba> <20130921023415.GE5672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 20. September 2013, 22:34:15 schrieb Josef Bacik:
> On Sat, Sep 21, 2013 at 12:25:02AM +0200, Martin Steigerwald wrote:
> > Hi!
> > 
> > I tried to create a snapshot today like this:
> > 
> > merkaba:/mnt/debian-zeit> ls -l
> > insgesamt 0
> > drwxr-xr-x 1 root root 210 Sep 20 11:48 root
> > merkaba:/mnt/debian-zeit> btrfs subvol list /
> > ID 256 gen 21382 top level 5 path root
> > merkaba:/mnt/debian-zeit> btrfs subvol snap -r root root-2013-09-20
> > merkaba:/mnt/debian-zeit#1>
> 
> You will want the patch I just sent,
> 
> Btrfs: create the uuid tree on remount rw
> 
> and that should fix the snapshot problems.  Thanks,

Many thanks, will compile a kernel with that patch.

Any idea how I can fix these checksum errors without reformatting? I would like 
to avoid it if possible.

In syslog it didn´t mention which files they affected, so maybe it is "just" 
metadata. But I just have single for metadata as per suggestion for SSDs.

Would it make sense to run fsck on it?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
