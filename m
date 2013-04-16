Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:27104 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3DPIoh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:44:37 -0400
Message-ID: <516D0F71.90601@jan-o-sch.net>
Date: Tue, 16 Apr 2013 10:44:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: return error when we specify wrong start
References: <1366101636-26536-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1366101636-26536-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, April 16, 2013 at 10:40 (+0200), Liu Bo wrote:
> We need such a sanity check for wrong start, otherwise, even with
> a wrong start that's larger than file size, we can end up not only
> changing inode's force compress flag but also FS's incompat flags.

That reads out very cryptic. Can you please add something hinting at "defrag" to
the title or at least the description?

Thanks,
-Jan
