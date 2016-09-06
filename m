Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:37229 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933502AbcIFRUd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 13:20:33 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 66B499B98A
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Sep 2016 18:20:28 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 3EC575FB5B
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Sep 2016 18:20:28 +0100 (BST)
Subject: Re: Security implications of btrfs receive?
To: linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
Date: Tue, 6 Sep 2016 18:20:27 +0100
MIME-Version: 1.0
In-Reply-To: <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to Austin and Duncan for their replies.

On 06/09/16 13:15, Austin S. Hemmelgarn wrote:
> On 2016-09-05 05:59, Graham Cobb wrote:
>> Does the "path" argument of btrfs-receive mean that *all* operations are
>> confined to that path?  For example, if a UUID or transid is sent which
>> refers to an entity outside the path will that other entity be affected
>> or used?
> As far as I know, no, it won't be affected.
>> Is it possible for a file to be created containing shared
>> extents from outside the path?
> As far as I know, the only way for this to happen is if you're
> referencing a parent subvolume for a relative send that is itself
> sharing extents outside of the path.  From a practical perspective,
> unless you're doing deduplication on the receiving end, the this
> shouldn't be possible.

Unfortunately that is not the case.  I decided to do some tests to see
what happens.  It is possible for a receive into one path to reference
and access a subvolume from a different path on the same btrfs disk.  I
have created a bash script to demonstrate this at:

https://gist.github.com/GrahamCobb/c7964138057e4e092a75319c9fb240a3

This does require the attacker to know the (source) subvolume UUID they
want to copy.  I am not sure how hard UUIDs are to guess.

By the way, this is exactly the same whether or not the --chroot option
is specified on the "btrfs receive" command.

The next question this raises for me is whether this means that
processes in a chroot or in a container (or in a mandatory access
controls environment) can access files outside the chroot/container if
they know the UUID of the subvolume?  After all, btrfs-receive uses
IOCTLs that any program running as root can use.

Graham
