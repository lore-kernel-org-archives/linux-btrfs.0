From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 0/4] Btrfs: fix ENOSPC regressions
Date: Fri, 15 Oct 2010 17:37:17 -0400
Message-ID: <20101015213717.GB5631@localhost.localdomain>
References: <1287178115-18229-1-git-send-email-josef@redhat.com> <20101015213558.GA28640@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101015213558.GA28640@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 15, 2010 at 05:35:58PM -0400, Christoph Hellwig wrote:
> On Fri, Oct 15, 2010 at 05:28:31PM -0400, Josef Bacik wrote:
> > This patchset fixes some problems with the ENOSPC code for block groups, but
> > more importantly it fixes a huge ENOSPC regression that's occured.  With my
> > fs_mark test
> > 
> > fs_mark -d /mnt/btrfs-test -D 512 -t 16 -n 4096 -F -S0
> > 
> > on a 2gb fs without these patches fs_mark would exit out with ENOSPC after
> > writing around 50mb.
> 
> CAre to add the test to xfstests?  We already have a _scratch_mkfs_sized
> helper to create filesystems of a specific size for ENOSPC tests.

Yup I will do that first thing on Monday.  Thanks,

Josef 
