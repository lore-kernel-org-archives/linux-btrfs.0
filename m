Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:8170 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2JOGqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 02:46:12 -0400
Message-ID: <507BB123.7090206@jan-o-sch.net>
Date: Mon, 15 Oct 2012 08:45:55 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: extended inode refs support for send mechanism
References: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net> <CAOcd+r2BXcrKxRZgf2Rx4n61wW2KHXLFoGZwd3AYFTVBni0FWQ@mail.gmail.com>
In-Reply-To: <CAOcd+r2BXcrKxRZgf2Rx4n61wW2KHXLFoGZwd3AYFTVBni0FWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Thu, October 11, 2012 at 13:11 (+0200), Alex Lyakas wrote:
>> @@ -993,12 +1010,17 @@ static int get_inode_path(struct send_ctx *sctx, struct btrfs_root *root,
>>         if (ret < 0)
>>                 goto out;
>>         if (ret) {
>> -               ret = 1;
>> -               goto out;
>> +               key.type = BTRFS_INODE_EXTREF_KEY;
> According to code, btrfs_search_slot_for_read(INODE_REF,
> find_higher=1, return_any=0) returns 1, only in case btrfs_next_leaf()
> returns 1, which means there are no more items at all (or, if you have
> Josef's patch, no more items with the same objectid). Otherwise, it
> may bring us to INODE_EXTREF, but key.type will still be INODE_REF,
> while found_key.type will be INODE_EXTREF. So the test below that
> compares key and found_key will make us return -ENOENT. And in case
> btrfs_search_slot_for_read() returns 1, we don't have to search more,
> I think.
> So shouldn't it be something like:
> ret = btrfs_search_slot_for_read(INODE_REF, find_higher=1, return_any=0)
> if (ret) {
>     ret =1
>     goto out;
> }
> btrfs_item_key_to_cpu(p->nodes[0], &found_key, p->slots[0]);
> if (found_key.objectid != ino || (found_key.type!= INODE_REF &&
> found_key.type != INODE_EXTREF))
> ...

You're right, good catch. I forgot btrfs_search_slot_for_read is actually pretty
different. I'll make a fix.

Thanks!
-Jan
