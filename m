Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44365 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab3DPJRU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:17:20 -0400
Date: Tue, 16 Apr 2013 17:13:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: return error when we specify wrong start
Message-ID: <20130416091336.GA26176@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1366101636-26536-1-git-send-email-bo.li.liu@oracle.com>
 <516D0F71.90601@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516D0F71.90601@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 10:44:33AM +0200, Jan Schmidt wrote:
> On Tue, April 16, 2013 at 10:40 (+0200), Liu Bo wrote:
> > We need such a sanity check for wrong start, otherwise, even with
> > a wrong start that's larger than file size, we can end up not only
> > changing inode's force compress flag but also FS's incompat flags.
> 
> That reads out very cryptic. Can you please add something hinting at "defrag" to
> the title or at least the description?

Oh yeah, my bad.

thanks,
liubo

> 
> Thanks,
> -Jan
