Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51004 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdCQORg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 10:17:36 -0400
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Roman Mamedov <rm@romanrm.net>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
 <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
 <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
 <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
 <20170317145107.21bb9b45@natsu>
 <74575358-1fee-404d-51e4-6fb51348c10f@bouton.name>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <4bf87df3-0a4a-bd16-62f0-3bdfb76be1f3@bouton.name>
Date: Fri, 17 Mar 2017 15:17:25 +0100
MIME-Version: 1.0
In-Reply-To: <74575358-1fee-404d-51e4-6fb51348c10f@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

some news from the coal mine...

Le 17/03/2017 à 11:03, Lionel Bouton a écrit :
> [...]
> I'm considering trying to use a 4 week old snapshot of the device to
> find out if it was corrupted or not instead. It will still be a pain if
> it works but rsync for less than a month of data is at least an order of
> magnitude faster than a full restore.

btrfs check -p /dev/sdb is running on this 4 week old snapshot. The
extents check passed without any error, it is currently checking the
free space (and it's just done while I was writing this and is doing fs
roots).

I'm not sure of the list of checks it performs. I assume the free
space^H... fs roots can't be much longer than the rest (on a ~13TB of
20TB used filesystem with ~ 10 million files and half a dozen subvolumes).
It took less than an hour to check extents. I'll give it another hour
and stop it if its not done : it's already passing stages than the live
data couldn't get to.

I may be wrong but I suspect Ceph is innocent of any wrong-doing here :
I think there's a high probability that if Ceph could corrupt its data
in our configuration the snapshot would have been corrupted too (most of
its data is shared with the live data). I wonder if QEMU or the VM
kernel managed to transform IO timeouts (which clearly happened below
Ceph and were passed to the VM in many instances) into garbage reads
which ended in garbage writes. If it isn't in QEMU and happened in the
kernel this was with 4.1.15 so it might be a corrected kernel bug in
either the block or fs layers. I'm not especially ecstatic at the
prospect of testing this behavior again but I will automate more Ceph
snapshots in the future (and the VM is now on 4.9.6).

Best regards,

Lionel
