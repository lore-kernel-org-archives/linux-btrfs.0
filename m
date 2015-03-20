Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36774 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbCTKF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:05:26 -0400
Message-ID: <550BF081.3030502@oracle.com>
Date: Fri, 20 Mar 2015 18:03:45 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26 v4] provide framework so that sysfs attributs from
 the fs_devices can be added
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com> <20150319185858.GI20767@twin.jikos.cz>
In-Reply-To: <20150319185858.GI20767@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



V5 has been sent out with the kobject_move patch,
kindly use v5.

Thanks, Anand

On 03/20/2015 02:58 AM, David Sterba wrote:
> On Tue, Mar 10, 2015 at 06:38:18AM +0800, Anand Jain wrote:
>> This patch set will provide a framework and help to create attributes
>> from the structure btrfs_fs_devices which are available even before
>> fs_info is created. So by moving the parent kobject super_kobj from
>> fs_info to btrfs_fs_devices, it will help to create attributes
>> from the btrfs_fs_devices as well.
>
> FYI, I'm going to test this patchset and prepare a pull for Chris if
> everything goes fine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
