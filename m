Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:38009 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdH1GnJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 02:43:09 -0400
Received: by mail-wr0-f182.google.com with SMTP id y14so7385228wrd.5
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Aug 2017 23:43:08 -0700 (PDT)
Subject: Re: deleted subvols don't go away?
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1503854146.5155.2.camel@scientia.net>
 <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <cab790fa-22f7-b05d-b18e-000c7d1a81cd@gmail.com>
Date: Mon, 28 Aug 2017 09:43:06 +0300
MIME-Version: 1.0
In-Reply-To: <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.08.2017 06:43, Janos Toth F. wrote:
> ID=5 is the default, "root" or "toplevel" subvolume which can't be
> deleted anyway (at least normally, I am not sure if some debug-magic
> can achieve that).
> I just checked this (out of curiosity) and all my Btrfs filesystems
> report something very similar to yours (I thought DELETED was a made
> up example but I see it was literal...):
> 
> ~ # btrfs sub list -a /
> ID 303 gen 172881 top level 5 path <FS_TREE>/gentoo
> ~ # btrfs sub list -ad /
> ID 5 gen 172564 top level 0 path <FS_TREE>/DELETED

This seems to be coming form the userspace tools, specifically the
filter_and_sort_subvol() function. So this function in turn calls
resolve_root and if it returns -ENOENT, meaning it couldn't resolve a
root. Then DELETED is returned.

On a quick inspection of the code it seems that even for deleted
subvolumes btrfs still retains the ROOT_ITEM for the subvolume but since
all ROOT_BACKREF are deleted then the name of the tree cannot be
resolved (since it's stored in the root_backref). For example I did:

btrfs subvolume create /media/scratch/subvol1 && sync
btrfs inspect-internal dump-tree -t root /dev/vdc

	item 14 key (258 ROOT_ITEM 0) itemoff 12972 itemsize 439
		generation 11 root_dirid 256 bytenr 29949952 level 0 refs 1
		lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x0(none)
		uuid 217fd861-4606-1146-b5ee-59fba8d37f8c
		ctransid 11 otransid 10 stransid 0 rtransid 0
		drop key (0 UNKNOWN.0 0) level 0

	item 15 key (258 ROOT_BACKREF 5) itemoff 12947 itemsize 25
		root backref key dirid 256 sequence 4 name subvol1

Afterwards, I deleted the subvolume:
btrfs subvolume delete -v /media/scratch/subvol1/ && sync

	item 13 key (258 ROOT_ITEM 0) itemoff 12997 itemsize 439
		generation 11 root_dirid 256 bytenr 29949952 level 0 refs 0
		lastsnap 0 byte_limit 0 bytes_used 16384 flags 0x1000000000000(none)
		uuid 217fd861-4606-1146-b5ee-59fba8d37f8c
		ctransid 11 otransid 10 stransid 0 rtransid 0
		drop key (0 UNKNOWN.0 0) level 0



> 
> I guess this entry is some placeholder, like a hidden "trash"
> directory on some filesystems. I don't think this means all Btrfs
> filesystems forever hold on to their last deleted subvolumes (and only
> one).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
