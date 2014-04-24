Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:39088 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbaDXHIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 03:08:41 -0400
Message-ID: <5358B877.4040204@pobox.com>
Date: Thu, 24 Apr 2014 00:08:39 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Cycle of send/receive for backup/restore is incomplete...
References: <53583F1E.7050603@pobox.com> <535892EE.6040301@swiftspirit.co.za>
In-Reply-To: <535892EE.6040301@swiftspirit.co.za>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am, then, quite confused...

On 04/23/2014 09:28 PM, Brendan Hide wrote:
> Replied inline:
> btrfs doesn't differentiate snapshots and subvolumes. They're the same
> first-class citizen. A snapshot is a subvolume that just happens to have
> some data (automagically/naturally) deduplicated with another subvolume.

What then is the -s for in

btrfs subvolume list -s <mount point>

Clearly some information of bias and status exists or the option and its 
functional behavior wouldn't exist.

I understand the use of -p for doing diffs, but here's the thing...

mount /dev/sda /drivea
mount /dev/sdb /driveb

btrfs subvolume create /drivea/Base
btrfs subvolume snapshot -r /drivea/Base /drivea/Base_BACKUP

btrfs subvolume list -a /drivea
[blah blah blah] Base
[blah blah blah] Base_BACKUP

* skipping the network and delta-T nonsense as irrelevant
btrfs send /drivea/Base_BACKUP | btrfs receive /driveb/

*No way to make /driveb/Base_BACKUP _not_ end up read only
*So make a writeable snapshot

btrfs subvolume snapshot /driveb/Base_BACKUP /driveb/Base

btrfs subvolume list -a /driveb
[blah blah blah] Base_BACKUP
[blah blah blah] Base

**** Confusing and/or problematic bit:
btrfs subvolume list -s /drivea
[blah blah blah] Base_BACKUP

btrfs subvolume list -s /driveb
[blah blah blah] Base

So if I want to, say, write a backup script that rotates through the 
subvolumes to rotor backups, the restored drive (driveb in this example) 
automatically fails. There is no apparent way to coerce the relationship 
such that both drives end up with "Base" being the writable base and 
"Base_BACKUP" be the read-only snapshot returned when doing list -s.

So the systems are "the same" but they aren't really the same according 
to this clearly visible symptom.

As such various automations that one might right for an original system 
could then choke and die after restoration from this backup. Either that 
or you have to use /bin/cp (or similar) and lose the backup history when 
you restore.

Its a surprise waiting to happen. It surprised me.

It's _impossible_ to strip Base of it's subvolume status on /driveb. If 
you delete the Base_BACKUP element so that Base is the only thing on the 
drive, it's still a shapshot according to -s. What does this status even 
mean if it's as meaningless as it seems.

That seems like a second surprise.

---

Is this a common case? It could easily be if you use NAS or movable USB 
to do your backups and restore-or-media-migration operations.

Are we sure it doesn't matter? I find it problematic but fixable in 
concept. I've got no information whether the internal parentage 
relationship could be reversed so that the before and after of the 
subvolume list -s result are the same.

No I'm not looking for byte-level identical status, I know that's 
ridiculous.

I want semantically identical status.

My experience with list -s says I'm not getting semantically identical 
status after the fact and I have no clear way to coerce it.

====

Why it matters...

If I am doing monthly and weekly archiving I don't want to interrupt the 
rolling archive(s) if I end up having to do a restore. I don't want to 
create a catastrophe point or an interrupting epoch in the archive history.

It sounds like it doesn't matter once you know not to use the -s status 
for anything...
