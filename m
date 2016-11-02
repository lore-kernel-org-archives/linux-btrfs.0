Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:50058 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753287AbcKBQV1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 12:21:27 -0400
Subject: Re: Send/receive snapshot from/between backup
To: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>,
        linux-btrfs@vger.kernel.org
References: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>
Message-ID: <7bc4c937-fbe6-2e0f-8f2c-471d6b9481ad@siedziba.pl>
Date: Wed, 2 Nov 2016 17:13:17 +0100
MIME-Version: 1.0
In-Reply-To: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02.11.2016 15:23, René Bühlmann wrote:
> Origin: S2 S3
>
> USB: S1 S2
>
> SSH: S1
>
> Transferring S3 to USB is no problem as S2 is on both btrfs drives. But
> how can I transfer S3 to SSH?

If I understand correctly how send / receive works, for the incremental
receive to work there must be a subvolume on the destination which has
"received uuid" equal to the uuid of parent choosen for the incremental
send.

> I tried to transfer...
>
> 1. S3 from Origin to SSH -> does not work as there is no common snapshot.
>
> 2. S2 from USB to SSH -> did not work.

The "received uuid" of S1 on SSH is the uuid S1 had on Origin. The uuid
of S1 on USB is different, so when choosen as parent for the incremental
send it doesn't match.

> 3. S1 from USB to Origin (such that there is a common snapshot with SSH)
> -> did not work.

There are no previously received subvolumes on Origin at all, so it
isn't going to work.

> Is it correct that 1. would work if a common snapshot is present on
> Origin and SSH?

If there was a snapshot received from Origin that still exists on
Origin, then yes, you could use it as a clone source for incremental send.

> Is it expected that 2. and 3. do not work?
>
> Is there some other way to achieve it?

I doubt you can do it without some "hacking" to fool btrfs receive.

You would need a tool that can issue BTRFS_IOC_SET_RECEIVED_SUBVOL ioctl
to change the received uuid. Then you could:

1. Change received uuid of S1 on SSH to match S1 uuid on USB.
2. Send incremental S1-S2 from USB to SSH.
3. Change received uuid of S2 on SSH to match S2 on Origin.
4. Send incremental S2-S3 from Origin to SSH.

Regards
