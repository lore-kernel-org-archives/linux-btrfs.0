Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36010 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaEHEQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 00:16:28 -0400
Message-ID: <536B051B.20400@sandeen.net>
Date: Wed, 07 May 2014 23:16:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: fix flink test
References: <1399496087-20431-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399496087-20431-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/7/14, 3:54 PM, Josef Bacik wrote:
> I don't have flink support in my xfsprogs, but it doesn't fail with "command not
> found" or whatever, it fails because I don't have the -T option.  So fix
> _require_xfs_io_command to check for an invalid option and not run.  This way I
> get notrun instead of a failure.  Thanks,

This actually doesn't work for me on an old kernel, if that matters; it
fails with:

/mnt/test: Is a directory

and nothing catches that.  Old xfsprogs tries to open the file
in question RDWR even before it gets to the -T option (which
would fail, I guess), and you can't do that for directories.

So I suppose we could explicitly test for that when checking
flink:

        [ $command = "flink" ] && echo $testio | grep -q "Is a directory" && \
                _notrun "xfs_io flink support is missing"

or alternately, first just run xfs_io w/ the command but no file;
today, at least, that works:

[root@bp-05 xfstests]# xfs_io -c flink
command "flink" not found
[root@bp-05 xfstests]# xfs_io -c pread
[root@bp-05 xfstests]# 

so could do this before the case statement:

        $XFS_IO_PROG -c $command 2>&1 | grep -q "not found" && \
                _notrun "xfs_io $command support is missing"

but that might be subject to future changes in xfs_io command
parsing...

-Eric


> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  common/rc | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5c13db5..4fa7e63 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1258,6 +1258,8 @@ _require_xfs_io_command()
>  		_notrun "xfs_io $command support is missing"
>  	echo $testio | grep -q "Operation not supported" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
> +	echo $testio | grep -q "invalid option" && \
> +		_notrun "xfs_io $command support is missing"
>  }
>  
>  # Check that a fs has enough free space (in 1024b blocks)
> -- 1.8.3.1 _______________________________________________ xfs mailing list xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

