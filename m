Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18362 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbbFJBTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 21:19:47 -0400
Message-ID: <557790A9.3080705@oracle.com>
Date: Wed, 10 Jun 2015 09:19:37 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Martin <develop@imagmbh.de>, linux-btrfs@vger.kernel.org
Subject: Re: rw-mount-problem after raid1-failure
References: <2227931.EqpnWnc32X@malu-aspire-v3-771>
In-Reply-To: <2227931.EqpnWnc32X@malu-aspire-v3-771>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/09/2015 01:10 AM, Martin wrote:
> Hello!
>
> I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid Vervet,
> btrfs-tools 3.17-1.1). One disk failed some days ago. I could remount the
> remaining one with "-o degraded". After one day and some write-operations
> (with no errrors) I had to reboot the system. And now I can not mount "rw"
> anymore, only "-o degraded,ro" is possible.
>
> In the kernel log I found BTRFS: too many missing devices, writeable mount is
> not allowed.
>
> I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I did no
> conversion to a single drive.
>
> How can I mount the disk "rw" to remove the "missing" drive and add a new one?
> Because there are many snapshots of the filesystem, copying the system would
> be only the last alternative ;-)

  How many disks you had in the RAID1. How many are failed ?

Thanks Anand


> Thanks
>
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
