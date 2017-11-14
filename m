Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:49494 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756548AbdKNUbd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 15:31:33 -0500
Subject: Re: how to repair or access broken btrfs?
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <32c4071e-4ec0-4d22-95f9-68b22725cff7@profihost.ag>
 <c43e6c85-2ecc-47a6-2a59-45c65dd693bc@gmail.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <275e422d-ad06-d0bc-b3f4-7f269226676d@profihost.ag>
Date: Tue, 14 Nov 2017 21:31:29 +0100
MIME-Version: 1.0
In-Reply-To: <c43e6c85-2ecc-47a6-2a59-45c65dd693bc@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 14.11.2017 um 18:45 schrieb Andrei Borzenkov:
> 14.11.2017 12:56, Stefan Priebe - Profihost AG пишет:
>> Hello,
>>
>> after a controller firmware bug / failure i've a broken btrfs.
>>
>> # parent transid verify failed on 181846016 wanted 143404 found 143399
>>
>> running repair, fsck or zero-log always results in the same failure message:
>> extent-tree.c:2725: alloc_reserved_tree_block: BUG_ON `ret` triggered,
>> value -1
>> .. stack trace ..
>>
>> Is there an chance to get at least a single file out of the broken fs?
>>
> 
> Did you try "btrfs restore"?

Great that worked for that file. Still wondering why a repair is not
possible.

Greets,
Stefan

