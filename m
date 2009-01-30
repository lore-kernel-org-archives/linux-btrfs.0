From: Josef Bacik <jbacik@redhat.com>
Subject: Re: report, kernel BUG at fs/btrfs/extent-tree.c:3106
Date: Fri, 30 Jan 2009 08:49:35 -0500
Message-ID: <20090130134935.GB24426@unused.rdu.redhat.com>
References: <20090130143528.2069bf78.ytakahashi@miraclelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090130143528.2069bf78.ytakahashi@miraclelinux.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2009 at 02:35:28PM +0900, Yoshihiro Takahashi wrote:
> Hi.
> 
> I create many files on btrfs of 16GB partition.
> may 13,000,000 files.
> I get this report.
> 
> I think about the following fix.
> When there is not space, return of ENOSPC.
> Or add lock in free extents.
>

Are you just creating files, or are you doing something else?  Thanks,

Josef 
