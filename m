From: Chris Mason <chris.mason@oracle.com>
Subject: Re: multiple device usage
Date: Tue, 30 Dec 2008 16:43:01 -0500
Message-ID: <1230673381.4229.7.camel@think.oraclecorp.com>
References: <556243856@web.de> <49559672.7060204@gmail.com>
	 <000c01c9682d$16b30da0$6602a8c0@bui.materna.com>
	 <977a2be20812280526y10eb4646i18cdc17c3af072f3@mail.gmail.com>
	 <006a01c969b1$5954fe40$6602a8c0@bui.materna.com>
	 <3d0408630812290435l7b4739dbi88b8b596df60baab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Roland <devzero@web.de>, yanhai zhu <zhu.yanhai@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812290435l7b4739dbi88b8b596df60baab@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-29 at 20:35 +0800, Yan Zheng wrote:
> 2008/12/29 Roland <devzero@web.de>:
> >>> so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk
> >>> ,
> >>> replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk
> >>> and
> >>
> >>                                                ~~~~~~~~~~~~~~~~~~~~~~~
> >>                                               This step will fail, you
> >> will
> >> get a "/dev/sdb is mounted" by mkfs.btrfs, but for other slots it's ok.
> >
> > isn`t this sort of a design issue then?
> > no way to work around this ?
> >
> 
> No, this is a (easy to fix) bug.

Right, the check for a mounted FS came after we made the device
add/removal work ;)  mkfs.btrfs should be changed to do the mounted FS
check differently.

-chris


