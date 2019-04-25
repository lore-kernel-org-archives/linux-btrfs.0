Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F25C10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 02:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9527C2175B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 02:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="swS+KB/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388617AbfDYCKl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 22:10:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56616 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfDYCKk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 22:10:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3P1xROA013962;
        Thu, 25 Apr 2019 02:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=9p0vUk1qHBfLFGbV3mDTCLJ9z4oSebhxBgN9PnKugUk=;
 b=swS+KB/LxTbhHUfqw8oWvovJmr2TAFbg25O7+nqNuXuLlmDB0IWcrKoSk7Z8Gh2qtPJn
 DHbt2qA2iCwqTiYsqwfsfwR9Et2cNZ2ukCwcSEvQ9Sg75gObtzpbPPpOfP7Pp8u0a4tP
 YRPcmlV11qamsf+RN5KDW7NhcN4PfiRLjvR9wRIp7/wquuEobJwVwXyfbcstD1tOshtb
 aIuTZNdrPBaMJKMmxnuF6R78uWmPw8tV9brchiFwYJoV/b48B36KW2LE2JaG/Vw8Jn8k
 4hjHqwvsk5F5vkUblM+48Q9YZtFfrXEmKIdPRtySR2u8EvOCPKL0+PectPOBe1c85pHm 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ryrxd5sh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Apr 2019 02:10:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3P28UUA189508;
        Thu, 25 Apr 2019 02:10:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s0fv3vgrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Apr 2019 02:10:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3P2AAor017224;
        Thu, 25 Apr 2019 02:10:10 GMT
Received: from [10.190.130.61] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Apr 2019 19:10:10 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH v2] btrfs: fix filtering of scratch device in test case
 048
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <20190425003709.28749-1-fdmanana@kernel.org>
Date:   Thu, 25 Apr 2019 10:10:05 +0800
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <53BDA8EF-BB7A-4F6C-9129-EB1979D01D81@oracle.com>
References: <20190425002457.28648-1-fdmanana@kernel.org>
 <20190425003709.28749-1-fdmanana@kernel.org>
To:     fdmanana@kernel.org
X-Mailer: Apple Mail (2.3445.104.8)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904250012
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9237 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904250012
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


> On 25 Apr 2019, at 8:37 AM, fdmanana@kernel.org wrote:
>=20
> From: Filipe Manana <fdmanana@suse.com>
>=20
> The recent commit 4529b20e1aa8f9 ("btrfs/048: amend property =
validation
> cases"), does not properly filter the scratch device because the error
> messages are sent to stderr and not to stdout, and the pipe filter =
only
> gets input from the stdout of the btrfs utility. We need to redirect =
the
> stderr of the btrfs utility to its stdout.
>=20
> Further, the golden output had the path "/mnt/scratch" hardcoded, =
instead
> of using SCRATCH_MNT. Fix that as well.
>=20
> The test was failing on any setup where the scratch device is not =
mounted
> at "/mnt/scratch".
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Thanks!

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>=20
> V2: Fix the formatting of the patch, which was causing git apply / =
path to fail.
>=20
> tests/btrfs/048     | 10 +++++-----
> tests/btrfs/048.out | 10 +++++-----
> 2 files changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/tests/btrfs/048 b/tests/btrfs/048
> index f6de0b8c..8bb10a90 100755
> --- a/tests/btrfs/048
> +++ b/tests/btrfs/048
> @@ -208,21 +208,21 @@ touch $SCRATCH_MNT/sv1/file2
> $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
>=20
> echo -e "\nTesting argument validation, should fail"
> -$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | =
_filter_scratch
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' 2>&1 | =
_filter_scratch
> echo "***"
> -$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | =
_filter_scratch
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' 2>&1 | =
_filter_scratch
> echo "***"
> -$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | =
_filter_scratch
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' 2>&1 | =
_filter_scratch
>=20
> echo -e "\nTesting if property is persistent across failed validation"
> $BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
> -$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | =
_filter_scratch
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' 2>&1 | =
_filter_scratch
> $BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
>=20
> echo -e "\nTesting generation is unchanged after failed validation"
> $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> $BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep =
'^generation'
> -$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | =
_filter_scratch
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' 2>&1 | =
_filter_scratch
> $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> $BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep =
'^generation'
>=20
> diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
> index 00f39bc0..16a785a6 100644
> --- a/tests/btrfs/048.out
> +++ b/tests/btrfs/048.out
> @@ -78,17 +78,17 @@ compression=3Dlzo
> compression=3Dlzo
>=20
> Testing argument validation, should fail
> -ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
> ***
> -ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
> ***
> -ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
>=20
> Testing if property is persistent across failed validation
> -ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
> compression=3Dlzo
>=20
> Testing generation is unchanged after failed validation
> generation		7
> -ERROR: failed to set compression for /mnt/scratch: Invalid argument
> +ERROR: failed to set compression for SCRATCH_MNT: Invalid argument
> generation		7
> --=20
> 2.11.0
>=20

