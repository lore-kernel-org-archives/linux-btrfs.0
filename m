Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcm9-306.freemail.mail.aliyun.com ([110.75.46.6]:36796 "EHLO
	smtpcm9-306.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab3H2Cn6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 22:43:58 -0400
Date: Thu, 29 Aug 2013 10:43:55 +0800
From: "lilofile" <lilofile@aliyun.com>
To: <linux-btrfs@vger.kernel.org>
Message-ID: <e7f09cfe-e763-4e9c-a7b0-c44afce5c6ce@aliyun.com>
Subject: =?UTF-8?B?YnRyZnMgcmFpZDUgcXVlc3Rpb24=?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs raid5, The replace operation depends on scrub and makes use of the scrub code.
And scrub does not yet support RAID5/6. Therefore 'btrfs replace start'
fails with EINVAL on RAID5/6 filesystems.

when does the replace function is added? who can tell me the plan?



