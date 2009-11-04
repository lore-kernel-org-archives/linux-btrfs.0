From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 00/10] btrfs: Error handling/propagation queue
Date: Wed, 04 Nov 2009 14:43:18 -0500
Message-ID: <4AF1D956.1020407@suse.com>
References: <20091104190346.971762946@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091104190346.971762946@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2009 02:03 PM, Jeff Mahoney wrote:
>  This patch series fixes a few existing problems and then addresses
>  the need for better error handling and propagation in btrfs.
> 
>  The handling and propagation patch set first finds all locations of
>  a particular condition not being checked and annotates them with
>  BTRFS_UERROR to designate that there is an error condition that
>  is currently unhandled but should be. Then, another patch traverses
>  the call path to ensure that errors are properly propogated. When the
>  fix for recovering or passing the error is obvious, we do that too.
> 
>  This set is not complete and I expect there to be more fixes coming. In
>  particular, it currently only annotates btrfs_alloc_path failures as
>  the call graph for it is quite large. This is in response to Chris asking
>  for what I already have instead of waiting for it to be complete.

I should be clear that this is just what I've been working on so far and
hasn't received any testing yet. It was a quick quilt mail in the middle
of working on it. (As you might notice by the fact that it doesn't build.)

-Jeff

-- 
Jeff Mahoney
SUSE Labs
