Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62936 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbdHNHri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:47:38 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Paul Jones <paul@pauljones.id.au>, Christoph Hellwig <hch@infradead.org>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <MEXPR01MB2168FD458234B54167D9674F9E8C0@MEXPR01MB2168.ausprd01.prod.outlook.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d06d02ec-93b7-078b-55f5-4cc94787a480@gmx.com>
Date: Mon, 14 Aug 2017 15:46:59 +0800
MIME-Version: 1.0
In-Reply-To: <MEXPR01MB2168FD458234B54167D9674F9E8C0@MEXPR01MB2168.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月14日 15:43, Paul Jones wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Qu Wenruo
>> Sent: Monday, 14 August 2017 4:37 PM
>> To: Christoph Hellwig <hch@infradead.org>; Christoph Anton Mitterer
>> <calestyo@scientia.net>
>> Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
>> Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
>>
>>
>>
>> On 2017年08月12日 15:42, Christoph Hellwig wrote:
>>> On Sat, Aug 12, 2017 at 02:10:18AM +0200, Christoph Anton Mitterer wrote:
>>>> Qu Wenruo wrote:
>>>>> Although Btrfs can disable data CoW, nodatacow also disables data
>>>>> checksum, which is another main feature for btrfs.
>>>>
>>>> Then decoupling of the two should probably decoupled and support for
>>>> notdatacow+checksumming be implemented?!
>>>
>>> And how are you going to write your data and checksum atomically when
>>> doing in-place updates?
>>
>> Exactly, that's the main reason I can figure out why btrfs disables checksum
>> for nodatacow.
> 
> But does it matter if it's not strictly atomic? By turning off COW it implies you accept the risk of an ill-timed failure.

The problem here is, if you enable csum and even data is updated 
correctly, only metadata is trashed, then you can't even read out the 
correct data.

As btrfs csum checker will just prevent you from reading out any data 
which doesn't match with csum.

Now it's not just data corruption, but data loss then.

Thanks,
Qu

> Although from my point of view any reason that would require COW to be disabled implies you're using the wrong filesystem anyway.
> 
> Paul.
> 
> 
> 
> 
> 
> 
> 
