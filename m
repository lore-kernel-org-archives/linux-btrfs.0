Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22836 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbaBGWti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 17:49:38 -0500
Date: Sat, 8 Feb 2014 09:49:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: Btrfs: add test for large metadata blocks
Message-ID: <20140207224934.GH13647@dastard>
References: <1391793285-935-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391793285-935-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 07, 2014 at 06:14:45PM +0100, Koen De Wit wrote:
> Tests Btrfs filesystems with all possible metadata block sizes, by
> setting large extended attributes on files.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>

There's a few things here that need fixing.

> +pagesize=`$here/src/feature -s`
> +pagesize_kb=`expr $pagesize / 1024`
> +
> +# Test all valid leafsizes
> +for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do
> +    _scratch_unmount >/dev/null 2>&1

Indentation are tabs, and tabs are 8 spaces in size, please.

> +    _scratch_mkfs -l ${leafsize}K >/dev/null
> +    _scratch_mount

No need to use _scratch_unmount here - you should be doing a
_check_scratch_fs at the end of the loop.

> +    # Calculate the xattr size, but leave 512 bytes for other metadata.
> +    xattr_size=`expr $leafsize \* 1024 - 512`
> +
> +    touch $SCRATCH_MNT/emptyfile
> +    # smallfile will be inlined, bigfile not.
> +    $XFS_IO_PROG -f -c "pwrite 0 100" $SCRATCH_MNT/smallfile >/dev/null
> +    $XFS_IO_PROG -f -c "pwrite 0 9000" $SCRATCH_MNT/bigfile >/dev/null
> +    ln -s $SCRATCH_MNT/bigfile $SCRATCH_MNT/bigfile_softlink
> +
> +    files=(emptyfile smallfile bigfile bigfile_softlink)
> +    chars=(a b c d)
> +    for i in `seq 0 1 3`; do
> +        char=${chars[$i]}
> +        file=$SCRATCH_MNT/${files[$i]}
> +        lnkfile=${file}_hardlink
> +        ln $file $lnkfile
> +        xattr_value=`head -c $xattr_size < /dev/zero | tr '\0' $char`
> +
> +        set_md5=`echo -n "$xattr_value" | md5sum`

Just dump the md5sum to the output file.

> +        ${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file

> +        get_md5=`${ATTR_PROG} -Lq -g attr_$char $file | md5sum`
> +        get_ln_md5=`${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum`

And dump these to the output file, too. Then the golden image
matching when the test is finish will tell you if it passed or not.
i.e:

	echo -n "$xattr_value" | md5sum
	${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
	${ATTR_PROG} -Lq -g attr_$char $file | md5sum
	${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum

is all that neds to be done here.

> +    # Test attributes with a size larger than the leafsize.
> +    # Should result in an error.
> +    if [ "$leafsize" -lt "64" ]; then
> +        # Bash command lines cannot be larger than 64K characters, so we
> +        # do not test attribute values with a size >64KB.
> +        xattr_size=`expr $leafsize \* 1024 + 512`
> +        xattr_value=`head -c $xattr_size < /dev/zero | tr '\0' x`
> +        ${ATTR_PROG} -q -s attr_toobig -V $xattr_value \
> +            $SCRATCH_MNT/emptyfile >> $seqres.full 2>&1
> +        if [ "$?" -eq "0" ]; then
> +            echo "Expected error, xattr_size is bigger than ${leafsize}K"
> +        fi

What you are doing is redirecting the error to $seqres.full
so that it doesn't end up in the output file, then detecting the
absence of an error and dumping a message to the output file to make
the test fail.

IOWs, the ATTR_PROG failure message should be in the golden output
file and you don't have to do anything else to detect a pass/fail
condition.

> +_scratch_unmount
> +
> +# Some illegal leafsizes
> +
> +_scratch_mkfs -l 0 2>> $seqres.full
> +echo $?

Same again - you are dumping the error output into a different file,
then detecting the error manually. pass the output of _scratch_mkfs
through a filter, and let errors cause golden output mismatches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
