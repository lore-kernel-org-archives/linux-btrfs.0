Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbcHOOGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 10:06:47 -0400
Subject: Re: About minimal device number for RAID5/6
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
Date: Mon, 15 Aug 2016 22:08:05 +0800
MIME-Version: 1.0
In-Reply-To: <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>>
>> Any comment is welcomed.
>>
> Based on looking at the code, we do in fact support 2/3 devices for
> raid5/6 respectively.
>
> Personally, I agree that we should warn when trying to do this, but I
> absolutely don't think we should stop it from happening.


  How does 2 disks RAID5 work ?

-Anand

