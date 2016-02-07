Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39022 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbcBGTHC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 14:07:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 4B56820BBB
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Feb 2016 14:07:01 -0500 (EST)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 0E6BE6800FA
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Feb 2016 14:07:01 -0500 (EST)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 49DE71C9E1E
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Feb 2016 19:07:00 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Use fast device only for metadata?
Date: Sun, 07 Feb 2016 11:06:58 -0800
Message-ID: <874mdktk4t.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a large home directory on a spinning disk that I regularly
synchronize between different computers using unison. That takes ages,
even though the amount of changed files is typically small. I suspect
most if the time is spend walking through the file system and checking
mtimes.

So I was wondering if I could possibly speed-up this operation by
storing all btrfs metadata on a fast, SSD drive. It seems that
mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
file contents in single mode. However, I could not find a way to tell
btrfs to use a device *only* for metadata. Is there a way to do that?

Also, what is the difference between using "dup" and "raid1" for the
metadata? 

Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
