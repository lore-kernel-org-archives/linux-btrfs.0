Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51832 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbcEMP2V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 11:28:21 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 20080205A8
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 11:28:20 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id CA122C00013
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 11:28:19 -0400 (EDT)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id DDE622A6091
	for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 15:28:18 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
	<pan$14f07$a448b38$b8e37f4a$116d54ce@cox.net>
Date: Fri, 13 May 2016 08:28:18 -0700
In-Reply-To: <pan$14f07$a448b38$b8e37f4a$116d54ce@cox.net> (Duncan's message
	of "Fri, 13 May 2016 06:36:45 +0000 (UTC)")
Message-ID: <87vb2ij7u5.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 13 2016, Duncan <1i5t5.duncan@cox.net> wrote:
> Because btrfs can be multi-device, it needs some way to track which 
> devices belong to each filesystem, and it uses filesystem UUID for this 
> purpose.
>
> If you clone a filesystem (for instance using dd or lvm snapshotting, 
> doesn't matter how) and then trigger a btrfs device scan, say by plugging 
> in some other device with btrfs on it so udev triggers a scan, and the 
> kernel sees multiple devices with the same filesystem UUID as a result, 
> and one of those happens to be mounted, you can corrupt both copies as 
> the kernel btrfs won't be able to tell them apart and may write updates 
> to the wrong one.

That seems like a rather odd design. Why isn't btrfs refusing to mount
in this situation? In the face of ambiguity, guessing is generally bad
idea (at least for a computer program).


Best,
-Nikolaus
-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
