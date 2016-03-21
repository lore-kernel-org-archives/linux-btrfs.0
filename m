Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcCUHYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:24:41 -0400
Subject: Re: [PATCH v2] btrfs-progs: subvolume functions reorg
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458137673-464-1-git-send-email-anand.jain@oracle.com>
 <20160317141945.GU21722@twin.jikos.cz> <56EBC240.40306@oracle.com>
 <20160318133136.GY21722@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56EFA1B3.2020206@oracle.com>
Date: Mon, 21 Mar 2016 15:24:35 +0800
MIME-Version: 1.0
In-Reply-To: <20160318133136.GY21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/18/2016 09:31 PM, David Sterba wrote:
> On Fri, Mar 18, 2016 at 04:54:24PM +0800, Anand Jain wrote:
>>
>>
>> On 03/17/2016 10:19 PM, David Sterba wrote:
>>> On Wed, Mar 16, 2016 at 10:14:33PM +0800, Anand Jain wrote:
>>>> Makes few subvol related functions usable outside of subvol
>>>> command set.
>>>>
>>>> This is a preparatory patch for encryption support. The changes
>>>> here are:
>>>>
>>>> Created new file subvolume.c
>>>> Created btrfs_get_subvol_info() from parts of cmd_subvol_show()
>>>> Moved get_subvol_name() to subvolume.c
>>>> Moved test_issubvolume() to subvolume.c
>>>> Created subvolume.h to define the above functions.
>>>
>>> Such helpers are in utils.[ch], eg. there's test_issubvolname.
>>
>>    You meant to move them/it to subvolume.c/h right ?
>
> No, please keep using utils.[ch] for now.

Agreed.

V3 was sent out. (and now its a patch set of 6).

Thanks, Anand

