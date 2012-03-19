From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: [PATCH] Btrfs: fix btrfs_ioctl_dev_info() crash on missing device
Date: 19 Mar 2012 16:54:00 +0100
Message-ID: <C5Ax0wQeCXB@helmut.hullen.de>
References: <1332170242-30064-1-git-send-email-sbehrens@giantdisaster.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332170242-30064-1-git-send-email-sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stefan,

Du meintest am 19.03.12:

> When a filesystem is mounted with the degraded option, it is
> possible that some of the devices are not there.
> btrfs_ioctl_dev_info() crashs in this case because the device
> name is a NULL pointer. This ioctl was only used for scrub.

Just for curiosity: can that happen when I first delete a partition/disk  
and then run "btrfs scrub start"?

Viele Gruesse!
Helmut
