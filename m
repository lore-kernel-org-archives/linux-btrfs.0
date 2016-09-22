Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33057 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754045AbcIVCof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 22:44:35 -0400
Received: by mail-oi0-f66.google.com with SMTP id w11so5221205oia.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 19:44:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com> <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com> <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
 <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Sep 2016 20:44:33 -0600
Message-ID: <CAJCQCtQMZFnHhD0v0Qtwyh=MgeiMZjuWODY5unVLSVEUQMNYDQ@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 8:08 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 09/21/2016 11:13 PM, Chris Murphy wrote:

>> I understand some things should go in fsck for comparison. But in this
>> case I don't see how it can help. Parity is not checksummed. The only
>> way to know if it's wrong is to read all of the data strips, compute
>> parity, and compare in-memory parity from current read to on-disk
>> parity.
>
>
> That's what we plan to do.
> And I don't see the necessary to csum the parity.
> Why csum a csum again?

parity!=csum


http://www.spinics.net/lists/linux-btrfs/msg56602.html



>> There is already an offline scrub in btrfs
>> check which doesn't repair, but also I don't know if it checks parity.
>>
>>        --check-data-csum
>>            verify checksums of data blocks
>
>
> Just as you expected, it doesn't check parity.
> Even for RAID1/DUP, it won't check the backup if it succeeded reading the
> first stripe.

Both copies are not scrubbed? Oh hell...

[chris@f24s ~]$ sudo btrfs scrub status /brick2
scrub status for 7fea4120-9581-43cb-ab07-6631757c0b55
    scrub started at Tue Sep 20 12:16:18 2016 and finished after 01:46:58
    total bytes scrubbed: 955.93GiB with 0 errors

How can this possibly correctly say 956GiB scrubbed if it has not
checked both copies? That message is saying *all* the data, both
copies, were scrubbed. You're saying that message is wrong? It only
scrubbed half that amount?

[chris@f24s ~]$ sudo btrfs fi df /brick2
Data, RAID1: total=478.00GiB, used=477.11GiB
System, RAID1: total=32.00MiB, used=96.00KiB
Metadata, RAID1: total=2.00GiB, used=877.59MiB
GlobalReserve, single: total=304.00MiB, used=0.00B


When that scrub was happening, both drives were being accessed at 100%
throughput.







>
> Current implement doesn't really care if it's the data or the copy
> corrupted, any data can be read out, then there is no problem.
> The same thing applies to tree blocks.
>
> So the ability to check every stripe/copy is still quite needed for that
> option.
>
> And that's what I'm planning to enhance, make --check-data-csum to kernel
> scrub equivalent.

OK thanks.


>
>>
>>            This expects that the filesystem is otherwise OK, so this
>> is basically and
>>            offline scrub but does not repair data from spare coipes.
>
>
> Repair can be implemented, but maybe just rewrite the same data into the
> same place.
> If that's a bad block, then it can't repair further more unless we can
> relocate extent to other place.

Any device that's out of reserve sectors and can no longer remap LBA's
on its own, is a drive that needs to be decommissioned. It's a new
feature in just the last year or so that mdadm has a badblocks map so
it can do what the drive won't do, but I'm personally not a fan of
keeping malfunctioning drives in RAID.


>
>>
>> Is it possible to put parities into their own tree? They'd be
>> checksummed there.
>
>
> Personally speaking, this is quite a bad idea to me.
> I prefer to separate different logical layers into their own codes.
> Not mixing them together.
>
> Block level things to block level(RAID/Chunk), logical thing to logical
> level(tree blocks).

OK.

>
> Current btrfs csum design is already much much better than pure RAID.
> Just think of RAID1, while one copy is corrupted, then which copy is correct
> then?

Yes.


-- 
Chris Murphy
