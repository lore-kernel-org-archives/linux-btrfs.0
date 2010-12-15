From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Wed, 15 Dec 2010 20:26:49 +0100
Message-ID: <4D091679.80706@logtenberg.eu>
References: <4D08E76B.40400@logtenberg.eu> <1292439708-sup-2951@think> <4D091387.9050905@logtenberg.eu> <1292440771-sup-9278@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292440771-sup-9278@think>
List-ID: <linux-btrfs.vger.kernel.org>

>> Is there a decent way to have btrfs compress already existing files
>> (that were written before compression was enabled) without hurting any
>> of the internal structures such as snapshots?
> 
> I'm afraid not yet.  There is code for this in the btrfs balance
> routines, but we haven't yet adapted it to the defragment command.

Okay, just to be 100% sure, if I add -o compress to the mount options,
this will cause btrfs to (try to) compress newly written files, right?
Is this fully compatible with existing snapshots, or will compressing
files always (have a chance to) hurt COW relations?

The use case is a filesystem used for backups, which are rsynced
nightly, after which a new snapshot is made. After something like 45
days, the old snapshots are removed. I am assuming that this way, after
45 days all files will be compressed naturally, but this is only
beneficial if snapshots still fully work. If instead it results in
storing the compressed form of every file 45 times on disk, then it
won't help much.

Kind regards,

Erik.
