Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B63C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 09:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D26222A4
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 09:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qOgbgiv6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbfBNJwk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:52:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60454 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfBNJwj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 04:52:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1E9n2S6139001;
        Thu, 14 Feb 2019 09:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=t60hihswHgyPTldc/eEn5og5TYF/Wx0p+lblJo+4xSk=;
 b=qOgbgiv6Wp6obSlAehhaKS9IbDa0WSu4T54wY3DxaEaBsQg/DMUMryKwyXJyE/Rx6ZbR
 gYiExNYaTsMKkuWWtO3svcP9mA6yjDdp8ixdJn5XVCBmq8BlvSIaTeKJcBCE5y4+LleN
 /hRO5EuFw5kp5K9cCAJSlF8j2j9DsXFtNtKEBIeoMqRDB+dFLFWgQRblEC5zT7AiqJje
 HTCkB0v/zJCa+8GHJo9HX57q7+7j2DjgjtWztAz+5E5HjGfn8AKVkadcBe51BrZuMjCx
 o4wUg4WojLzxQ378c7gJAuLwonntKP8bxI/w+6uKvmRefxGJs3Zi4LqjwhJ6YfhWtaAb eQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qhre5pyvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 09:52:35 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1E9qYVf026696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 09:52:34 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1E9qXPT016083;
        Thu, 14 Feb 2019 09:52:33 GMT
Received: from [172.20.10.2] (/157.45.219.136)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Feb 2019 09:52:33 +0000
Subject: Re: [PATCH] btrfs: scrub: remove unused nocow worker pointer
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190212172314.15290-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <b8755de1-6a83-85c5-31ca-ec74678257b6@oracle.com>
Date:   Thu, 14 Feb 2019 17:52:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190212172314.15290-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9166 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902140072
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/13/19 1:23 AM, David Sterba wrote:
> The member btrfs_fs_info::scrub_nocow_workers is unused since the nocow
> optimization was removed from scrub in 9bebe665c3e4 ("btrfs: scrub:
> Remove unused copy_nocow_pages and its callchain").
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/ctree.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9306925b6790..7f3826ca7c91 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1078,7 +1078,6 @@ struct btrfs_fs_info {
>   	int scrub_workers_refcnt;
>   	struct btrfs_workqueue *scrub_workers;
>   	struct btrfs_workqueue *scrub_wr_completion_workers;
> -	struct btrfs_workqueue *scrub_nocow_workers;
>   	struct btrfs_workqueue *scrub_parity_workers;
>   
>   #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> 
