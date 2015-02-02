Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:44939 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbbBBSkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 13:40:23 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Forrest Liu <forrestl@synology.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix =?iso-8859-1?Q?find=5Ffree=5Fdev=5Fextent()_malfunction_in_case_device_tr?=
 =?iso-8859-1?Q?ee_has_hole?=
Date: Mon, 02 Feb 2015 13:40:16 -0500
MIME-Version: 1.0
Message-ID: <6ada49cc-4bf0-4a9d-8ed7-27754af3639c@aei.ca>
In-Reply-To: <9348c3e9-9858-4c1a-9489-fab558f1e169@aei.ca>
References: <1422862299-7361-1-git-send-email-forrestl@synology.com>
 <9348c3e9-9858-4c1a-9489-fab558f1e169@aei.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, February 2, 2015 9:39:06 AM EST, Ed Tomlinson wrote:

Hi

Booting a kernel with the three patches:
[PATCH] Btrfs: fix find_free_dev_extent() malfunction in case device tree 
has hole
[PATCH] Btrfs: btrfs_release_extent_buffer_page() didn't free pages of 
dummy extent
[PATCH] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block 
group

generates lots of opps here (I hate to post an anemic report but my serial 
console was not recording so I do not have the opps).  They occured when 
starting X and, If I read them correctly, had something to do with extents.

Anyone else?

Thanks
Ed Tomlinson

> Hi,
>
> Found a problem compile testing this.  
>
> hole_size = key_offset - search_start;
>
> Should not that be key.offset ?
>
> TIA
> Ed Tomlinson
>
>
> On Monday, February 2, 2015 2:31:39 AM EST, Forrest Liu wrote:
>> If device tree has hole, find_free_dev_extent() cannot find available
>> address properly.
>> 
>> The example below, has one BIG hole in device tree, and can only
>> allocate just one chunk in a transaction.
>> 
>>     item 9 key (1 DEV_EXTENT 273841913856) itemoff 15811 itemsize 48 ...
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

