Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4CFC282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 04:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E0CB21871
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 04:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fzhOM21S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfDFEuX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 00:50:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfDFEuW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 00:50:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x364lhKe171101;
        Sat, 6 Apr 2019 04:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/u6a9eu4KOX2FtPxKCe66VRYBKvN2VLVnHytPdTBbB0=;
 b=fzhOM21SnToP0Sh71V6S6Z/iA8krr8Lleh6A0ctH1781UtxRynjGdqO1qh1W7Dcnq+Ho
 MW5CpPNbLxX0KSq0YW1Gv9YP6KVy5264/lQZ4iKivebPF+9hw305F2lz4j/oevKwunjJ
 R00O58dhUoehU49fbgpoRDEtRdr5kpNmLFRKgFNzC3xZ7dQMtMtLqSQ3x03EBGKxXH5R
 9PTJ7yTXhFwJyVHMrxE7eyOS6HKmWU7eJ32yMFQivkXd49dwjDbjdCoR5LpAGkI9PE59
 QToYtckAWabJ85kbrLgsTLK10ffEKKdlH164C5+uM6IY6+ZLZtRFuNRey3UJy9AjaMX6 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rpkhsg3ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Apr 2019 04:50:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x364nZjk059292;
        Sat, 6 Apr 2019 04:50:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2rpkx00tt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Apr 2019 04:50:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x364oFfX018825;
        Sat, 6 Apr 2019 04:50:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Apr 2019 21:50:15 -0700
Date:   Fri, 5 Apr 2019 21:50:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Add error string for EUCLEAN
Message-ID: <20190406045008.GE1177@magnolia>
References: <20190406031426.22436-1-wqu@suse.com>
 <20190406031426.22436-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406031426.22436-2-wqu@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9218 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904060034
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9218 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904060034
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 11:14:26AM +0800, Qu Wenruo wrote:
> Since we're going to support write time tree checker, it's possible that
> transaction get aborted due to tree-checker, also due to new
> BLK_STS_SELFTEST bit, we can distinguish real EIO error and EUCLEAN
> error.
> 
> Now add error string for EUCLEAN too.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 120e4340792a..a4cbbd7861d3 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -86,6 +86,9 @@ const char *btrfs_decode_error(int errno)
>  	case -ENOENT:
>  		errstr = "No such entry";
>  		break;
> +	case -EUCLEAN:
> +		errstr = "Selftest failure";
> +		break;

EUCLEAN usually spits out "Structure needs cleaning" in userspace (and
ext4 & xfs have been using it for years to complain about corrupt data),
so why diverge here?

Wait... does "tree-checker" mean online metadata checking, and 'selftest
failure' is what gets spit out when it finds some metadata it doesn't
like?

--D

>  	}
>  
>  	return errstr;
> -- 
> 2.21.0
> 
