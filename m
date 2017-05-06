Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:60148 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbdEFF4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 May 2017 01:56:42 -0400
Subject: Re: runtime btrfsck
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
Date: Sat, 6 May 2017 07:56:38 +0200
MIME-Version: 1.0
In-Reply-To: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's still running. Is this the normal behaviour? Is there any other way
to fix the bad key ordering?

Greets,
Stefan

Am 02.05.2017 um 08:29 schrieb Stefan Priebe - Profihost AG:
> Hello list,
> 
> i wanted to check an fs cause it has bad key ordering.
> 
> But btrfscheck is now running since 7 days. Current output:
> # btrfsck -p --repair /dev/mapper/crypt_md0
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_md0
> UUID: 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
> bad key ordering 39 40
> checking extents [O]
> 
> FS is a 12TB BTRFS Raid 0 over 3 mdadm Raid 5 devices. How long should
> btrfsck run and is there any way to speed it up? btrfs tools is 4.8.5
> 
> Thanks!
> 
> Greets,
> Stefan
> 
