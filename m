Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcm9-317.freemail.mail.aliyun.com ([110.75.46.17]:54720 "EHLO
	smtpcm9-317.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab3JTPYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 11:24:34 -0400
Date: Sun, 20 Oct 2013 23:19:26 +0800
From: "lilofile" <lilofile@aliyun.com>
To: <linux-btrfs@vger.kernel.org>
Reply-To: "lilofile" <lilofile@aliyun.com>
Message-ID: <1c7f1ff8-7161-4e67-9acc-eb5d4b8b965d@aliyun.com>
Subject: =?UTF-8?B?cXVlc3Rpb24=?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


when i read transaction_kthread function in disk-io.c 

delay = HZ * 30;

why commit transaction is 30 seconds,  Other values 20 seconds,10 seconds?
what considerations about the commit transaction interval?


