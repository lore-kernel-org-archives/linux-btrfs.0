Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51975 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795AbcBIQJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 11:09:22 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 582D220758
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 11:09:22 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id B1E666801B7
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 11:09:21 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 5F3791CE4FD
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 16:09:20 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
Date: Tue, 09 Feb 2016 08:09:20 -0800
In-Reply-To: <20160209082933.52273993@jupiter.sol.kaishome.de> (Kai Krakow's
	message of "Tue, 9 Feb 2016 08:29:33 +0100")
Message-ID: <87mvr9euhb.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> I'm myself using bcache+btrfs and it ran bullet proof so far, even
> after unintentional resets or power outage. It's important tho to NOT
> put any storage layer between bcache and your devices or between btrfs
> and your device as there are reports it becomes unstable with md or lvm
> involved.

Do you mean I should not use anything in the stack other than btrfs and
bcache, or do you mean I should not put anything under bcache?

In other words, I assume bcache on LVM is a bad idea. But what about LVM
on bcache?

Also, btrfs on LVM on disk is working fine for me, but you seem to be
saying that it should not? Or are you talking specifically about btrfs
on LVM on bcache?


If there's no way to put LVM anywhere into the stack that'd be a bummer,
I very much want to use dm-crypt (and I guess that counts as lvm?).

Thanks,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
