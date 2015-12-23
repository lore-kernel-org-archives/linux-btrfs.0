Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34973 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbbLWTq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 14:46:28 -0500
Received: by mail-ob0-f173.google.com with SMTP id 18so172581031obc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 11:46:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <n5e139$r1h$1@ger.gmane.org>
References: <n5du09$9rn$1@ger.gmane.org> <1527885.5NheBqth0k@merkaba> <n5e139$r1h$1@ger.gmane.org>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 23 Dec 2015 14:45:48 -0500
Message-ID: <CADfjVrhQCxuggAzSKMcv8m6XJFvoCy4DVueSbrCX19KV-oHAPA@mail.gmail.com>
Subject: Re: btrfs und lvm-cache?
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 6:38 AM, Neuer User <auslands-kv@gmx.de> wrote:
> Am 23.12.2015 um 12:21 schrieb Martin Steigerwald:
>> Hi.
>>
>> As far as I understand this way you basically loose the RAID 1 semantics of
>> BTRFS. While the data is redundant on the HDDs, it is not redundant on the
>> SSD. It may work for a pure read cache, but for write-through you definately
>> loose any data integrity protection a RAID 1 gives you.
>>
> Hmm, are you sure? I thought LVM lies underneath btrfs. Btrfs thus
> should not know about the caching SSD at all. It only knows of the two
> LVs on the HDDs, reading and writing data from or to one or both of the
> two LVs.

I believe Martin's concern is two-fold:

The first, major issue, concerns the default writeback cache mode,
which makes the SSD a single point of failure.
(in writeback mode, a write to a block that is cached will go only to
the cache and the block
will be marked dirty in the metadata.) If the SSD fails with dirty
data in the cache which has not been flushed to the backing devices,
the filesystem may be in a unrecoverable state, because writes which
BTRFS was told had succeeded are not present on disk.

The second potential issue is that if the SSD performs internal
deduplication, the two copies of cached data (contents on drive 1,
content on drive 2) may actually be a reference to the same bits of
internal storage, meaning a single corruption will affect both cached
copies. If in writeback, then corrupted data could flush down to both
disks. I'm not sure what would happen in writethrough.

~ Noah
