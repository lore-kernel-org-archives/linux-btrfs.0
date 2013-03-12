Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CLBqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 21:46:30 -0400
Date: Tue, 12 Mar 2013 09:44:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get better concurrency for snapshot-aware defrag
 work
Message-ID: <20130312014402.GC31527@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
 <20130311172640.GF7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130311172640.GF7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 06:26:40PM +0100, David Sterba wrote:
> On Mon, Mar 11, 2013 at 05:20:58PM +0800, Liu Bo wrote:
> > Using spinning case instead of blocking will result in better concurrency
> > overall.
> 
> Do you have numbers to support that?
> 

Sorry, I don't, just judging from what leave_spinning is desiged for and the
similar usecases, like insert_reserved_file_extents(), which is also involved in
endio write worker.

thanks,
liubo
