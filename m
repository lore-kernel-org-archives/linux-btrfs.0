From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: refactor btrfs_check_data_free_space
Date: Tue, 29 Sep 2009 13:12:17 -0400
Message-ID: <20090929171217.GC2650@think>
References: <1253913056-8385-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1253913056-8385-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 02:10:55PM -0700, Sage Weil wrote:
> Pull out the actual free space check, so setting an inode's initial
> space_info is done by the caller instead of a wonky goto.
> 

Hi Sage,

I've just pushed out an updated enospc branch.  Could you please verify
your patches against it?  If you and Josef are happy with them, I'll
pull them in.

-chris

