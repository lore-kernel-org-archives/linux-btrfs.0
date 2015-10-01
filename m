Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43316 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANsj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 09:48:39 -0400
Message-ID: <560D39A7.4050703@oracle.com>
Date: Thu, 01 Oct 2015 21:48:23 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 21/23] Btrfs: fix fs logging for multi device
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com> <1439548388-29686-22-git-send-email-anand.jain@oracle.com> <20151001134544.GE5885@twin.jikos.cz>
In-Reply-To: <20151001134544.GE5885@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/01/2015 09:45 PM, David Sterba wrote:
> On Fri, Aug 14, 2015 at 06:33:06PM +0800, Anand Jain wrote:
>> In case of multi device btrfs fs, using one of device for
>> the logging purpose it quite confusing, instead use the
>> fsid. FSID is bit long, but the device path can be long
>> as well in some cases.
>
> The fsid in the log would be good but yeah it's quite long. Though the
> device paths could be long as well, they are not in most cases. The uuid
> length is 36 bytes, a device mapper path starts at 12 (prefix) plus the
> volume name.
>
> Please send this patch separately with a RFC tag so we can hopeully have
> a discussion among more people.

  got it. will do.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
