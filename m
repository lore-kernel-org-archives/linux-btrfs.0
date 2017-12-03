Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-1.smtp-out.eu-west-1.amazonses.com ([54.240.4.1]:47690 "EHLO
        a4-1.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752433AbdLCPjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Dec 2017 10:39:12 -0500
Subject: Re: again "out of space" and remount read only, with 4.14
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <dfdbf8227acb0f10ed14edb0a8638ce0@virtall.com>
 <0102015ff8f9e46f-83a96bab-ee99-4ec2-b09f-7801b64fc2d5-000000@eu-west-1.amazonses.com>
 <ddbe76a2ddcf5d7d7b18f3c7f09294bd@virtall.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <010201601d07f939-cc695404-9e62-4a08-91a7-bad00c0827e7-000000@eu-west-1.amazonses.com>
Date: Sun, 3 Dec 2017 15:39:10 +0000
MIME-Version: 1.0
In-Reply-To: <ddbe76a2ddcf5d7d7b18f3c7f09294bd@virtall.com>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 26.11.2017 um 17:02 schrieb Tomasz Chmielewski:
> On 2017-11-27 00:37, Martin Raiber wrote:
>> On 26.11.2017 08:46 Tomasz Chmielewski wrote:
>>> Got this one on a 4.14-rc7 filesystem with some 400 GB left:
>> I guess it is too late now, but I guess the "btrfs fi usage" output of
>> the file system (especially after it went ro) would be useful.
> It was more or less similar as it went ro:
>
> # btrfs fi usage /srv
> Overall:
>     Device size:                   5.25TiB
>     Device allocated:              4.45TiB
>     Device unallocated:          823.97GiB
>     Device missing:                  0.00B
>     Used:                          4.33TiB
>     Free (estimated):            471.91GiB      (min: 471.91GiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Unallocated:
>    /dev/sda4     411.99GiB
>    /dev/sdb4     411.99GiB

I wanted to check if is the same issue I have, e.g. with 4.14.1
space_cache=v2:

[153245.341823] BTRFS: error (device loop0) in
btrfs_run_delayed_refs:3089: errno=-28 No space left
[153245.341845] BTRFS: error (device loop0) in btrfs_drop_snapshot:9317:
errno=-28 No space left
[153245.341848] BTRFS info (device loop0): forced readonly
[153245.341972] BTRFS warning (device loop0): Skipping commit of aborted
transaction.
[153245.341975] BTRFS: error (device loop0) in cleanup_transaction:1873:
errno=-28 No space left
# btrfs fi usage /media/backup
Overall:
    Device size:                  49.60TiB
    Device allocated:             38.10TiB
    Device unallocated:           11.50TiB
    Device missing:                  0.00B
    Used:                         36.98TiB
    Free (estimated):             12.59TiB      (min: 12.59TiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:                2.00GiB      (used: 1.99GiB)

Data,single: Size:37.70TiB, Used:36.61TiB
   /dev/loop0     37.70TiB

Metadata,single: Size:411.01GiB, Used:380.98GiB
   /dev/loop0    411.01GiB

System,single: Size:36.00MiB, Used:4.00MiB
   /dev/loop0     36.00MiB

Unallocated:
   /dev/loop0     11.50TiB

Note the global reserve being at maximum. I already increased that in
the code to 2G and that seems to make this issue appear more rarely.

Regards,
Martin Raiber


