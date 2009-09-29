From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 1/2] Btrfs: refactor btrfs_check_data_free_space
Date: Tue, 29 Sep 2009 11:49:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0909291145380.20862@cobra.newdream.net>
References: <1253913056-8385-1-git-send-email-sage@newdream.net>
 <20090929171217.GC2650@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090929171217.GC2650@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Sep 2009, Chris Mason wrote:

> On Fri, Sep 25, 2009 at 02:10:55PM -0700, Sage Weil wrote:
> > Pull out the actual free space check, so setting an inode's initial
> > space_info is done by the caller instead of a wonky goto.
> > 
> 
> Hi Sage,
> 
> I've just pushed out an updated enospc branch.  Could you please verify
> your patches against it?  If you and Josef are happy with them, I'll
> pull them in.

I'm resending rebased patches now (things changed a bit).  The first 
cleanup patch is unrelated to ENOSPC, but needed for the last one to 
apply, and I didn't see it pushed out yet.

Josef, does the ioctl trans reservation (4/4) look reasonable?  It can 
fall over if you mix ioctl transactions and regular work, but that's not 
really avoidable without a more fundamental change to the API (see my 
email from last week).

thanks-
sage
