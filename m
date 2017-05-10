Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:52824 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752128AbdEJHgh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 03:36:37 -0400
Subject: Re: runtime btrfsck
To: Roman Mamedov <rm@romanrm.net>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <20170510121840.06aa01b2@natsu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
Date: Wed, 10 May 2017 09:36:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170510121840.06aa01b2@natsu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Roman,

the FS is mountable. It just goes readonly when trying to write some data.

The kernel msgs are:
BTRFS critical (device dm-2): corrupt leaf, bad key order:
block=163316514816,root=1, slot=39
BTRFS critical (device dm-2): corrupt leaf, bad key order:
block=163322413056,root=1, slot=74
BTRFS critical (device dm-2): corrupt leaf, bad key order:
block=163325722624,root=1, slot=63
BTRFS critical (device dm-2): corrupt leaf, bad key order:
block=163316514816,root=1, slot=39
BTRFS: error (device dm-2) in btrfs_drop_snapshot:8839: errno=-5 IO failure
BTRFS info (device dm-2): forced readonly
BTRFS info (device dm-2): delayed_refs has NO entry

Greets,
Stefan
Am 10.05.2017 um 09:18 schrieb Roman Mamedov:
> On Wed, 10 May 2017 09:02:46 +0200
> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:
> 
>> how to fix bad key ordering?
> 
> You should clarify does the FS in question mount (read-write? read-only?)
> and what are the kernel messages if it does not.
> 
