Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37860 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab3GZQEN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 12:04:13 -0400
Message-ID: <51F29C8E.2070102@sandeen.net>
Date: Fri, 26 Jul 2013 10:58:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: generic/314 filter out total from ls -l output
References: <1374853532-19253-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1374853532-19253-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/26/13 10:45 AM, Josef Bacik wrote:
> ls -l will show the nblocks for the directory, and this made it into the golden
> output for 314.  The problem is nblocks is 0 for btrfs directories because we're
> awesome, which makes us fail this test.  So filter out the "total blah" line of
> ls -l so btrfs can pass this test too.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

I don't know for sure that that makes brtfs awesome ;), but its' not what
we're testing here, so ignoring it seems reasonable. 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/generic/314     |    2 +-
>  tests/generic/314.out |    1 -
>  2 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/314 b/tests/generic/314
> index 2d34ea8..0dd98a3 100644
> --- a/tests/generic/314
> +++ b/tests/generic/314
> @@ -62,7 +62,7 @@ su $qa_user -c "setfacl -m u:$qa_user:rwx,d:u:$qa_user:rwx $TEST_DIR/$seq-dir"
>  su $qa_user -c "mkdir $TEST_DIR/$seq-dir/subdir2"
>  
>  # Both subdirs should have inherited sgid
> -_ls_l $TEST_DIR/$seq-dir/ | _filter_test_dir | awk '{print $1,$NF}'
> +_ls_l $TEST_DIR/$seq-dir/ | grep -v total | _filter_test_dir | awk '{print $1,$NF}'
>  
>  status=0
>  exit
> diff --git a/tests/generic/314.out b/tests/generic/314.out
> index 180be80..b2db82b 100644
> --- a/tests/generic/314.out
> +++ b/tests/generic/314.out
> @@ -1,4 +1,3 @@
>  QA output created by 314
> -total 4
>  drwxr-sr-x subdir
>  drwxrwsr-x+ subdir2
> 

