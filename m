From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Changes to received review comments
Date: Mon, 10 Oct 2011 07:21:52 -0400
Message-ID: <20111010112151.GA28627@infradead.org>
References: <4E3BA2F7.4080500@oracle.com>
 <4E44351D.4020202@oracle.com>
 <20110902084941.GB29054@infradead.org>
 <4E92C1D7.2010301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E92C1D7.2010301@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2011 at 05:58:47PM +0800, Anand Jain wrote:
>  Now SCRATCH_DEV is derived from SCRATCH_DEV_POOL.
>  Moved code to delete and scan block device to common.rc and
>  updated README.

Can you resend the whole patch?   Note that xfstests is up to test 262
in the meantime, so it will also need to be renumbered.

