Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57120 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932209AbcJQRlr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:41:47 -0400
Subject: Re: What are "parent" and "parent_uuid" in "btrfs sub list"?
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <e39fb389-7ce1-2913-941b-aefa05a26fd1@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <bd57de97-1611-0628-10f0-9d6f358aacce@mendix.com>
Date: Mon, 17 Oct 2016 19:41:42 +0200
MIME-Version: 1.0
In-Reply-To: <e39fb389-7ce1-2913-941b-aefa05a26fd1@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2016 06:53 PM, Andrei Borzenkov wrote:
> I try to understand how to build a tree of snapshots (i.e. - which
> subvolume was used to snapshot/clone other subvolume). What is the
> correct way to determine it? In particular, "btrfs sub list -p" always
> prints something for "parent snapshot", while btrfs sub list -q" only
> prints parent_uuid for actual snapshots (i.e. for subvolumes I know are
> snapshots). Are "parent" and "parent_uuid" related to each other? Of
> not, what do they mean?

It's confusing because there are two different things, which both are
called a parent.

* parent is the subvolume another subvolume is placed in
* parent_uuid is the uuid of a subvolume that this is a snapshot from

So:

-# btrfs sub create foo
Create subvolume './foo'
-# btrfs sub list -p -q .
ID 3486 gen 3368 parent 5 top level 5 parent_uuid - path foo

foo has parent 5, because I created it at the top of the filesystem, and
the top level subvolume (the fs itself) has id 5

-# btrfs sub create bar
Create subvolume './bar'
-# btrfs sub list -p -q .
ID 3486 gen 3368 parent 5 top level 5 parent_uuid - path foo
ID 3487 gen 3369 parent 5 top level 5 parent_uuid - path bar

now I have a second one...

-# mv foo bar/
-# btrfs sub list -p -q .
ID 3486 gen 3368 parent 3487 top level 3487 parent_uuid - path bar/foo
ID 3487 gen 3369 parent 5 top level 5 parent_uuid - path bar

if I move the foo subvolume *into* the bar subvolume, it gets the bar as
parent

-# btrfs sub snap -r bar bar-snap
Create a readonly snapshot of 'bar' in './bar-snap'
-# btrfs sub list -p -q .
ID 3486 gen 3368 parent 3487 top level 3487 parent_uuid - path bar/foo
ID 3487 gen 3370 parent 5 top level 5 parent_uuid - path bar
ID 3488 gen 3370 parent 5 top level 5 parent_uuid
8de7ab74-4654-e542-a29b-169848ee73b3 path bar-snap

and there's the parent_uuid...

-- 
Hans van Kranenburg
