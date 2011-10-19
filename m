From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] 266: Functional test case for the btrfs raid
 operations
Date: Wed, 19 Oct 2011 05:45:27 -0400
Message-ID: <20111019094527.GD3083@infradead.org>
References: <20111013005652.GM3159@dastard>
 <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
 <1318919336-32206-4-git-send-email-Anand.Jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1318919336-32206-4-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> +    if [ $dev_removed == 1 ]; then
> +	umount $SCRATCH_MNT
> +        _devmgt_add "${DEVHTL}"
> +    fi

messy indendation.

> +	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
> +	#btrfs filesystem show $SCRATCH_DEV 2>&1 | egrep devid |awk '{
> +	#	if ( $6 == "0.00" ) { exit 1 }
> +	#}' || _fail "test6_add... failed"

what is the point of the commented out code?

otherwise looks good to me.
