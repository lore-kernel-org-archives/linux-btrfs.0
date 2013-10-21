Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcm9-312.freemail.mail.aliyun.com ([110.75.46.12]:58662 "EHLO
	smtpcm9-312.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab3JUQFh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 12:05:37 -0400
Date: Tue, 22 Oct 2013 00:05:36 +0800
From: "lilofile" <lilofile@aliyun.com>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Reply-To: "lilofile" <lilofile@aliyun.com>
Message-ID: <43b04d83-e99a-4ac4-abbb-1c4ba32262ea@aliyun.com>
Subject: =?UTF-8?B?YnRyZnMgZmx1c2ggZGF0YSBjYWNoZQ==?=
MIME-Version: 1.0
References: 0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com,547ffa6f-f5d8-45d1-8412-ec9890928173@aliyun.com
In-Reply-To: 547ffa6f-f5d8-45d1-8412-ec9890928173@aliyun.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


transaction_kthread  can periodically commit data and metedata to disk,similarly btrfs_writepages can write data page to disk, in which situation btrfs_writepages function is called? and i cannot find btrfs_writepages is called in btrfs code?  who can tell me?
