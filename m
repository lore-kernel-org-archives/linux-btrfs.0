Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbcFNKWZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 06:22:25 -0400
Date: Tue, 14 Jun 2016 18:22:23 +0800
From: Eryu Guan <eguan@redhat.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, fdmanana@gmail.com
Subject: Re: [PATCH v4] fstests: btrfs: add test for qgroup handle extent
 de-reference
Message-ID: <20160614102223.GR5140@eguan.usersys.redhat.com>
References: <1465868559-10997-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465868559-10997-1-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 09:42:39AM +0800, Lu Fengqi wrote:
> Test if qgroup can handle extent de-reference during reallocation.
> "extent de-reference" means that reducing an extent's reference count
> or freeing an extent.
> Although current qgroup can handle it, we still need to prevent any
> regression which may break current qgroup.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>
