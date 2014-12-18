Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-103-166.dynamic.qsc.de ([92.195.103.166]:59090 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLRWMN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 17:12:13 -0500
Message-ID: <54934FD0.7080505@richtercloud.de>
Date: Thu, 18 Dec 2014 23:06:08 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How to deal with "The chunks in memory can not match the metadata
 of the fs. Repair failed."?
References: <5416FECF.5030709@richtercloud.de> <1410831965.14842.4.camel@localhost.localdomain>
In-Reply-To: <1410831965.14842.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Just to give you a really late feedback on this: I got it fixed with
btrfs-progs 3.17.3n on Linux 3.17.6, i.e. `btrfs rescue chunk-recover`
just did the job. Thanks for your advice.

-Kalle

Am 09/16/2014 um 03:46 AM schrieb Gui Hecheng:
> On Mon, 2014-09-15 at 16:59 +0200, Karl-Philipp Richter wrote:
>> Hi together,
>> I'm currently encountering another issue with `btrfs rescue 
>> chunk-recover`. After some seconds of maximal I/O activity, the program 
>> is idle for some seconds and then prints
>>
>>      The chunks in memory can not match the metadata of the fs. Repair 
>> failed.
>>      Fail to recover the chunk tree.
>>
>> I don't find any mention of this output except in the source code (this 
>> is as well the only thing $SEARCH_ENGINE points me to). What is the 
>> recommended next step? It would be nice to see the situation (The chunks 
>> in memory can not match the metadata of the fs) or the output mentioned 
>> in `man btrfs rescue`.
>>
>> Any help is appreciated.
>>
>> -Kalle
> 
> Hi Kalle,
> If you are encountering the above msg, it means the chunk tree has some
> inconsistent stuff with other trees like device tree & extent tree.
> You can specify the '-v' option for chunk-recover to see more details.
> 
> And also, the btrfs check cmd may tell more about the story.
> 
> Thanks,
> Gui
> 
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
