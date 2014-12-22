Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56335 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaLVO6A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 09:58:00 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so8248816wiw.14
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 06:57:59 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 22 Dec 2014 16:57:59 +0200
Message-ID: <CAOcd+r2_CkP7wiU3OETxhdVtkTpZYiz0GxSx7BDEsFU6H+0_RQ@mail.gmail.com>
Subject: How btrfs-find-root knows that the block is actually a root?
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

I am looking at the code of search_iobuf() in
btrfs-find-root.c.(3.17.3)  I see that we probe nodesize blocks one by
one, and for each block we check:
- its owner is what we are looking for
- its header->bytenr is what we are looking at currently
- its level is not too small
- it has valid checksum
- it has the desired generation

If all those conditions are true, we declare this block as a root and
end the program.

How do we actually know that it's a root and not a leaf or an
intermediate node? What if we are searching for a root of the root
tree, which has one node and two leafs (all have the same highest
transid), and one of the leafs has "logical" lower than the actual
root, i.e., it comes first in our scan. Then we will declare this leaf
as a root, won't we? Or somehow the root always has the lowest
"logical"?

Also, I am confused by this line:
level = h_level;
This means that if we encounter a block that "seems good", we will
skip all other blocks that have lower level. Is this intended?

Thanks,
Alex.
