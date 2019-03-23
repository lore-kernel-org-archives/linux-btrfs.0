Return-Path: <SRS0=xp1I=R2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40341C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 09:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B52218E2
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 09:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LY0MBpXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfCWJF2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Mar 2019 05:05:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42602 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCWJF2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Mar 2019 05:05:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id p6so3105130pgh.9;
        Sat, 23 Mar 2019 02:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3JJTaNq3AodIPIvBbk8fl56i9Iao5kYYg0+RshsqX3c=;
        b=LY0MBpXRRDlTBiG8ME2xOhYtgN8gU2QxbwjKsZju7CFMxMbYS0iBGSRpdOb+OvnP+A
         6o4JyFow6sVFVUx3RRL8cz3fdX9Es3ezm+onpPSrPc3iyq/B/lKLQcWMRTcY6fb76vzM
         4jNt2wFUlHCrhhUJfFH5ZAfw8gydJW1nw2IS5rbFQRQy5jdq0/lvqfT3NUHgOnYviaUq
         XpNdGwrDFiwhqkb/10sj8ydnBUvc9hagofi5YhabQqNWA/X1lAQGGoUma5EtbhQykBgF
         3UHjLVTR07xA7r3bwRf/jmJbVe1l7y2jGD0WKM9Ve2grZfr44yj0S+WA6vuEKGoBJskV
         NKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3JJTaNq3AodIPIvBbk8fl56i9Iao5kYYg0+RshsqX3c=;
        b=eIeDH+CZoyAcYeNa5k6yKtft6MR9rAexIfXaLU7nYP9eYsgOrP9mXqrmB08logNy9X
         /ZGfcZPoIrVFfMLHWtMYcpg3a/CVLKgHCF7mlp0bQB0eg9X+uuECBKJcqUSajqTqVuL4
         AP+jIlDCrFVEWwwKDQBjoGG+3TN+7Cb9YdPcxeJLrlkH6Pa0ts8GAtsjbap5zUCUqKJe
         r83arMQpHiC7aGkBcbZ0fX9gwWMeQskFKE+IZZXghiIdtYVZBYubgrWxRXEIjZNZSavd
         Q4JHcmF4WXf5PaLK/QOnLK5YQTqIJ7G9p36kEDQKxjTD2IgqeNG2oZP+cYlFlvEwAZ2Y
         f4Kw==
X-Gm-Message-State: APjAAAUhISeJr7EYdimxKtQom8SxHwPG7S3absxGmFMC6tOnqJ2EOoBC
        gqaaCmkuWAkHiWiGk4teSIrrDO8GFVU=
X-Google-Smtp-Source: APXvYqzhbHHhXZa8rid57KqF5Vp0s9w2dYpzpWLGVtH44zmGZOqhsq8ZYZWHHO3S8mFvWcRvUbO36Q==
X-Received: by 2002:aa7:885a:: with SMTP id k26mr13553708pfo.70.1553331927022;
        Sat, 23 Mar 2019 02:05:27 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id u13sm19326630pfa.169.2019.03.23.02.05.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Mar 2019 02:05:26 -0700 (PDT)
Date:   Sat, 23 Mar 2019 17:05:19 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs try use forget to unregister device
Message-ID: <20190323090519.GT2824@desktop>
References: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 05:49:40PM +0800, Anand Jain wrote:
> btrfs module reload was introduced to unregister devices in the btrfs
> kernel module.
> 
> The problem with the module reload approach is that you can't run btrfs
> test cases 124, 125, 154 and 164 on the system with btrfs as root fs.
> 
> Patches [1] introduced btrfs forget feature which lets to cleanup the
> kernel device list without kernel module reload.
> 
>  [1]
>  btrfs-progs: add cli to forget one or all scanned devices
>  btrfs: introduce new ioctl to unregister a btrfs device
> 
> So this patch uses forget feature instead of kernel module reload, if
> the forget feature is available.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks fine to me. But I'd like an explicit review from btrfs folks too.

Thanks,
Eryu

