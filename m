Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbbDBPpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 11:45:41 -0400
Date: Thu, 2 Apr 2015 17:45:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: convert-test: Add test for converting
 ext* with regular file extent.
Message-ID: <20150402154540.GM6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427941296-19502-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1427941296-19502-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427941296-19502-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 02, 2015 at 10:21:36AM +0800, Qu Wenruo wrote:
> Before previous patch, btrfs-convert will result fsck complain if there
> is any regular file extent in newly converted btrfs.
> 
> Add test case for it.

Please separate the changes that update generic code and the test
itself.

> +script_dir=$(dirname $(realpath $0))
> +top=$(realpath $script_dir/../)

Please use upper case names.

> +TEST_DEV=${TEST_DEV:-}
> +TEST_MNT=${TEST_MNT:-$top/tests/mnt}
> +RESULT="$top/tests/convert-tests-results.txt"

RESULTS

> +IMAGE="$script_dir/test.img"
>  
> -_fail()
> -{
> -	echo "$*" | tee -a convert-tests-results.txt
> -	exit 1
> -}
> +source $top/tests/common
> +export top
> +export RESULT
> +# For comprehensive convert test which needs write something into ext*
> +export TEST_MNT
> +export LANG
> +
> +rm -f $RESULT
> +mkdir -p $TEST_MNT || _fail "unable to create mount point on $TEST_MNT"
> +
> +# test reply on btrfs-convert
> +check_prereq btrfs-convert
> +check_prereq btrfs
>  
> -rm -f convert-tests-results.txt
>  
> -test(){
> +convert_test(){
>  	echo "    [TEST]   $1"
>  	nodesize=$2
>  	shift 2
> -	echo "creating ext image with: $*" >> convert-tests-results.txt
> +	echo "creating ext image with: $*" >> $RESULT
>  	# 256MB is the smallest acceptable btrfs image.
> -	rm -f $here/test.img >> convert-tests-results.txt 2>&1 \
> +	rm -f $IMAGE >> $RESULT 2>&1 \
>  		|| _fail "could not remove test image file"
> -	truncate -s 256M $here/test.img >> convert-tests-results.txt 2>&1 \
> +	truncate -s 256M $IMAGE >> $RESULT 2>&1 \
>  		|| _fail "could not create test image file"
> -	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
> +	$* -F $IMAGE >> $RESULT 2>&1 \
>  		|| _fail "filesystem create failed"
> -	$here/btrfs-convert -N "$nodesize" $here/test.img \
> -			>> convert-tests-results.txt 2>&1 \
> +
> +	# write a file with regular file extent
> +	$SUDO_HELPER mount $IMAGE $TEST_MNT
> +	$SUDO_HELPER dd if=/dev/zero bs=$nodesize count=4 of=$TEST_MNT/test \
> +		1>/dev/null 2>&1
> +	$SUDO_HELPER umount $TEST_MNT
> +
> +	# do convert test
> +	$top/btrfs-convert -N "$nodesize" $script_dir/test.img \

$IMAGE instead of "$script_dir/test.img"

> +			>> $RESULT 2>&1 \
>  		|| _fail "btrfs-convert failed"
> -	$here/btrfs check $here/test.img >> convert-tests-results.txt 2>&1 \

same here

> +	$top/btrfs check $script_dir/test.img >> $RESULT 2>&1 \

and here

>  		|| _fail "btrfs check detected errors"

Thanks.
