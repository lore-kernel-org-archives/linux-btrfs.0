From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add new getdents test
Date: Tue, 13 Sep 2011 08:58:28 -0400
Message-ID: <20110913125828.GA19796@infradead.org>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Grazvydas Ignotas <notasas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315786747-12109-1-git-send-email-notasas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2011 at 03:19:07AM +0300, Grazvydas Ignotas wrote:
> The test checks if no duplicate d_off values are returned and that
> those values are seekable to the right inodes.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Thanks a lot!  I've applied it locally and will push it out as soon
as kernel.org is back up.

