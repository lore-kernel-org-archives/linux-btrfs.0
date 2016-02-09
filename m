Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54026 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757875AbcBIQKR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 11:10:17 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 5B30F2091F
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 11:10:17 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id C6FAFC0001F
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 11:10:16 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id A30561CE4FE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Feb 2016 16:10:15 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Use fast device only for metadata?
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
Date: Tue, 09 Feb 2016 08:10:15 -0800
In-Reply-To: <20160209082933.52273993@jupiter.sol.kaishome.de> (Kai Krakow's
	message of "Tue, 9 Feb 2016 08:29:33 +0100")
Message-ID: <87k2mdeufs.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> You could even format a bcache superblock "just in case",
> and add an SSD later. Without SSD, bcache will just work in passthru
> mode.

Do the LVM concerns still apply in passthrough mode, or only when
there's an actual cache?

Thanks,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
