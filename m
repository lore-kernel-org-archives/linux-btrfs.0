From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a missing block_rsv reset
Date: Thu, 20 Oct 2011 08:49:05 -0400
Message-ID: <20111020124904.GA2353@localhost.localdomain>
References: <1319102718-17767-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com, chb@muc.de
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1319102718-17767-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2011 at 05:25:18PM +0800, Liu Bo wrote:
> In commit ab1ca99b51df63901617b9f10f9a36d5d4972d78
> (Btrfs: reset to appropriate block rsv after orphan operations),
> we miss a block_rsv reset and this sometimes leads us to
> the WARNING of btrfs_orphan_commit_root().
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Actually this needs to be converted over to the proper way to truncate things.
I'll write that up and send a patch.  Thanks,

Josef
