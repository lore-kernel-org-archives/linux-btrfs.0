Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kawka.in.waw.pl ([178.63.212.103]:59255 "EHLO kawka.in.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3KOAEd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 19:04:33 -0500
Date: Fri, 15 Nov 2013 01:04:31 +0100
From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To: Karel Zak <kzak@redhat.com>
Cc: linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] is mounting subvolumes with a read-only root
 subvolume allowed?
Message-ID: <20131115000431.GV30929@in.waw.pl>
References: <20131114233210.GU30929@in.waw.pl>
 <20131114234351.GI13330@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131114234351.GI13330@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 12:43:51AM +0100, Karel Zak wrote:
> On Fri, Nov 15, 2013 at 12:32:10AM +0100, Zbigniew Jędrzejewski-Szmek wrote:
> > Hi,
> > I have a box with / and /home being subvolumes from the same btrfs filesystem.
> > 
> > /etc/fstab:
> > UUID=c0686...      /      btrfs subvol=root,x-systemd.device-timeout=0 1 1
> > UUID=c0686...      /home  btrfs subvol=home,x-systemd.device-timeout=0 1 1
> > ...
> > 
> > / is initially mounted readonly by the initramfs, and then after switching
> > to the real system, /home is attempted to be mounted in parallel with /
> > being remounted rw. If remounting rw happens first, boot proceeds. If
> > mounting /home is attempted to realy, it fails.
> > 
> > $ /bin/mount /home
> > mount: /dev/mapper/luks-765... is already mounted or /home busy
> >        /dev/mapper/luks-765... is already mounted on /
> > $ /bin/mount -o remount,rw /
> > $ /bin/mount /home
> > $
> > 
> > So, is this expected that the other subvolume must be mounted rw?
> 
>  This is known and pretty stupid issue:
>  http://www.spinics.net/lists/linux-btrfs/msg25502.html
> 
>  ... but it seems that btrfs guys are fine with this "feature".
5 months without a reply. Great.

Zbyszek
