Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab3G2RbM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 13:31:12 -0400
Message-ID: <51F6A6DA.3080102@redhat.com>
Date: Mon, 29 Jul 2013 12:31:06 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, jeff.liu@oracle.com
Subject: Re: [PATCH] xfstests: generic/315: add one more sync and more output
References: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375118463-29654-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/29/13 12:21 PM, Josef Bacik wrote:
> So df in btrfs is tricky at best, and relying on it for accurate information is
> not great, but it's the best way to verify this test.  So we need to add another
> sync to make sure the pinned blocks are all freed up and the df space is really
> really accurate, otherwise we end up with this test failling because the df
> after the test is slightly off (in my case it was like 36kb off).  With this
> patch I'm not seeing random failures of this test.  Thanks,

Honest question: does one more sync make this deterministic, or is it a best-effort, um, hack?

-Eric

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/generic/315 |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tests/generic/315 b/tests/generic/315
> index 7cfc40d..7c55b8a 100644
> --- a/tests/generic/315
> +++ b/tests/generic/315
> @@ -70,10 +70,11 @@ fsize=`ls -l $TEST_DIR/testfile.$seq | awk '{print $5}'`
>  # Truncate the file size back to 0
>  truncate -s 0 $TEST_DIR/testfile.$seq
>  sync
> +sync
>  
>  # Preallocated disk space should be released
>  avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
> -[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
> +[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
>  
>  # success, all done
>  exit
> 

