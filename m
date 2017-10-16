Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:56408 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751655AbdJPEfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 00:35:21 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id DCCBAAC08AE
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:35:15 +0900 (JST)
Subject: Re: [PATCH v2 3/3] btrfs-progs: device: add remove missing-all
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: Duncan <1i5t5.duncan@cox.net>
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
 <be3e6086-5a2f-77d0-5dbc-dcb5a1a57815@jp.fujitsu.com>
 <pan$48dd8$f51614da$34e59787$eb10b745@cox.net>
 <d311a713-a663-a11d-7cdb-bb9d359c4ba5@oracle.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <649452a3-908d-670d-8bfd-b0e248b32b32@jp.fujitsu.com>
Date: Mon, 16 Oct 2017 13:35:08 +0900
MIME-Version: 1.0
In-Reply-To: <d311a713-a663-a11d-7cdb-bb9d359c4ba5@oracle.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017/10/16 12:30, Anand Jain wrote:
> 
> 
> On 10/13/2017 01:27 PM, Duncan wrote:
>> Misono, Tomohiro posted on Wed, 11 Oct 2017 11:18:50 +0900 as excerpted:
>>
>>> Add 'btrfs remove missing-all' to remove all the missing devices at once
>>> for improving usability.
>>>
>>> Example:
>>>   sudo mkfs.btrfs -f -d raid1 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
>>>   sudo wipefs -a /dev/sdb1 /dev/sdb3
>>>   sudo mount -o degraded /dev/sdb2 /mnt <-- 
> 
> 
>    I agree with Duncan here. This step itself will fail even with RO
>    option. Do you have any patch that is not in the ML which will
>    make this step a success in the first place ?
> 
> Thanks, Anand
> 

commit 21634a19f646 ("btrfs: Introduce a function to check if all chunks a OK
for degraded rw mount") allow this from 4.14 (I checked on 4.14-rc4).
But I will withdraw this patch as Duncan suggests.

Thanks,
Tomohiro

