Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:30078 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcFIXcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 19:32:36 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 406D5AC035E
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 08:32:30 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: add the error message when open fails
To: dsterba@suse.cz
References: <201606090123.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20160609131343.GJ3905@twin.jikos.cz>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <61e21717-f881-0484-2040-8caf73ff3cca@jp.fujitsu.com>
Date: Fri, 10 Jun 2016 08:32:12 +0900
MIME-Version: 1.0
In-Reply-To: <20160609131343.GJ3905@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David,

On 2016/06/09 22:13, David Sterba wrote:
> On Thu, Jun 09, 2016 at 10:23:15AM +0900, Tsutomu Itoh wrote:
>> When open in btrfs_open_devices failed, only the following message is
>> displayed. Therefore the user doesn't understand the reason why open
>> failed.
>>
>>   # btrfs check /dev/sdb8
>>   Couldn't open file system
>>
>> This patch adds the error message when open fails.
>
> I think the message should be printed by the caller, not by the helper.

However in this case, error device name is not understood in the caller.

Thanks,
Tsutomu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

