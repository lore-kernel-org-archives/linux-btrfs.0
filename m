Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:51164 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbcKIUT1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 15:19:27 -0500
Subject: Re: spinning kworker with space_cache=v2 searching for free space
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
References: <c9bf6cbb-ea68-a517-3c6e-7ff4ec1a788e@profihost.ag>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <c01a47a5-ff65-1a6e-861f-ab7782bee0ed@profihost.ag>
Date: Wed, 9 Nov 2016 21:19:21 +0100
MIME-Version: 1.0
In-Reply-To: <c9bf6cbb-ea68-a517-3c6e-7ff4ec1a788e@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

found this one from 2014:
https://patchwork.kernel.org/patch/5551651/

it this still valid?

Am 09.11.2016 um 09:09 schrieb Stefan Priebe - Profihost AG:
> Dear list,
> 
> even there's a lot of free space on my disk:
> 
> # df -h /vmbackup/
> Filesystem                    Size  Used Avail Use% Mounted on
> /dev/mapper/stripe0-backup   37T   24T   13T  64% /backup
> 
> # btrfs filesystem df /backup/
> Data, single: total=23.75TiB, used=22.83TiB
> System, DUP: total=8.00MiB, used=3.94MiB
> Metadata, DUP: total=283.50GiB, used=105.82GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> I always have a kworker process endless spinning.
> 
> # perf top shows:
>   47,56%  [kernel]               [k] rb_next
>    7,71%  [kernel]               [k] tree_search_offset.isra.25
>    6,44%  [kernel]               [k] btrfs_find_space_for_alloc
> 
> Mount options:
> rw,noatime,compress-force=zlib,nossd,noacl,space_cache=v2,skip_balance
> 
> What's wrong here?
> 
> Greets,
> Stefan
> 
