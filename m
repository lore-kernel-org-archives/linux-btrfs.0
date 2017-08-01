Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35138 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752704AbdHAUjp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 16:39:45 -0400
Received: by mail-qt0-f179.google.com with SMTP id p3so16172780qtg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 13:39:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dfe50824-e77a-d07b-e578-5a8d9e2c7478@gmail.com>
References: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
 <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at> <8dc4e2a0-3e83-9e60-c565-c86a924ceaf5@gmail.com>
 <CAN4oSBf1pGAS9e-SM_0NAA0jJthrOADOgapWRT+i3akWAO_h+w@mail.gmail.com> <dfe50824-e77a-d07b-e578-5a8d9e2c7478@gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 1 Aug 2017 23:39:44 +0300
Message-ID: <CAN4oSBdZP6mu6_zN_v1U406SjTbo=u=t+AGUigs2w39pEr=gLw@mail.gmail.com>
Subject: Re: Btrfs incremental send | receive fails with Error: File not found
To: A L <crimsoncottage@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Then following problem is directly related with that:
https://unix.stackexchange.com/questions/377914/how-to-test-if-two-btrfs-snapshots-are-identical

Is that a bug or a feature?


2017-08-01 23:33 GMT+03:00 A L <crimsoncottage@gmail.com>:
>
> On 8/1/2017 10:24 PM, Cerem Cem ASLAN wrote:
>>
>> What is that mean? Can't we replicate the same snapshot with `btrfs send |
>> btrfs receive` multiple times, because it will have a "Received UUID" at the
>> first `btrfs receive
>
>
> You will need to make a new read-write snapshot of the received volume to
> fix it. Any snapshots created from the received subvolume can't be used for
> send-receive again, afaik.
>
> # btrfs subvolume snapshot subvolume.received subvolume
