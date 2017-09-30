Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:40942 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdI3QhR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 12:37:17 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 633429BAA0
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 17:37:12 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 306DC5FBB1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 17:37:12 +0100 (BST)
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <264aa617-9484-a5fe-ad47-8ed052d6764e@cobb.uk.net>
Date: Sat, 30 Sep 2017 17:37:11 +0100
MIME-Version: 1.0
In-Reply-To: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/09/17 14:08, Holger Hoffstätte wrote:
> A "root" subvolume is identified by a null parent UUID, so adding a new
> subvolume filter and flag -P ("Parent") does the trick. 

I don't like the naming. The flag you are proposing is really nothing to
do with whether a subvolume is a parent or not: it is about whether it
is a snapshot or not (many subvolumes are both snapshots and also
parents of other snapshots, and many non-snapshots are not the parent of
any subvolumes).

I have two suggestions:

1) Use -S (meaning "not a snapshot", the inverse of -s). Along with this
change. I would change the usage text to say something like:

 -s list subvolumes originally created as snapshots
 -S list subvolumes originally created not as snapshots

Presumably specifying both -s and -S should be an error.

2) Add a -P (parent) option but make it take an argument: the UUID of
the parent to match. This would display only subvolumes originally
created as snapshots of the specified subvolume (which may or may not
still exist, of course). A null value ('' -- or a special text like
'NULL' or 'NONE' if you prefer) would create the search you were looking
for: subvolumes with a null Parent UUID.

The second option is more code, of course, but I see being able to list
all the snapshots of a particular subvolume as quite useful.

If you do choose the second option you need to decide what to do if the
-P is specified more than once. Probably treat it as an error (unless
you want to allow a list of UUIDs any of which can match). You might
also want to reject an attempt to specify both -s and -P.

Graham
