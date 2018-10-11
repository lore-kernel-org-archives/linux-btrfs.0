Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01169C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99C3220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlYVly4/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99C3220835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbeJKLut (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:50:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKLut (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:50:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B4ODPk052205;
        Thu, 11 Oct 2018 04:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=9ZAJQcN7dR+twMTnwvp1XS+bex9XVRU0JTTTLDEkbxY=;
 b=TlYVly4/TevunJvzCJNPPZsOd+2/RvBelHQxQUqCN70S+XRhXF0E6Hq6HS+w5wpejszN
 scBsxCRI4+j9HQzVpgb/AhBAFhZbI5Xj2TkKhexKLc2fEUtfeaFH8PJtZSGI6kaRnnYm
 p/bscqueJ+MnZFRHYnvlZ+Qk8+ZdvFasj2kmoR24Sj5c1jHa3zhVf6v2cHqsSGENYiXg
 Cch8iTPvqkdN7R7umKeC8TmWthVw4DpBS3+cbFZVP7EeSM4RW0IuqfzMung7NjKc77qd
 vVswl6VX1uoTHVSbRo1vWrvuazJ2bhaKoN8TvxI7m79EyE3CBAIUPHWeA5WIkkMqDMZK mQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mxmfu1hcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:25:25 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4PJUK014501
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:25:19 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B4PJM6015021;
        Thu, 11 Oct 2018 04:25:19 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:25:18 +0000
Date:   Wed, 10 Oct 2018 21:25:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] geneirc/077 fix min size for btrfs
Message-ID: <20181011042517.GA6695@magnolia>
References: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110042
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 11:26:00AM +0800, Anand Jain wrote:
> If btrfs need to be tested at its default blockgroup which is non-mixed,
> then it needs at least 256mb.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2->v3:
> 	separated from the patch set of 9.
> 	notrun for the cases where filler is not big enough to fill the
> 		fssize.
> v2->v1: ref the cover-letter of the set.
> 
>  tests/generic/077 | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/077 b/tests/generic/077
> index ef6af18c83e3..784afe448940 100755
> --- a/tests/generic/077
> +++ b/tests/generic/077
> @@ -13,7 +13,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1
> -# Something w/ enough data to fill 50M of fs...
> +# Something w/ enough data to fill 256M of fs...
>  filler=/lib/modules/
>  
>  # fall back in case /lib/modules doesn't exist
> @@ -38,6 +38,11 @@ _supported_os Linux
>  
>  [ ! -d $filler ] && _notrun "No directory to source files from"
>  
> +# check if two iterations of the assigned filler is big enough to fill fssize
> +fs_size=$((256 * 1024 * 1024))
> +[ $(( $(du -h -m /usr | tail -1| cut -f1) * 2 )) -lt 256 ] && \

Err... what does measuring /usr have to do with /lib/modules?

Also, /lib/modules is 58M on my test VM, which means that a 256M
filesystem isn't going to ENOSPC.

(Though weirdly it doesn't fail despite the lack of ENOSPC even at the
50M size, so I'm not sure what this test is actually supposed to do...)

--D

> +	_notrun "filler $filler isn't big enough to fill fssize $fssize"
> +
>  _require_scratch
>  _require_attrs
>  _require_acls
> @@ -49,9 +54,7 @@ rm -f $seqres.full
>  _scratch_unmount >/dev/null 2>&1
>  echo "*** MKFS ***"                         >>$seqres.full
>  echo ""                                     >>$seqres.full
> -SIZE=`expr 50 \* 1024 \* 1024`
> -_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
> -	|| _fail "mkfs failed"
> +_scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
>  _scratch_mount
>  mkdir $SCRATCH_MNT/subdir
>  
> -- 
> 1.8.3.1
> 
