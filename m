Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44771 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab2KPOUO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 09:20:14 -0500
Date: Fri, 16 Nov 2012 15:19:49 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH 1/2] Btrfs: fix a deadlock in aborting transaction due to
 ENOSPC
Message-ID: <20121116141948.GA3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352119329-18716-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 05, 2012 at 08:42:08PM +0800, Liu Bo wrote:
> When committing a transaction, we may bail out of running delayed refs
> due to ENOSPC, and then abort the current transaction to flip into readonly.
> 
> But we'll hit a deadlock on ref head's lock since we forget to release
> its lock and other cleanup stuff.

Miao sent a patch for this on Tue, 08 May 2012

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16361.html

and it does more things than just the unlock, I can't tell which one of
the patches is the right one, only letting you know.

david
