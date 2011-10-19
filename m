From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] 265: Functional test case for the btrfs
 de-fragmentation
Date: Wed, 19 Oct 2011 05:43:56 -0400
Message-ID: <20111019094356.GC3083@infradead.org>
References: <20111013005652.GM3159@dastard>
 <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
 <1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2011 at 02:28:55PM +0800, Anand Jain wrote:
> To verify the btrfs de-fragmentation does not fail.

Any reason you can't simply fold btrfs defragmentation testing into
the existing common defragmentation test (218)?
