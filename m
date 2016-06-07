Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33094 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcFGDzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 23:55:36 -0400
Received: by mail-oi0-f45.google.com with SMTP id k23so257959937oih.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 20:55:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465262352.3622603.629909497.30BD010E@webmail.messagingengine.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
	<7fea30e3-a39a-e72d-4776-7a7bfe4f7ef5@gmail.com>
	<1465262352.3622603.629909497.30BD010E@webmail.messagingengine.com>
Date: Mon, 6 Jun 2016 21:55:35 -0600
Message-ID: <CAJCQCtRaVT_=bj3oFpGSAsVN0n1LpvCeNYVHeqLARH+X9puYww@mail.gmail.com>
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
From: Chris Murphy <lists@colorremedies.com>
To: Kai Hendry <hendry@iki.fi>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 6, 2016 at 7:19 PM, Kai Hendry <hendry@iki.fi> wrote:
> On Mon, 6 Jun 2016, at 10:16 PM, Austin S. Hemmelgarn wrote:
>> Based on the fact that you appear to want to carry a disk to copy data
>> more quickly than over then internet, then what you've already done plus
>> this is the correct way to do it.
>
> The trouble is the way I ended up doing it:
> 1) Replacing it with a bigger disk
> 2) Deleting the disk
> 3) btrfs send /mnt/raid1/snapshot | btrfs receive /mnt/onetb/
>
> This took almost **an entire day** over USB3 spinning disks  !
>
> My expectation was that I could quickly remove a mirrored disk, replace
> that disk and hand carry the disk I removed. btrfs shouldn't remove data
> from the disk I removed.

Had this been a two drive raid1, all you need to do is take one drive
with you. No commands necessary. Each drive can be separately mounted
with -o degraded, and you can re-establish two copy replication with
'btrfs dev add' with a new drive and 'btrfs dev del missing' to get
rid of the phantom missing drive. You'd do that locally and then also
at your destination.

A gotcha with this technique though is often single chunks get created
during the -o degraded read-write mount. After 'dev del missing'
completes the replication process, you need to check 'fi df' or 'fi
us' for single chunks. If they exist, get rid of them with a filtered
balance. '-dconvert=raid1,soft -mconvert=raid1,soft' should work I
think. If there are single chunks created and not converted, later if
you need to do a degraded mount it will fail. Usually it can be made
to work with -o ro,degraded in such a case, but it means no more
read-write for the file system, you'd have to recreate it (at this
point until it's fixed).


-- 
Chris Murphy
