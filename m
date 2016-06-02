Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33025 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbcFBDFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 23:05:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 707F120D05
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 23:05:04 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 2A6FDF2022
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 23:05:04 -0400 (EDT)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id CC42F2D417D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 03:05:02 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Problems with storing Mercurial repositories
Date: Wed, 01 Jun 2016 20:05:03 -0700
Message-ID: <87h9dc5m00.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

A little while ago I noticed that a btrfsck of my home directory
produced a *lot* of the following errors:

[...]
checking fs roots
root 5 inode 3149867 errors 400, nbytes wrong
root 5 inode 3150237 errors 400, nbytes wrong
root 5 inode 3150238 errors 400, nbytes wrong
[...]

I've now piped all the inodes through "btrfs inspect-internal
inode-resolve" and made a surprising discovery: every affected inode is
a .i file in the ".hg/store/data/" directory of a Mercurial
repository. This affects multiple repositories of different projects
created and modified at different times.

As far as Mercurial is concerned, there seems to be no problem. I can
operate on the repository as always, and "hg verify" finds no issues
either.

I'm reporting this here mainly so there's a record of the
phenomenon. But if there is a btrfs test suite, maybe it'd be a good
idea to add a bunch of Mercurial repository operations to it?

Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
