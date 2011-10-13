From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] 263: Functional test case for the btrfs snapshot
Date: Thu, 13 Oct 2011 11:56:52 +1100
Message-ID: <20111013005652.GM3159@dastard>
References: <4E3BA2F7.4080500@oracle.com>
 <1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
 <1318395174-4075-2-git-send-email-Anand.Jain@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	chris.mason@oracle.com
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1318395174-4075-2-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:52:52PM +0800, Anand Jain wrote:
> Create snapshots in various ways, modify the data around the block and
> file boundaries and verify the data integrity.
....

> +
> +# Create Dir tree and files in it.
> +# arg1 basedir
> +# arg2 dir depth
> +# arg3 nfile_min
> +# arg4 nfile_max
> +# arg5 fsize_min
> +# arg6 fsize_max
> +_fillfs()
> +{
> +	umask 000
> +	local j
> +	local i
> +	local DIRP
> +	local FCNT
> +	local FILEP
> +	local SCNT
> +	local BCNT
> +	DIRP=$6
> +	for ((j=0; j<$1; j++)); do
> +		DIRP=`mktemp -dq $DIRP/dir.XXXXXX`
> +		FCNT=$(_rand_range $2 $3)
> +		for ((i=0; i<$FCNT; i++)); do
> +			FILEP=`mktemp -q $DIRP/file.XXXXXX`
> +			SCNT=$(_rand_range $4 $5)
> +			dd if=/dev/urandom of=$FILEP bs=$SCNT count=1 status=noxfer 2>/dev/null &
> +		done
> +	done
> +	wait $!
> +}

Please, no, not -another- new and just a bit different "fill
filesystem" function.

There's already been one added recently in test 256 which I
commented at the time could use _populate_fs, and I said the same
thing in my original review of this series, too.

So please modify the _populate_fs function to do what you need.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
