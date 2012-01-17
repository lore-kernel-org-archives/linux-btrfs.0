From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix enospc error caused by wrong checks of the
 chunk allocation
Date: Tue, 17 Jan 2012 11:39:03 -0500
Message-ID: <20120117163903.GD30322@shiny>
References: <4F153E33.8070803@cn.fujitsu.com>
 <CAKcLGm_HRMWcg4Aze59EFjQARbnQTSCxyfyPB4bS3f2R4kfvuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: miaox@cn.fujitsu.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_HRMWcg4Aze59EFjQARbnQTSCxyfyPB4bS3f2R4kfvuQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 10:31:00AM -0600, Mitch Harder wrote:
> On Tue, Jan 17, 2012 at 3:24 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
> After applying this patch to the re-based integration branch, I was
> able to clear an EFBIG error (that seemed to be related to chunk
> allocation) I had previously been receiving while trying to balance a
> partially corrupted partition.
> 
> I was receiving this bug from the btrfs_add_system_chunk() function
> which had do_chunk_alloc() close up in the callback list.

The EFBIG error was my bug.  There's a commit in the new integration
branch that fixes it (and an earlier one in integration that adds it)

-chris

