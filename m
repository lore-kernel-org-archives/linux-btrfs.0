Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753530AbeBLPn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:43:56 -0500
Date: Mon, 12 Feb 2018 16:33:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: fix INODE_ITEM sequence and
 flags
Message-ID: <20180212153338.GH3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212152126.17984-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212152126.17984-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:21:26PM +0800, Anand Jain wrote:
> dump-tree prints wrong sequence number and the flags numbers,
> as we misplaced the printf args. This patch fixes it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
