Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:54098 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732751AbeHABUm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 21:20:42 -0400
Subject: Re: Expected Received UUID
To: Gaurav Sanghavi <gaurav.ms5@gmail.com>, linux-btrfs@vger.kernel.org
References: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <bdc26113-5a70-0802-7f12-1a43f7a92aee@mendix.com>
Date: Wed, 1 Aug 2018 01:37:59 +0200
MIME-Version: 1.0
In-Reply-To: <CANfewpG7XK5FD5Q_i27=0L9P6P-W-Zwwcu8CC2mCmO1s4AbTBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Can you please report the kernel versions you are using on every system
(uname -a)?

I would indeed expect the Received UUID value for C to have the same
uuid as the original UUID of A, so the b00e8ba1 one.

The send part, generating the send stream is done by the running kernel.
The receive part is done by the userspace btrfs progs. The btrfs progs
receive code just sets the Received UUID to whatever it reads from the
send stream information.

So, your sending kernel version is important here.

When looking up the lines that send the UUID, in fs/btrfs/send.c, I can
see there was a problem like this in the past:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b96b1db039ebc584d03a9933b279e0d3e704c528

I was introduced between linux 4.1 and 4.2 and solved in 2015 with that
commit, which ended up somewhere in 4.3 I think.

>From the btrfs-progs versions you list, I suspect this is a Debian
Jessie and 2x Debian Stretch, but the Debian 3.16 and 4.9 kernels would
not should not have this issue.

On 07/31/2018 07:42 PM, Gaurav Sanghavi wrote:
> Hello everyone, 
> 
> While researching BTRFS for a project that involves backing up snapshots
> from device A to device B 
> before consolidating backups from device B to device C, I noticed that
> received UUID on snapshot on 
> device C is not the same as received UUID for the same snapshot on
> device B. Here are my steps:
> 
> 1. Device A
> BTRFS version: v3.17
> 
> btrfs su sn -r /home/test/snapshot1 /home/test/snaps/snapshot1
> btrfs su show /home/test/snaps/snapshot1
> Name: snapshot1
> uuid: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> Parent uuid: cb570dec-e9fd-1f40-99d2-2070c8ee2466
>         Received UUID:      ---
> Creation time: 2018-07-30 18:32:37
> Flags: readonly
> 
> 2. Send to Device B
> btrfs send /home/test/snaps/snapshot1 | ssh <device b> 'btrfs receive
> /home/backups/'
> 
> After send completes, on Device B
> BTRFS version: v4.7.3
> btrfs su show /home/backups/snapshot1
> Name: snapshot1
> UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> Parent UUID: a2314f7c-4b11-ed40-901f-f1acb5ebf802
> Received UUID: b00e8ba1-5aaa-3641-9c4c-e168eee5c296
> Creation time: 2018-07-30 18:42:37 -0700
> Flags: readonly
> 
> 
> 3. Send to Device C
> btrfs send /home/backups/snapshot1 | ssh <device c> 'btrfs receive
> /home/backups2/'
> 
> After send completes, on Device C
> BTRFS version: v4.7.3
> btrfs su show /home/backups2/snapshot1
> Name: snapshot1
> UUID: 8a13aab5-8e44-2541-9082-bc583933b964
> Parent UUID: 54e9b4ff-46dc-534e-b70f-69eb7bb21028
> Received UUID: 7c13d189-7fee-584e-ac90-e68cb0012f5c
> Creation time: 2018-07-30 18:58:32 -0700
> Flags: readonly
> 
> 1. I have gone through some of the archived emails and have noticed
> people mentioning that
> if received UUID is set, btrfs send propogates this 'received UUID'. But
> in above case, 
> it's different for the same snapshot on all three devices. Is this the
> expected behavior ?
> 
> 2. We want to be able to start backing up from Device A to C, in case B
> goes down or needs 
> to be replaced. If received UUID is expected to differ for the snapshot
> on device B and C, incremental
> backups will not work from A to C without setting received UUID. I have
> seen python-btrfs
> mentioned in a couple of emails; but have anyone of you used it in a
> production environment ?
> 
> This is my first post to this email. Please let me know if I am missing
> any details.
> 
> Thanks,
> Gaurav
> 

-- 
Hans van Kranenburg
