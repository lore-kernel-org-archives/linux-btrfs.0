Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:56842 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaK3Db6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 22:31:58 -0500
Received: by mail-qg0-f44.google.com with SMTP id z60so6304556qgd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 19:31:57 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 09:01:37 +0530
Message-ID: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
Subject: root subvol id is 0 or 5?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am confused with this: should I call it the "root subvol" or
"top-level subvol" or "default subvol" or doesn't it matter? Are all
subvols equal, or some are more equal than others [hark to Orwell's
Animal Farm ;-)]?

And more importantly, is the ID of the root subvol 0 or 5?

The Oracle guide
(https://docs.oracle.com/cd/E37670_01/E37355/html/ol_use_case3_btrfs.html)
seems to say it's 0 :

"By default, the operating system mounts the parent btrfs volume,
which has an ID of 0"

but the BtrFS wiki (and btrfs subvol manpage) reads 5:

"every btrfs filesystem has a default subvolume as its initially
top-level subvolume, whose subvolume id is 5(FS_TREE)."

as also the Ubuntu Wiki:

"The default subvolume to mount is always the top of the btrfs tree
(subvolid=5)."

Now this Oracle page
http://www.oracle.com/technetwork/articles/servers-storage-admin/advanced-btrfs-1734952.html
says:

"The only clean way to destroy the default subvolume is to rerun the
mkfs.btrfs command, which would destroy existing data."

So from what I've (confusedly) understood so far, 0 refers to the
superstructure (or whatchamacallit) of the entire BtrFS-based contents
of the device(s) and hence cannot be deleted but only reset by a
mkfs.btrfs, but 5 is only the default subvol (mounted when the FS as a
whole is mounted without subvol spec) provided by mkfs.btrfs, and
subvol set-default can have another subvol mounted as default instead,
after which 5 can actually be deleted?

[confused]...

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
