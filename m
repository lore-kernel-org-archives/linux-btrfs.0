Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:52077 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab2EQIuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 04:50:39 -0400
Message-ID: <4FB4BB8E.9080503@giantdisaster.de>
Date: Thu, 17 May 2012 10:49:18 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Btrfs: read device stats on mount, write modified
 ones during commit
References: <cover.1337185201.git.sbehrens@giantdisaster.de> <f7e60650b3463d028f86b38ef3e6aaf77efa665b.1337185201.git.sbehrens@giantdisaster.de> <4FB459F0.3050502@cn.fujitsu.com>
In-Reply-To: <4FB459F0.3050502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/2012 03:52, Liu Bo wrote:
> On 05/17/2012 12:50 AM, Stefan Behrens wrote:
>
>> The device statistics are written into the device tree with each
>> transaction commit. Only modified statistics are written.
>> When a filesystem is mounted, the device statistics for each involved
>> device are read from the device tree and used to initialize the
>> counters.
>
>
> Hi Stefan,
>
> Just scaned the patch for a while and got a question:
>
> Adding a new key type usually means changing the disk format,
> so have you done something for this?


Hi Liu,

New tree entries with new keys are added to the device tree. Old kernels 
do not search for these keys and therefore ignore them. New kernels 
(with this patch) search for these keys and read and write them, or 
create them when required. That works fine.
