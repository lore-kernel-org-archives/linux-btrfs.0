Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18942 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbaKIXp1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Nov 2014 18:45:27 -0500
Date: Mon, 10 Nov 2014 10:45:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: add generic test to verify xattr replace
 operations are atomic
Message-ID: <20141109234522.GK28565@dastard>
References: <1415392826-11606-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415392826-11606-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 07, 2014 at 08:40:26PM +0000, Filipe Manana wrote:
> This test verifies that replacing a xattr's value is an atomic
> operation. This is motivated by an issue in btrfs where replacing
> a xattr's value wasn't an atomic operation, it consisted of
> removing the old value and then inserting the new value in a
> btree. This made readers (getxattr and listxattrs) not getting
> neither the old nor the new value during a short time window.

OK, seems like a good thing to test that the application can only
see the old or the new value.

However, I can't help but wonder about whether the btrfs behaviour
is crash safe as it wasn't designed to be atomic from the ground up.
i.e. if the system crashes half way through a attribute overwrite,
what does btrfs end up with as a result? XFS is guaranteed at a
transactional level to return either the old or the new value,
depending on where in the operaiton the crash occurred, but I'd just
assumed that everyone did attribute replace atomically so it never
occurred to me that it might be an issue...

Perhaps another test involving dm-flakey to trigger errors and
shutdowns whilst in the middle of replacing attributes might be a
good thing?

[....]

> +_cleanup()
> +{
> +	if [ ! -z $setter_pid ]; then
> +		kill $setter_pid &> /dev/null
> +	fi

No need to do this if[] then. You're already redirecting all errors
to /dev/null, so if $setter_pid is empty it will just output the
help string.

> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_attrs
> +
> +rm -f $seqres.full
> +
> +xattr_name="user.something"
> +xattr_value1="foobar"
> +xattr_value2="rabbit_hole"
> +
> +set_xattr_loop()
> +{
> +	local name=$1
> +
> +	local cur_val=$xattr_value1
> +	while true; do
> +		$SETFATTR_PROG -n $xattr_name -v $cur_val $SCRATCH_MNT/$name
> +		if [ "$cur_val" == "$xattr_value1" ]; then
> +			cur_val=$xattr_value2
> +		else
> +			cur_val=$xattr_value1
> +		fi
> +	done
> +}
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +test_file="test_xattr_replace"
> +touch $SCRATCH_MNT/$test_file
> +$SETFATTR_PROG -n $xattr_name -v $xattr_value1 $SCRATCH_MNT/$test_file
> +
> +set_xattr_loop $test_file &
> +setter_pid=$!
> +
> +for ((i = 0; i < 1000; i++)); do
> +	xattr_val=$($GETFATTR_PROG --absolute-names -n $xattr_name \
> +		$SCRATCH_MNT/$test_file | grep "$xattr_name=" | cut -d '=' -f 2)
> +	if [ "$xattr_val" != "\"$xattr_value1\"" -a \
> +		"$xattr_val" != "\"$xattr_value2\"" ]; then
> +		_fail "Missing or unexpected xattr value: $xattr_val"
> +	fi

I'd suggest that a filter is a much better way to do this.

name_filter() {
	grep "$xattr_name=" | cut -d '=' -f 2 | \
		sed -e "s/$xattr_value1/GOOD/" \
		    -e "s/$xattr_value2/GOOD/"
}

for (); do
	$GETFATTR_PROG --absolute-names -n $xattr_name \
		$SCRATCH_MNT/$test_file | name_filter
done

And so the output file should just be:

GOOD
GOOD
....

And if it is bad, then it outputs the bad attribute value instead
of "GOOD", and the test fails on the golden output match.

> +kill $setter_pid &> /dev/null
> +unset setter_pid

See above, no need to unset the var.
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/326.out b/tests/generic/326.out
> new file mode 100644
> index 0000000..4ac0db5
> --- /dev/null
> +++ b/tests/generic/326.out
> @@ -0,0 +1,2 @@
> +QA output created by 326
> +Silence is golden

Except when you are using comparisons and "_fail" instead of
filters. ;)

BTW, new tests should be numbere as the first unused number, not at
the tail (i.e generic/036). If there are collisions with other new
tests when I merge them, I'll renumber them at merge time.

>  323 auto aio stress
>  324 auto fsr quick
>  325 auto quick data log
> +326 auto quick xattr

There is no existing xattr group - normally xattr tests are
considered part of the "metadata" group. If you want to introduce an
xattr test group, do it as a separate patch and include all the
tests (across all the test directories) that manipulate xattrs in
some way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
