Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57631 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaLQWjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 17:39:03 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Improve output of mkfs.btrfs command
Date: Wed, 17 Dec 2014 23:38:56 +0100
Message-ID: <5284555.ol6X7L4m1y@merkaba>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 17. Dezember 2014, 21:14:04 schrieb Goffredo Baroncelli:
> # mkfs.btrfs -L btrfs-test -f -M -m raid5 -d raid5 /dev/vd[b-k]"
> BTRFS filesystem summary:
>   Label:                btrfs-test
>   UUID:                 4409e381-f066-4e7b-af74-b6525fefa08b
> 
>   Node size:            4096
>   Leaf size:            4096
>   Sector size:          4096
>   Initial chunks:
>     Data+Metadata:      9.01GiB
>     System:             18.06MiB
>   Metadata profile:     RAID5
>   Data profile:         RAID5
>   Mixed mode:           YES
>   SSD detected:         NO
>   Incompat features:    mixed-bg, extref, raid56
>   Number of devices:    10
>     UUID                                  ID    SIZE    PATH
>     ------------------------------------  --  --------- -----------
>     907a3722-5d3e-4ee8-9cf1-e0e31c5edea7   1   50.00GiB /dev/vdb
>     2517a387-e060-46d1-9be7-9535802333c7   2   50.00GiB /dev/vdc
>     763dbe5e-8b16-4330-8730-8b60e245056b   3   50.00GiB /dev/vdd
>     180abbc2-4426-4f9c-a711-7735e19536d4   4   50.00GiB /dev/vde
>     666799fd-0413-42ce-bac4-a96e3e855ea2   5   50.00GiB /dev/vdf
>     a6af3e09-8469-4e57-9fa0-9d82e6c8faf1   6   50.00GiB /dev/vdg
>     e2b8a73e-2e37-4eb8-a8cb-71721a96b358   7   50.00GiB /dev/vdh
>     3fa65e67-88f6-48cc-9292-9336220e19a8   8    2.00GiB /dev/vdi
>     5a238ef4-e143-4b84-b698-347a1ceb7aa7   9    2.00GiB /dev/vdj
>     9794c5b4-8a9e-40d0-9774-b672034ef22b  10    2.00GiB /dev/vdk
> 
>   Total devices size:                         356.01GiB

I like it, thanks.

Would be nice to have an output like this also in btrfs command – to query 
existing filesystem.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
