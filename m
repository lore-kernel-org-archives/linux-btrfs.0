Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61839 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdG1B1w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 21:27:52 -0400
Subject: Re: [PATCH 4/5] btrfs-progs: tests: fix typo in
 convert-tests/008-readonly-image
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20170727154723.2208-1-jeffm@suse.com>
 <20170727154723.2208-5-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <631583cc-d84e-d1d5-96f0-99ad6b083fb9@gmx.com>
Date: Fri, 28 Jul 2017 09:27:10 +0800
MIME-Version: 1.0
In-Reply-To: <20170727154723.2208-5-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月27日 23:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The dd in convert-tests/008-readonly-image is expected to fail, so
> there being a typo in the file name has gone unnoticed.

Thanks for catching this.
This is very embarrassing.

> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>   tests/convert-tests/008-readonly-image/test.sh | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/convert-tests/008-readonly-image/test.sh b/tests/convert-tests/008-readonly-image/test.sh
> index 27c9373..cc846fa 100755
> --- a/tests/convert-tests/008-readonly-image/test.sh
> +++ b/tests/convert-tests/008-readonly-image/test.sh
> @@ -14,9 +14,10 @@ convert_test_prep_fs $default_mke2fs
>   run_check_umount_test_dev
>   convert_test_do_convert
>   run_check_mount_test_dev
> +run_check e2fsck -n "$TEST_MNT/ext2_saved/image"
>   
>   # It's expected to fail
> -$SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/ext2_save/image" bs=1M count=1 \
> +$SUDO_HELPER dd if=/dev/zero of="$TEST_MNT/ext2_saved/image" bs=1M count=1 \
>   	&> /dev/null

BTW, now we have run_mustfail() function, so we don't need to manually 
check the return value now.

Thanks,
Qu

>   if [ $? -ne 1 ]; then
>   	echo "after convert ext2_save/image is not read-only"
> @@ -24,3 +25,4 @@ if [ $? -ne 1 ]; then
>   fi
>   run_check_umount_test_dev
>   convert_test_post_rollback
> +
> 
