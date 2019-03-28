Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52976C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 234BC21773
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 15:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kVhyHmdo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfC1PmL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:42:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46046 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfC1PmK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 11:42:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SFY1NN120240;
        Thu, 28 Mar 2019 15:41:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cD6ZuC2MiZIjCszkqFz1Ts2OWaa9iNF7lGJozFeeQQI=;
 b=kVhyHmdoH99Ietqxs+wIw0WSiYAZnJAzsPEbkHCLP7gIR2vlUXj5iTTtDaZpx7n+IUxT
 CUB4S9pFqyREeJ09rDbotv6kTGfnAOud2QEeAa0357dvq9oC5Tr++MXmya4sECqkd5oL
 6g6f4gcjRQeEQtZlUQI1zocV+OezfAI+uyj+7pydscjaT5+W1I55zEFdruAdRERybYRM
 ExrxmUrNylaIVj2MrYrRybz6PFlViaOEf+USrNbyvWDayDtlvphelKmJ8wgtFFmgVqZe
 dyYt3Bmsh4zHEybE1A9PfaTIUqajCfJLjazswxl1/QWE+QV0c/O3m9HjP6swxlHej+eF 5w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2re6g17f3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:41:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SFfQQo008664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 15:41:27 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2SFfQuh027485;
        Thu, 28 Mar 2019 15:41:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 08:41:26 -0700
Date:   Thu, 28 Mar 2019 08:41:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 08/15] dax: add dax_iomap_cow to copy a mmap page before
 writing
Message-ID: <20190328154125.GE1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-9-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-9-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280105
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:54PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> dax_iomap_cow copies a page before presenting for mmap.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index e254535dd830..21ee3df6f02c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1269,6 +1269,33 @@ static bool dax_fault_is_synchronous(unsigned long flags,
>  		&& (iomap->flags & IOMAP_F_DIRTY);
>  }
>  
> +static int dax_iomap_cow(struct iomap *iomap, loff_t pos, pfn_t *pfn)
> +{
> +	void *daddr;
> +	pgoff_t pgoff;
> +	long rc;
> +	int id;
> +	sector_t sector;
> +
> +	pos = round_down(pos, PAGE_SIZE);
> +
> +	sector = round_down(iomap->addr + iomap->offset - pos, PAGE_SIZE) >> 9;
> +	rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
> +	if (rc)
> +		return rc;
> +
> +	id = dax_read_lock();
> +	rc = dax_direct_access(iomap->dax_dev, pgoff, 1, &daddr, pfn);
> +	if (rc < 0)
> +		goto out;
> +
> +	dax_to_dax_copy(iomap, pos, daddr, PAGE_SIZE);
> +
> +out:
> +	dax_read_unlock(id);
> +	return rc;
> +}
> +
>  static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			       int *iomap_errp, const struct iomap_ops *ops)
>  {
> @@ -1372,7 +1399,11 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
>  			major = VM_FAULT_MAJOR;
>  		}
> -		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
> +
> +		if (iomap.flags & IOMAP_F_COW)
> +			error = dax_iomap_cow(&iomap, pos, &pfn);

Why wouldn't dax_iomap_cow also apply to dax_iomap_pmd_fault?

--D

> +		else
> +			error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
>  		if (error < 0)
>  			goto error_finish_iomap;
>  
> -- 
> 2.16.4
> 
