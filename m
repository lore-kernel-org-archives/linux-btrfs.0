Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-ines.wadns.net ([41.185.62.129]:49600 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932299AbaLBHjH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 02:39:07 -0500
Message-ID: <547D6CA3.7070808@swiftspirit.co.za>
Date: Tue, 02 Dec 2014 09:39:15 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: MegaBrutal <megabrutal@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS equivalent for tune2fs?
References: <CAE8gLhnq_HjcB=Teis751eXD1FKEVTgfbY-2yDCB77-7oz5Yaw@mail.gmail.com> <547D6ABF.6030608@swiftspirit.co.za>
In-Reply-To: <547D6ABF.6030608@swiftspirit.co.za>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/02 09:31, Brendan Hide wrote:
> On 2014/12/02 07:54, MegaBrutal wrote:
>> Hi all,
>>
>> I know there is a btrfstune, but it doesn't provide all the
>> functionality I'm thinking of.
>>
>> For ext2/3/4 file systems I can get a bunch of useful data with
>> "tune2fs -l". How can I retrieve the same type of information about a
>> BTRFS file system? (E.g., last mount time, last checked time, blocks
>> reserved for superuser*, etc.)
>>
>> * Anyway, does BTRFS even have an option to reserve X% for the 
>> superuser?
> Btrfs does not yet have this option. I'm certain that specific feature 
> is in mind for the future however.
>
> As regards other equivalents, the same/similar answer applies. There 
> simply aren't a lot of tuneables available "right now".
>
Almost forgot about this: btrfs property (get|set)

Again, there are a lot of features still to be added.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

