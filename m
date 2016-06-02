Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58337 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbcFBDHB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 23:07:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 2B22220B6C
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 23:07:00 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id DCAC1F29EE
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 23:06:59 -0400 (EDT)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id B39902D417E
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 03:06:58 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: How to map extents to files
Date: Wed, 01 Jun 2016 20:06:58 -0700
Message-ID: <87eg8g5lwt.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

For one of my btrfs volumes, btrfsck reports a lot of the following
warnings:

[...]
checking extents
bad extent [138477568, 138510336), type mismatch with chunk
bad extent [140091392, 140148736), type mismatch with chunk
bad extent [140148736, 140201984), type mismatch with chunk
bad extent [140836864, 140865536), type mismatch with chunk
[...]

Is there a way to discover which files are affected by this (in
particular so that I can take a look at them before and after a btrfsck
--repair)?


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
