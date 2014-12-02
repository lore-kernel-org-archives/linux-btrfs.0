Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60689 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaLBIOD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 03:14:03 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9AE113EE0C0
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 17:14:01 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A703EAC02C0
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 17:14:00 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5861AE08002
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Dec 2014 17:14:00 +0900 (JST)
Message-ID: <547D743C.7010905@jp.fujitsu.com>
Date: Tue, 2 Dec 2014 17:11:40 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>,
        MegaBrutal <megabrutal@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS equivalent for tune2fs?
References: <CAE8gLhnq_HjcB=Teis751eXD1FKEVTgfbY-2yDCB77-7oz5Yaw@mail.gmail.com> <547D6ABF.6030608@swiftspirit.co.za> <547D6CA3.7070808@swiftspirit.co.za>
In-Reply-To: <547D6CA3.7070808@swiftspirit.co.za>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(2014/12/02 16:39), Brendan Hide wrote:
> On 2014/12/02 09:31, Brendan Hide wrote:
>> On 2014/12/02 07:54, MegaBrutal wrote:
>>> Hi all,
>>>
>>> I know there is a btrfstune, but it doesn't provide all the
>>> functionality I'm thinking of.
>>>
>>> For ext2/3/4 file systems I can get a bunch of useful data with
>>> "tune2fs -l". How can I retrieve the same type of information about a
>>> BTRFS file system? (E.g., last mount time, last checked time, blocks
>>> reserved for superuser*, etc.)
>>>
>>> * Anyway, does BTRFS even have an option to reserve X% for the superuser?
>> Btrfs does not yet have this option. I'm certain that specific feature is in mind for the future however.
>>
>> As regards other equivalents, the same/similar answer applies. There simply aren't a lot of tuneables available "right now".
>>
> Almost forgot about this: btrfs property (get|set)
>
> Again, there are a lot of features still to be added.
>

Just FYI. There are some description about this topic.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Set_mount_options_permanently
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Extend_btrfstune_to_be_able_to_tune_more_parameters
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Filesystem_object_properties

Thanks,
Satoru

