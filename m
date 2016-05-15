Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33540 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbcEOMHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 08:07:49 -0400
Subject: Re: btrfs RAID-1 vs md RAID-1?
To: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <83719f27dd5cdc406fd3fd24e7b82a9f@admin.virtall.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5738669E.70308@oracle.com>
Date: Sun, 15 May 2016 20:07:58 +0800
MIME-Version: 1.0
In-Reply-To: <83719f27dd5cdc406fd3fd24e7b82a9f@admin.virtall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/15/2016 06:24 PM, Tomasz Chmielewski wrote:
> I'm trying to read two large files in parallel from a 2-disk RAID-1
> btrfs setup (using kernel 4.5.3).
>
> According to iostat, one of the disks is 100% saturated, while the other
> disk is around 0% busy.
>
> Is it expected?

No.

>
> Are there any plans to improve this is btrfs?
>
yes.

Thanks, Anand

> Tomasz Chmielewski
> http://wpkg.org
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
