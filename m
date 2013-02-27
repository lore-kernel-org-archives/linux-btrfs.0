Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3B0VbP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 16:31:15 -0500
Date: Wed, 27 Feb 2013 13:31:05 -0800
From: Zach Brown <zab@redhat.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: Re: [PATCH 2/3] Btrfs: return ENOMEM rather than use BUG_ON when
 btrfs_alloc_path fails
Message-ID: <20130227213105.GN1658@lenny.home.zabbo.net>
References: <1361964056-2455-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361964056-2455-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Return ENOMEM rather trigger BUG_ON, fix it.

These changes look good.  The resulting surrounding state buildup and
cleanup paths look correct.

Thanks for helping remove a few more BUG_ON()s :).

Reviewed-by: Zach Brown <zab@redhat.com>

