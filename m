Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:57681 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920Ab3CORHJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 13:07:09 -0400
Message-ID: <51435555.2020706@sgi.com>
Date: Fri, 15 Mar 2013 12:07:33 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
References: <5140A2BC.7010800@redhat.com>
In-Reply-To: <5140A2BC.7010800@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric,

Thanks once more for the patch.  Once I finally got the correct version 
of mkfs.btrfs this looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Interesting that the default make install of btrfs-progs did not install 
over my btrfsprogs rpm.

Was running SLES11 SP2 with btrfsprogs-0.19-5.31.1.x86_64.

It did not put mkfs.btrfs in /sbin.  This did however, validate all the 
error paths ;).

--Rich




On 03/13/2013 11:01 AM, Eric Sandeen wrote:
> Now that btrfs has an "-f" arg, we can test that it doesn't
> improperly overwrite other filesystems in 032 like we do
> for xfs.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/032 b/032
> index bf88492..89fb225 100755
> --- a/032
> +++ b/032
> @@ -38,12 +38,18 @@ rm -f $seq.full
>   . ./common.filter
>
>   # real QA test starts here
> -_supported_fs xfs
> +_supported_fs xfs btrfs
>   _supported_os Linux
>
>   _require_nobigloopfs
>   _require_scratch
>
> +# mkfs.btrfs did not have overwrite detection at first
> +if [ "$FSTYP" == "btrfs" ]; then
> +	grep -q 'force overwrite' `echo $MKFS_BTRFS_PROG | awk '{print $1}'` || \
> +		_notrun "Installed mkfs.btrfs does not support -f option"
> +fi
> +
>   echo "Silence is golden."
>   for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
>   do
> @@ -61,7 +67,7 @@ do
>   	[ $fs = gfs2 ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
>   	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
>   	# cramfs mkfs requires a directory argument
> -	[ $fs = cramfs ] && preargs=/proc/fs/xfs
> +	[ $fs = cramfs ] && preargs=/proc/fs
>   	[ $fs = ext2 ] && preargs="-F"
>   	[ $fs = ext3 ] && preargs="-F"
>   	[ $fs = ext4 ] && preargs="-F"
> @@ -77,8 +83,8 @@ do
>
>   	if [ $? -eq 0 ] ; then
>   		# next, ensure we don't overwrite it
> -		echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
> -		${MKFS_PROG}.xfs $SCRATCH_DEV >>$seq.full 2>&1
> +		echo "=== Attempting $FSTYP overwrite of $fs..." >>$seq.full
> +		${MKFS_PROG}.$FSTYP $SCRATCH_DEV >>$seq.full 2>&1
>
>   		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
>   	else
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>


