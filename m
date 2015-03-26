Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out14.tpgi.com.au ([220.244.226.124]:46330 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbbCZKUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 06:20:46 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Chris Murphy <chris@colorremedies.com>, Chris Mason <clm@fb.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: RE: kvm bug, guest I/O blk device errors when qcow2 backing file is
 on Btrfs
Date: Thu, 26 Mar 2015 10:00:34 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64594CD80D3D@Server.waterlogic.com.au>
References: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
	<20150323211334.GA11155@ret.masoncoding.com>
 <CAJCQCtRRtOoTUNAwyN56615y_uOyCLwXG13KWy=g1CCiDrH=BA@mail.gmail.com>
In-Reply-To: <CAJCQCtRRtOoTUNAwyN56615y_uOyCLwXG13KWy=g1CCiDrH=BA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Chris Murphy
> Sent: Wednesday, 25 March 2015 3:10 AM
> To: Chris Mason; Chris Murphy; Btrfs BTRFS
> Subject: Re: kvm bug, guest I/O blk device errors when qcow2 backing file is
> on Btrfs
> 
> On Mon, Mar 23, 2015 at 3:13 PM, Chris Mason <clm@fb.com> wrote:


> > The last time we tracked down a similar problem, Josef found it was
> > only on windows guests.  Basically he tracked it down to buffers
> > changing while in flight.  I'll take a look.
> 
> Looks like cache=none and directsync share O_DIRECT in common.
> 
> This patch suggests neither of those cache options should be used (for
> different reasons).
> https://github.com/libguestfs/libguestfs/commit/749e947bb0103f19feda0f2
> 9b6cbbf3cbfa350da
> 
> I stumbled on this testing GNOME Boxes which is using cache=none, which it
> probably shouldn't, but nevertheless none and directsync also shouldn't
> cause problems on Btrfs. 

I've got a Windows 2012 guest VM running on a linux host and I also have trouble with cache=none. There is one particular inode on the BTRFS filesystem that gets csum errors about every 6-18 hours. I swapped just about everything (hardware) trying to find the problem, but then I remembered I was experimenting with cache options. I changed it back to default and the problem went away.
Interrestingly there are no reported errors on the VM.

Paul.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
