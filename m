Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab3GaVTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 17:19:08 -0400
Date: Wed, 31 Jul 2013 14:19:06 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 3/5] Btrfs: introduce a head ref rbtree
Message-ID: <20130731211906.GM32145@lenny.home.zabbo.net>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <1375285066-14173-4-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375285066-14173-4-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +			BUG_ON(!locked_ref);

> +			BUG_ON(!btrfs_delayed_ref_is_head(&head->node));

Please don't add more BUG_ON()s.  They're unreliable because they can
kill the system.

If you *must* have logic asserts, use WARN_ON_ONCE and return errors.
If the path is so dire that the fs is inconsistent, go read only.

- z
