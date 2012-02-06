From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: add btrfs online defragments QA test
Date: Mon, 6 Feb 2012 07:11:55 -0500
Message-ID: <20120206121155.GA16044@infradead.org>
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2012 at 04:27:49PM +0800, Liu Bo wrote:
> +_runtest()
> +{
> +	$progs_dir/runtest.sh $defrag_args $SCRATCH_MNT $SCRATCH_DEV

please put the actual tests into test cases themselves instead of
calling out into shell scripts under src.  If you have common code
shared between multiple tests please put them into common.defrag.

> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.defrag
> +
> +# real QA test starts here
> +_supported_fs xfs btrfs

does it really support xfs?

