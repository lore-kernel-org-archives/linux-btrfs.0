Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36532 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbbCXAgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 20:36:36 -0400
Message-ID: <5510B191.1010402@cn.fujitsu.com>
Date: Tue, 24 Mar 2015 08:36:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] btrfs-progs: qgroup related enhance.
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com> <20150323233803.GP20767@twin.jikos.cz>
In-Reply-To: <20150323233803.GP20767@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 0/7] btrfs-progs: qgroup related enhance.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年03月24日 07:38

> On Fri, Feb 27, 2015 at 04:26:32PM +0800, Qu Wenruo wrote:
>> Qu Wenruo (7):
>>    btrfs-progs: Update qgroup status flags and replace qgroup
>>      level/subvid     calculation with inline function.
>>    btrfs-progs: Allow btrfs-debug-tree to print human readable qgroup
>>      status flag.
>>    btrfs-progs: Move parse_qgroupid() to utils.c
>>    btrfs-progs: Allow parse_qgroupid() to resolve subvolume path into
>>      qgroupid.
>>    btrfs-progs: Add stack get/set functions for btrfs_qgroup_status_item.
>>    btrfs-progs: Print warning message if qgroup data is inconsistent.
>
> All of the above merged.
>
>>    btrfs-progs: Schedule quota rescan if qgroup assign caused
>>      inconsistence.
>
> The rescan can be a long running operation and touches a lot of
> metadata, so I'd rather avoid starting the rescan automatically. Right
> now the user may start rescan manually, or please add an commandline
> option (eg. --rescan) to do the rescan in one go with the 'assign'
> command. Thanks.
>
Makes sense, I'll update the last patch soon.

Thanks,
Qu
