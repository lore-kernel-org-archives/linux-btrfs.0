Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:27674 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751114AbdIKJX5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 05:23:57 -0400
Subject: Re: btrfs is slow while looping in search_bitmap
 <-btrfs_find_space_for_alloc
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <89bd6888-71a5-895d-43db-622ff129d56b@profihost.ag>
Message-ID: <37fc4210-2549-5d97-a40b-cffd1a5ce4c6@profihost.ag>
Date: Mon, 11 Sep 2017 11:23:56 +0200
MIME-Version: 1.0
In-Reply-To: <89bd6888-71a5-895d-43db-622ff129d56b@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 05.09.2017 um 07:58 schrieb Stefan Priebe - Profihost AG:
> Hello,
> 
> while expecting slow btrfs volumes i switched to kernel v4.13 and to
> space_cache=v2.
...
> 
> Is btrfs trying to hard to find free space?
Even nobody replied - i reply to myself. I could completely "fix" this
by using ssd_spread option for my raid50.

Greets,
Stefan
