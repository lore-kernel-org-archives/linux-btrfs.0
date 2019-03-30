Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DB6C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 09:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D580E218A6
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 09:34:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUDSfhWi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfC3Jet (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 05:34:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36785 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfC3Jet (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 05:34:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id 85so2362327pgc.3;
        Sat, 30 Mar 2019 02:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SHkySyDZoqXU+EuH97p1Wai6t1Rvd2KiJr7CJn/0CE8=;
        b=jUDSfhWiGOziASa9z6Y0/yFstxY6Vbu93bp2k9hHnYroYdmCRI371q9DWmaXSaIetC
         BYoTPG/IuOq6WsqPlCIJhoa9tB4FkfTm80kvm0QD7I7nlFop/vyfZHK01PqgBn2RRfA3
         0uVvI715DXPMzWU3f+44jo2M48yIO2UOIjD8iGFucZBtRyDw9Wxg8UN2fcX5d1j3AXOI
         JsGnB44YoSuKWacteWaWs6kbkDVdv3hoT0bZZKX2r7xKAvVPUkMS+fof+zcOvzm7LmpM
         LxmhnBbyuz6COmdlUOmoV39jxiG3oHzlBS+icbeEiVdAGea2XtgpzD2VQqWbIoroBEwZ
         S5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SHkySyDZoqXU+EuH97p1Wai6t1Rvd2KiJr7CJn/0CE8=;
        b=O7+oHssvGZYGzNdhbZGIJ/WDczz+X7mBCXXNeFWGM02zLQQZosKH4nTa6oi264hpkx
         sjnRYVIFvt9R2oXetMmTQWh9wiEJoMpQre/3kpPT5XSE0e1YU5xkU40IAJh9R2xcOHE7
         8YQP3o1z05BJipk574t/vb3cfZH9uLGyIfDiw+PNCg7Ig9OFd7qcuZZDMCiBx5l/MgTM
         EcgYzdVhwWiM2RAqJiR9rTIvGmzdUtxxQQWlAny+3fDG9AaDedb04FuOu6QiDQ9sPWNv
         L7Yypl+v8eSkz8I0Z6L/s8QKdG8sW7VZTLDUk8nahA6qGVGdWTcZC2ZdtnGN19zRLqfp
         HE0Q==
X-Gm-Message-State: APjAAAWYDJyXemN51fOjiZ6VcEBVxhGI5piEXhKeBKYjd9WPf/6Mm3KV
        VJiP9glmJSerHp34X309AJwf77JwxNA=
X-Google-Smtp-Source: APXvYqzmJwLTsmaRoXe2XlDmDQkHP64+PTzkzx+3yz+GVu4Qoou2o+7eoJ4CmcSqQ4kLU6ZgyU2IEg==
X-Received: by 2002:a63:464c:: with SMTP id v12mr49831618pgk.431.1553938487951;
        Sat, 30 Mar 2019 02:34:47 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id b63sm13802847pfj.54.2019.03.30.02.34.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Mar 2019 02:34:46 -0700 (PDT)
Date:   Sat, 30 Mar 2019 17:34:41 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Enable btrfs/003
Message-ID: <20190330093441.GZ2824@desktop>
References: <20190319105851.9280-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319105851.9280-1-nborisov@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 12:58:51PM +0200, Nikolay Borisov wrote:
> For a long time this test has been failing on all kinds of VM configuration,
> which are using virtio_blk devices. This is due to the fact that scsi
> devices are deletable and virtio_blk are not. However, this only prevents
> device replace case to run and has no negative effect on the other
> useful test cases.
> 
> Re-enable btrfs/003 to run by making _require_deletable_scratch_dev_pool
> private to the test case and modifying it to return success (0) or
> failure (1) if devices are not deletable. Further modify the replace
> test case to check the return value of this function and skip it if
> devices are not deletable.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  common/rc       | 12 ------------
>  tests/btrfs/003 | 19 ++++++++++++++++++-
>  2 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 1c42515ff0ea..5693ba3cad18 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2961,18 +2961,6 @@ _require_scratch_dev_pool_equal_size()
>  	done
>  }
>  
> -# We will check if the device is deletable
> -_require_deletable_scratch_dev_pool()
> -{
> -	local i
> -	local x
> -	for i in $SCRATCH_DEV_POOL; do
> -		x=`echo $i | cut -d"/" -f 3`
> -		if [ ! -f /sys/class/block/${x}/device/delete ]; then
> -			_notrun "$i is a device which is not deletable"
> -		fi
> -	done
> -}
>  
>  # Check that fio is present, and it is able to execute given jobfile
>  _require_fio()
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 938030ef4c65..2aeb9fe6325a 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -17,6 +17,21 @@ dev_removed=0
>  removed_dev_htl=""
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> +# Check if all scratch dev pools are deletable
> +_require_deletable_scratch_dev_pool()

Then it's not a _require rule anymore, maybe we could just rename it to
something like "deletable_scratch_dev_pool"? Also remove the leading "_"
if it becomes a private function.

Thanks,
Eryu

> +{
> +	local i
> +	local x
> +	for i in $SCRATCH_DEV_POOL; do
> +		x=`echo $i | cut -d"/" -f 3`
> +		if [ ! -f /sys/class/block/${x}/device/delete ]; then
> +			return 1
> +		fi
> +	done
> +
> +	return 0
> +}
> +
>  _cleanup()
>  {
>      cd /
> @@ -35,7 +50,6 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
>  _require_scratch_dev_pool 4
> -_require_deletable_scratch_dev_pool
>  _require_command "$WIPEFS_PROG" wipefs
>  
>  rm -f $seqres.full
> @@ -111,6 +125,9 @@ _test_replace()
>  	local ds
>  	local d
>  
> +	# If scratch devs are not deletable skip this test
> +	if ! _require_deletable_scratch_dev_pool; then return 0; fi
> +
>  	# exclude the first and the last disk in the disk pool
>  	n=$(($n-1))
>  	ds=${devs[@]:1:$(($n-1))}
> -- 
> 2.7.4
> 
