Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A47C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 13:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E78321850
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 13:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfDENVO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:21:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbfDENVN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 09:21:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB3D9AD63;
        Fri,  5 Apr 2019 13:21:11 +0000 (UTC)
Subject: Re: [PATCH v2] fstests: btrfs/048: amend property validation cases
To:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <20190403165419.12666-1-anand.jain@oracle.com>
 <20190403170437.14448-1-anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7de2d0fd-e777-2bec-5731-15ba2f2af4f2@suse.com>
Date:   Fri, 5 Apr 2019 16:21:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190403170437.14448-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.04.19 г. 20:04 ч., Anand Jain wrote:
> Add more property validation cases which are fixed by the patches [1]
>  [1]
>   btrfs: fix vanished compression property after failed set
>   btrfs: fix zstd compression parameter
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v2: correct kernel patch titles in the test header and change log
> 
>  tests/btrfs/048     | 23 +++++++++++++++++++++++
>  tests/btrfs/048.out | 16 ++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/tests/btrfs/048 b/tests/btrfs/048
> index 588219579cc6..f6de0b8ca8b1 100755
> --- a/tests/btrfs/048
> +++ b/tests/btrfs/048
> @@ -6,6 +6,9 @@
>  #
>  # Btrfs properties test. The btrfs properties feature was introduced in the
>  # linux kernel 3.14.
> +# Fails without the kernel patches:
> +#  btrfs: fix vanished compression property after failed set
> +#  btrfs: fix zstd compression parameter
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> @@ -34,6 +37,7 @@ _supported_os Linux
>  _require_test
>  _require_scratch
>  _require_btrfs_command "property"
> +_require_btrfs_command inspect-internal dump-super
>  
>  send_files_dir=$TEST_DIR/btrfs-test-$seq
>  
> @@ -203,5 +207,24 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
>  touch $SCRATCH_MNT/sv1/file2
>  $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
>  
> +echo -e "\nTesting argument validation, should fail"
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
> +echo "***"
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
> +echo "***"
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | _filter_scratch
> +
> +echo -e "\nTesting if property is persistent across failed validation"
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
> +
> +echo -e "\nTesting generation is unchanged after failed validation"
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
> +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
> +
>  status=0
>  exit
> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
> index 3e4e3d28950a..00f39bc01227 100644
> --- a/tests/btrfs/048.out
> +++ b/tests/btrfs/048.out
> @@ -76,3 +76,19 @@ compression=zlib
>  Testing subvolume property inheritance
>  compression=lzo
>  compression=lzo
> +
> +Testing argument validation, should fail
> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +***
> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +***
> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +
> +Testing if property is persistent across failed validation
> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +compression=lzo
> +
> +Testing generation is unchanged after failed validation
> +generation		7
> +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +generation		7
> 
