Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50950 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbcBJEIm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 23:08:42 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id D0B6A21AFE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 23:08:41 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 8816E6800F1
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 23:08:41 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id B6B5D1CF581
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 04:08:40 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
Date: Tue, 09 Feb 2016 20:08:39 -0800
In-Reply-To: <87twliri6m.fsf@thinkpad.rath.org> (Nikolaus Rath's message of
	"Mon, 08 Feb 2016 13:44:17 -0800")
Message-ID: <87pow5tdfc.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 08 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
> Otherwise I'll give bcache a shot. I've avoided it so far because of the
> need to reformat and because of rumours that it doesn't work well with
> LVM or BTRFS. But it sounds as if that's not the case..

I now have the following stack:

btrfs on LUKS on LVM on bcache

The VG contains two bcache PVs with backing devices on different
spinning disks, and a shared cache device on SSD. I'm using Kernel 4.3.

I'm super happy with the performance, boot times increased from 1:30
minutes to X11 and 2:00 to Firefox roughly 0:10 to X11 and 0:30 to
Firefox.


Time will tell if it also keeps my data intact, but I hope btrfs would
at least detect any corruption. 


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