> ---
>  common/btrfs    | 20 ++++++++++++++++++++
>  tests/btrfs/124 |  6 +++---
>  tests/btrfs/125 |  6 +++---
>  tests/btrfs/154 |  6 +++---
>  tests/btrfs/164 |  4 ++--
>  5 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/common/btrfs b/common/btrfs
> index f6513c06f95f..e94e011db04e 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -382,3 +382,23 @@ _scratch_btrfs_sectorsize()
>  	$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV |\
>  		grep sectorsize | awk '{print $2}'
>  }
> +
> +_btrfs_supports_forget()
> +{
> +	$BTRFS_UTIL_PROG device scan --help | grep -wq forget && \
> +		$BTRFS_UTIL_PROG device scan --forget > /dev/null 2>&1
> +}
> +
> +_require_btrfs_forget_if_not_fs_loadable()
> +{
> +	_btrfs_supports_forget && return
> +
> +	_require_loadable_fs_module "btrfs"
> +}
> +
> +_btrfs_forget_if_not_fs_reload()
> +{
> +	_btrfs_supports_forget && return
> +
> +	_reload_fs_module "btrfs"
> +}
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> index a52c65f608ff..9341dcea8896 100755
> --- a/tests/btrfs/124
> +++ b/tests/btrfs/124
> @@ -51,7 +51,7 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch_dev_pool 2
>  _test_unmount
> -_require_loadable_fs_module "btrfs"
> +_require_btrfs_forget_if_not_fs_loadable
>  
>  _scratch_dev_pool_get 2
>  
> @@ -86,7 +86,7 @@ echo "clean btrfs ko" >> $seqres.full
>  _scratch_unmount
>  
>  # un-scan the btrfs devices
> -_reload_fs_module "btrfs"
> +_btrfs_forget_if_not_fs_reload
>  
>  echo >> $seqres.full
>  echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
> @@ -125,7 +125,7 @@ echo
>  echo "Mount degraded with the other dev"
>  _scratch_unmount
>  # un-scan the btrfs devices
> -_reload_fs_module "btrfs"
> +_btrfs_forget_if_not_fs_reload
>  _mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
>  _run_btrfs_util_prog filesystem show
>  checkpoint3=`md5sum $SCRATCH_MNT/tf2`
> diff --git a/tests/btrfs/125 b/tests/btrfs/125
> index 847fa62ad25f..3d847033f1a2 100755
> --- a/tests/btrfs/125
> +++ b/tests/btrfs/125
> @@ -50,7 +50,7 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch_dev_pool 3
>  _test_unmount
> -_require_loadable_fs_module "btrfs"
> +_require_btrfs_forget_if_not_fs_loadable
>  _require_btrfs_fs_feature raid56
>  
>  _scratch_dev_pool_get 3
> @@ -103,7 +103,7 @@ echo "unmount" >> $seqres.full
>  _scratch_unmount
>  echo "clean btrfs ko" >> $seqres.full
>  # un-scan the btrfs devices
> -_reload_fs_module "btrfs"
> +_btrfs_forget_if_not_fs_reload
>  _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
>  dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
>  					>>$seqres.full 2>&1
> @@ -139,7 +139,7 @@ echo "Mount degraded but with other dev"
>  
>  _scratch_unmount
>  # un-scan the btrfs devices
> -_reload_fs_module "btrfs"
> +_btrfs_forget_if_not_fs_reload
>  
>  _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
>  
> diff --git a/tests/btrfs/154 b/tests/btrfs/154
> index cd6c688fb9fe..e39f54ac6ab8 100755
> --- a/tests/btrfs/154
> +++ b/tests/btrfs/154
> @@ -36,7 +36,7 @@ rm -f $seqres.full
>  _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch_dev_pool 2
> -_require_loadable_fs_module "btrfs"
> +_require_btrfs_forget_if_not_fs_loadable
>  
>  _scratch_dev_pool_get 2
>  
> @@ -90,7 +90,7 @@ degrade_mount_write()
>  
>  	echo "clean btrfs ko" >> $seqres.full
>  	# un-scan the btrfs devices
> -	_reload_fs_module "btrfs"
> +	_btrfs_forget_if_not_fs_reload
>  	_mount -o degraded $DEV1 $SCRATCH_MNT >>$seqres.full 2>&1
>  	cnt=$(( $COUNT/10 ))
>  	dd if=/dev/urandom of="$SCRATCH_MNT"/tf1 bs=$bs count=$cnt \
> @@ -142,7 +142,7 @@ verify()
>  	echo "unmount" >> $seqres.full
>  
>  	_scratch_unmount
> -	_reload_fs_module "btrfs"
> +	_btrfs_forget_if_not_fs_reload
>  	_mount -o degraded $DEV2 $SCRATCH_MNT >>$seqres.full 2>&1
>  	verify_checkpoint1=`md5sum $SCRATCH_MNT/tf1`
>  	verify_checkpoint2=`md5sum $SCRATCH_MNT/tf2`
> diff --git a/tests/btrfs/164 b/tests/btrfs/164
> index 097191a0e493..55042c4035e0 100755
> --- a/tests/btrfs/164
> +++ b/tests/btrfs/164
> @@ -36,7 +36,7 @@ rm -f $seqres.full
>  # Modify as appropriate.
>  _supported_fs btrfs
>  _supported_os Linux
> -_require_loadable_fs_module "btrfs"
> +_require_btrfs_forget_if_not_fs_loadable
>  _require_scratch_dev_pool 2
>  
>  _scratch_dev_pool_get 2
> @@ -69,7 +69,7 @@ delete_seed()
>  {
>  	_run_btrfs_util_prog device delete $dev_seed $SCRATCH_MNT
>  	_scratch_unmount
> -	_reload_fs_module "btrfs"
> +	_btrfs_forget_if_not_fs_reload
>  	run_check _mount $dev_sprout $SCRATCH_MNT
>  	_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
>  	echo -- sprout --
> -- 
> 1.8.3.1
> 
