Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from net.its-24.pl ([5.63.185.56]:44780 "EHLO adrb.pl"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753027AbdBMRQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 12:16:59 -0500
Subject: Re: BTRFS for OLTP Databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
 <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
 <b0de25a7-989e-d16a-2ce6-2b6c1edde08b@gmail.com>
 <98087974-62dc-bb97-ef98-9c681f544e1b@gmail.com>
From: linux-btrfs@adrb.pl
Message-ID: <1e88c93a-8ed7-1f7c-5247-ddcc91b02ada@adrb.pl>
Date: Mon, 13 Feb 2017 18:16:45 +0100
MIME-Version: 1.0
In-Reply-To: <98087974-62dc-bb97-ef98-9c681f544e1b@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 2017-02-13 o 13:44 PM, Austin S. Hemmelgarn pisze:
> On 2017-02-09 22:58, Andrei Borzenkov wrote:
>> 07.02.2017 23:47, Austin S. Hemmelgarn пишет:
>> ...
>>> Sadly, freezefs (the generic interface based off of xfs_freeze) only
>>> works for block device snapshots.  Filesystem level snapshots need the
>>> application software to sync all it's data and then stop writing until
>>> the snapshot is complete.
>>>
>>
>> I expect databases to be using directio, otherwise we have problems even
>> without using snapshots. Is it still an issue with directio?
> It is less of an issue, but it's still an issue because you can still
> call for snapshot creation in the middle of an application I/O
> request. In other words, the application wouldn't need to worry about
> syncing data, but it would need to worry about making sure it's not
> actually writing anything when the snapshot happens.
>
I think this should work the other way around. Snapshot should wait
until all directio writes are done,

and new requests sent when creating snapshot, should wait until snapshot
is done.


-- 

Adrian Brzeziński

