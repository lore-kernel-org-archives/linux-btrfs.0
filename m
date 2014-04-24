Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:3377 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750752AbaDXE2k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 00:28:40 -0400
Message-ID: <535892EE.6040301@swiftspirit.co.za>
Date: Thu, 24 Apr 2014 06:28:30 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: Cycle of send/receive for backup/restore is incomplete...
References: <53583F1E.7050603@pobox.com>
In-Reply-To: <53583F1E.7050603@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replied inline:

On 2014/04/24 12:30 AM, Robert White wrote:
> So the backup/restore system described using snapshots is incomplete 
> because the final restore is a copy operation. As such, the act of 
> restoring from the backup will require restarting the entire backup 
> cycle because the copy operation will scramble the metadata 
> consanguinity.
>
> The real choice is to restore by sending the snapshot back via send 
> and receive so that all the UIDs and metadata continue to match up.
>
> But there's no way to "promote" the final snapshot to a non-snapshot 
> subvolume identical to the one made by the original btrfs subvolume 
> create operation.

btrfs doesn't differentiate snapshots and subvolumes. They're the same 
first-class citizen. A snapshot is a subvolume that just happens to have 
some data (automagically/naturally) deduplicated with another subvolume.

> Consider a file system with __System as the default mount (e.g. btrfs 
> subvolume create /__System). You make a snapshot (btrfs sub snap -r 
> /__System /__System_BACKUP). Then you send the backup to another file 
> system with send receive. Nothing new here.
>
> The thing is, if you want to restore from that backup, you'd 
> send/receive /__System_BACKUP to the new/restore drive. But that 
> snapshot is _forced_ to be read only. So then your only choice is to 
> make a writable snapshot called /__System. At this point you have a 
> tiny problem, the three drives aren't really the same.
>
> The __System and __System_BACKUP on the final drive are subvolumes of 
> /, while on the original system / and /__System were full subvolumes.

There's no such thing as a "full" subvolume. Again, they're all 
first-class citizens. The "real" root of a btrfs is always treated as a 
subvolume, as are the subvolumes inside it too. Just because other 
subvolumes are contained therein it doesn't mean they're diminished 
somehow. You cannot have multiple subvolumes *without* having them be a 
"sub" volume of the real "root" subvolume.

> It's dumb, it's a tiny difference, but it's annoying. There needs to 
> be a way to promote /__System to a non-snapshot status.
>
> If you look at the output of "btrfs subvolume list -s /" on the 
> various drives it's not possible to end up with the exact same system 
> as the original.

 From a user application perspective, the system *is* identical to the 
original. That's the important part.

If you want the disk to be identical bit for bit then you want a 
different backup system entirely, one that backs up the hard disk, not 
the files/content.

On the other hand if you just want to have all your snapshots restored 
as well, that's not too difficult. Its pointless from most perspectives 
- but not difficult.

> There needs to be either an option to btrfs subvolume create that 
> takes a snapshot as an argument to base the new device on, or an 
> option to receive that will make a read-write non-snapshot subvolume.

This feature already exists. This is a very important aspect of how 
snapshots work with send / receive and why it makes things very 
efficient. They work just as well for a restore as they do for a backup. 
The flag you are looking for is "-p" for "parent", which you should 
already be using for the backups in the first place:

 From backup host:
$ btrfs send -p /backup/path/yesterday /backup/path/last_backup | 
<netcat or whatever you choose>

 From restored host:
$ <netcat or whatever you choose> | btrfs receive /tmp/btrfs_root/

Then you make the non-read-only snapshot of the restored subvolume.

> [snip]
>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

