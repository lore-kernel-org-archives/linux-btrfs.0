Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35769 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdFRGVL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 02:21:11 -0400
Received: by mail-vk0-f52.google.com with SMTP id 191so38468998vko.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jun 2017 23:21:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 18 Jun 2017 11:50:29 +0530
Message-ID: <CAKuJGC_F2khXb5GT33gTj4Kzah=HZQFVJoW2qExOxk+LBqUCkA@mail.gmail.com>
Subject: Re: [PATCH v4 00/20] Btrfs-progs offline scrub
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, dsterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> For any one who wants to try it, it can be get from my repo:
> https://github.com/adam900710/btrfs-progs/tree/offline_scrub

While running single corruption script receive  message like

"REPARIED: corrupted data with good P/Q, repaired" along with
message from script which says "Parity stripe check passed."

complete output here:
https://github.com/Lakshmipathi/btrfs_offline_scrub/blob/master/logs-june18/single_corruption_misc-tests-results.txt

------------
multiple-corruption:  While corrupting continuous blocks received:

>Filename=file256k.txt Total Stripes=4         Data Stripe to be corrupted=2,3
..
..//debugfs-tree output ends
>ERROR: full stripe 145358848 CORRUPTED: too many read error or corrupted devices
>ERROR: full stripe 145358848: tolerance: 1, missing: 0, read error: 0, csum error: 2


While corrupting non-continuous blocks:
>Filename=file512k.txt Total Stripes=8         Data Stripe to be corrupted=1,3,5
..
..//debugfs-tree output ends
>full stripe 145227776 REPARIED: corrupted data with good P/Q, repaired
>full stripe 145358848 REPARIED: corrupted data with good P/Q, repaired
>full stripe 145489920 REPARIED: corrupted data with good P/Q, repaired

output for other combinations like :
>Filename=file768k.txt Total Stripes=12       Data Stripe to be corrupted=10,8,6,4
>Filename=file1m.txt Total Stripes=16           Data Stripe to be corrupted=14,12,10,8,7,6
>Filename=file2m.txt Total Stripes=32           Data Stripe to be corrupted=23,22,21,20,19,18,16
>Filename=file4m.txt Total Stripes=64           Data Stripe to be corrupted=34,33,32,31,30,20,18,15,10,8,5
>Filename=file8m.txt Total Stripes=128           Data Stripe to be corrupted=100,90,80,70,60,50,40,30,20,10

can be found here:
https://github.com/Lakshmipathi/btrfs_offline_scrub/blob/master/logs-june18/multiple_corruptions_misc-tests-results.txt

Outputs are looking fine, but more testing required with different
file-types :-) thanks.

----
Cheers,
Lakshmipathi.G
