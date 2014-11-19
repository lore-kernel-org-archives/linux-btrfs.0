Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:51798 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbaKSCsw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 21:48:52 -0500
Message-ID: <546C0513.6020306@pobox.com>
Date: Tue, 18 Nov 2014 18:48:51 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: NEEDED :: btrfs subvol recreate (and related UUID issues)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I finally figured out how to ask about this correctly.

As near as I can tell the difference between a subvolume created with 
create and a subvolume created with snapshot is the existence of the 
parent_uuid datum. Create has no parent, snapshot has the its 
parent_uuid equal to the doner/origin subvol.

given

btrfs subvol create /vol1 #UUID=A
# things happen
btrfs subvol snap /vol1 /vol1_snap1 #UUID=B,PUUID=A
# more things happen
btrfs subvol snap /vol1 /vol1_snap2 #UUID=C,PUUID=A

I _should_ be able to do something like

btrfs subvol delete /vol1
btrfs subvol recreate /vol1_snap1 /vol1 # any name really

and if the first /vol1 had a UUID=A then the new /vol1 (or whatever 
name) should also have a UUID=A which would effectively recreate the 
parent as proper parent for /vol1_snap1 and /vol1_snap2 etc.

ADDITIONALLY

There should be a --force option to recreate that would delete any 
conflicting parent while doing the recreate within a transaction.

e.g. btrfs subvol recreate --force /vol1_snap2 /newvol

would result in
open_transaction;
find UUID=A and delete;
create new UUID=A with name /newvol (possibly the same name);
copy/reflink in root items a-la snapshot, from donor object q.v #UUID=C;
commit_transaction.

ADDITIONALLY I'd _expect_

btrfs subvol snap /vol1_snap2 /vol1_snap3
to produce #UUID=D,PUUID=A instead of the current #UUID=D,PUUID=C either 
as the default or in response to a theoretical opton such as --peer

I understand that you are really copying/reflinking UUID=C or =B in the 
respective cases, but the actual use cases I am hitting really do need a 
more stable/predictable parentage tree.

It is *particularly* vexing that the btrfs receive(d) incremental 
snapshots have a completely different parentage layout compared to the 
original snapshots and the non-relative ones.

====== Example Use Case ======

My "stock" drive layout is to make a btrfs as in

mkfs.btrfs /dev/sdx
mount /dev/sdx /target
btrfs subvol create /target/__System # eventual root subvolume
btrfs subvol create /target/home

Then I do the normal sutff and make snapshots that I transfer to 
external (USB) drive(s) for backup. I do the whole incremental send 
thing etc. Typically two (one on-site, one off-site). The backup drives 
have subdirectories for different hosts, so 
"/backup/hostA/__System_BACKUP_$date" is a typical file name.

In an emergency I'd want to be able to plug in that local copy USB drive 
somewhere, do a "btrfs subvol recreate /hostA/__System_whatever 
/__System" then plug it into the failed box and get it back up in least 
available time _without_ breaking the parentage of the subsequent 
off-site backups. (since the target drive _never_ had /__System this 
isn't even an on-media collision).


====== Total Apparent Expense =====

I'm not gods gift to this code base (yet), it looks like a recreate 
operation would involve adding boolean(s) to struct 
btrfs_pending_snapshot just like the existing "readonly", so like 
recreate_parent, peer_snap and then juggling transaction.c (at about 
line 1249)

         uuid_le_gen(&new_uuid);
         memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
         memcpy(new_root_item->parent_uuid, root->root_item.uuid,
                         BTRFS_UUID_SIZE);

so that

if (pending->recreate_parent) {
         memcpy(new_root_item->uuid, root->root_item.parent_uuid,
                         BTRFS_UUID_SIZE);
} else if (pending->peer_snap)
         uuid_le_gen(&new_uuid);
         memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
         memcpy(new_root_item->parent_uuid, root->root_item.parent_uuid,
                         BTRFS_UUID_SIZE);
} else {
         uuid_le_gen(&new_uuid);
         memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
         memcpy(new_root_item->parent_uuid, root->root_item.uuid,
                         BTRFS_UUID_SIZE);
}

plus the delete/collision check if it's not already in there...


SO....

Is this something worth doing?
Am I on a wrong track technologically?

Is there anything glaringly wrong with these ideas?

-- Rob.
