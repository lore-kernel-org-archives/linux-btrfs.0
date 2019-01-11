Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2540EC43444
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 03:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E88C720872
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 03:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oUu9Z+xx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfAKDoN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 22:44:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfAKDoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 22:44:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0B3d6LR063493;
        Fri, 11 Jan 2019 03:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=aQqWrs1LuxpnEDu61JzI0BYWR59CAsPvLevs5hfm+Nk=;
 b=oUu9Z+xxnEZRyhIPG0tcRyEP0yI1w+T5UOc40Iy63bey2vCsdN/TqUvDrRXaKqz4wFn0
 K2sRbNR3THpCC9chY7VuvFckCWROjp6ZpBEdfdOkiV+Psz2NC+01HtnZaRXo038S6qZ+
 I5vJm4RIeGqPNThej8FvVSAmb+ixdWcydStXomi8U8DqSwSEtEh1S8EJhdQ8g+dXTzgn
 DyZAod0H/QRf0HM6mYG0l/jc07Xuyz3Gk5EQkOSIG7bZddXp/XoDPjotMvbkfHlxUGnX
 jEecbUsRDNclXgo1MWh1XpWwOas30AkepCAP1jTw6afH8Qf46tWDygNZzA5DppXacvn3 bQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2ptn7rah8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jan 2019 03:43:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0B3hgRi017399
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jan 2019 03:43:43 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0B3hg79014927;
        Fri, 11 Jan 2019 03:43:42 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Jan 2019 19:43:42 -0800
Subject: Re: [PATCH v2] btrfs: add kernel scrub log messages
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
Message-ID: <26425a7b-c854-9b32-15ff-ff535cff4a14@oracle.com>
Date:   Fri, 11 Jan 2019 11:43:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1546503460-3183-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9132 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901110028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 04:17 PM, Anand Jain wrote:
> scrub kernel messages helps debug and audit, add them to the log.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Ping.

Thanks.

> ---
> v1->v2: fix btrfs_info, using string directly. Add spacing.
>   fs/btrfs/scrub.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 6dcd36d7b849..aadafc3e52c7 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3903,6 +3903,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   	 */
>   	nofs_flag = memalloc_nofs_save();
>   	if (!is_dev_replace) {
> +		btrfs_info(fs_info, "scrub: devid %llu started", devid);
>   		/*
>   		 * by holding device list mutex, we can
>   		 * kick off writing super in log tree sync.
> @@ -3925,6 +3926,10 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   	if (progress)
>   		memcpy(progress, &sctx->stat, sizeof(*progress));
>   
> +	if (!is_dev_replace)
> +		btrfs_info(fs_info, "scrub: devid %llu %s:%d",
> +			devid, ret ? "not finished" : "finished", ret);
> +
>   	mutex_lock(&fs_info->scrub_lock);
>   	dev->scrub_ctx = NULL;
>   	scrub_workers_put(fs_info);
> 
