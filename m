Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcm9-314.freemail.mail.aliyun.com ([110.75.46.14]:47070 "EHLO
	mtpcm9-314.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895Ab3H2HVc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 03:21:32 -0400
Date: Thu, 29 Aug 2013 15:21:29 +0800
From: "lilofile" <lilofile@aliyun.com>
To: <linux-btrfs@vger.kernel.org>
Message-ID: <52dae6f2-592a-4cfc-b421-9b54167d083c@aliyun.com>
Subject: =?UTF-8?B?cXVlc3Rpb246cmVwbGFjZQ==?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The replace operation depends on scrub and makes use of the scrub code.
And scrub does not yet support RAID5/6. Therefore 'btrfs replace start'
fails with EINVAL on RAID5/6 filesystems.


like linux md raid5 support rescontruct ,btrfs raid5 has plan to support resconstructing?
