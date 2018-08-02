Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-4.smtp-out.eu-west-1.amazonses.com ([54.240.4.4]:39250 "EHLO
        a4-4.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732298AbeHBPFl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 11:05:41 -0400
Subject: Re: BTRFS and databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm96B1xxoMv=sYuaNeLYRDP3YUw2qsKumpjLm+jJVjfQQ@mail.gmail.com>
 <1276acbf-a834-cd7e-1f06-56e13386a240@gmx.com>
 <940C43FD-9710-4DAC-937E-6BE290A7A6F6@gmail.com>
 <4f670d3d-5586-5a34-d043-3015e180cb52@gmx.com>
 <4ff454bb-c1d6-46a7-e2c8-6667e2f7954c@gmail.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <01020164fac67c50-9b312e7c-6604-4771-98d1-22466daf5dca-000000@eu-west-1.amazonses.com>
Date: Thu, 2 Aug 2018 13:14:29 +0000
MIME-Version: 1.0
In-Reply-To: <4ff454bb-c1d6-46a7-e2c8-6667e2f7954c@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02.08.2018 14:27 Austin S. Hemmelgarn wrote:
> On 2018-08-02 06:56, Qu Wenruo wrote:
>>
>> On 2018年08月02日 18:45, Andrei Borzenkov wrote:
>>>
>>> Отправлено с iPhone
>>>
>>>> 2 авг. 2018 г., в 10:02, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>> написал(а):
>>>>
>>>>> On 2018年08月01日 11:45, MegaBrutal wrote:
>>>>> Hi all,
>>>>>
>>>>> I know it's a decade-old question, but I'd like to hear your thoughts
>>>>> of today. By now, I became a heavy BTRFS user. Almost everywhere I
>>>>> use
>>>>> BTRFS, except in situations when it is obvious there is no benefit
>>>>> (e.g. /var/log, /boot). At home, all my desktop, laptop and server
>>>>> computers are mainly running on BTRFS with only a few file systems on
>>>>> ext4. I even installed BTRFS in corporate productive systems (in
>>>>> those
>>>>> cases, the systems were mainly on ext4; but there were some specific
>>>>> file systems those exploited BTRFS features).
>>>>>
>>>>> But there is still one question that I can't get over: if you store a
>>>>> database (e.g. MySQL), would you prefer having a BTRFS volume mounted
>>>>> with nodatacow, or would you just simply use ext4?
>>>>>
>>>>> I know that with nodatacow, I take away most of the benefits of BTRFS
>>>>> (those are actually hurting database performance – the exact CoW
>>>>> nature that is elsewhere a blessing, with databases it's a drawback).
>>>>> But are there any advantages of still sticking to BTRFS for a
>>>>> database
>>>>> albeit CoW is disabled, or should I just return to the old and
>>>>> reliable ext4 for those applications?
>>>>
>>>> Since I'm not a expert in database, so I can totally be wrong, but
>>>> what
>>>> about completely disabling database write-ahead-log (WAL), and let
>>>> btrfs' data CoW to handle data consistency completely?
>>>>
>>>
>>> This would make content of database after crash completely
>>> unpredictable, thus making it impossible to reliably roll back
>>> transaction.
>>
>> Btrfs itself (with datacow) can ensure the fs is updated completely.
>>
>> That's to say, even a crash happens, the content of the fs will be the
>> same state as previous btrfs transaction (btrfs sync).
>>
>> Thus there is no need to rollback database transaction though.
>> (Unless database transaction is not sync to btrfs transaction)
>>
> Two issues with this statement:
>
> 1. Not all database software properly groups logically related
> operations that need to be atomic as a unit into transactions.
> 2. Even aside from point 1 and the possibility of database corruption,
> there are other legitimate reasons that you might need to roll-back a
> transaction (for example, the rather obvious case of a transaction
> that should not have happened in the first place).

I thought of a database transaction scheme that is based on btrfs
features before. It has practical issues, though.
One would put a b-tree database file into a subvolume (e.g. trans_0).
When changing the b-tree database one would create a snapshot (trans_1),
then change the file in the snapshot. On commit sync trans_1, then
delete trans_0. On rollback, delete trans_1.

Problems:
* Large overhead for small transactions (OLTP) -- problem in general for
copy-on-write b-tree databases
* Only root can create or destroy snapshots
* Per default the Linux memory system starts write-back pretty much
immediately, so pages that get overwritten more than once in a
transaction (and not kept in RAM) unless Linux is tuned to not do this.

I have used this method, albeit by reflinking the database, then
modifying the reflink, but I think reflinking it slower than creating a
snapshot?
