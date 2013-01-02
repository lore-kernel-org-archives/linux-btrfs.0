Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:49574 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3ABU5r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jan 2013 15:57:47 -0500
Date: Wed, 2 Jan 2013 20:56:55 +0000
From: Jun Lion <junlion@tormail.org>
To: linux-btrfs@vger.kernel.org
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: Incremental btrfs receive in opposite direction fails
References: <1ToibV-0001fD-SN@internal.tormail.org>
 <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com>
 <1TpCWu-000Fz2-6t@internal.tormail.org>
 <50E466FC.1070802@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E466FC.1070802@jan-o-sch.net>
Message-Id: <1TqVL0-000FG6-IV@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> I admit I haven't completely understood what you're trying to achieve. You can
> only receive an incremental stream if the internal (!) file system state on the
> receiver's side is the same as on the sender's.

Understood, and the internal states are identical, except for the
snapshot metadata.

This executable example that shows the problem:


    # Create two throwaway filesystems /tmp/img1 and /tmp/img2
    # and mount them at /tmp/mp1 and /tmp/mp2
    for i in 1 2; do
        truncate -s 1G /tmp/img$i
        loop=`losetup -f --show /tmp/img$i`
        mkfs.btrfs "$loop"
        losetup -d "$loop"
        mkdir /tmp/mp$i
        mount /tmp/img$i /tmp/mp$i
    done

    # Create a subvol on the first fs, populate it
    btrfs sub create /tmp/mp1/foo
    echo 1 >/tmp/mp1/foo/1

    # Make an ro snapshot of the subvol, transfer it to the 2nd fs
    btrfs sub snap -r /tmp/mp1/foo /tmp/mp1/foo.1
    btrfs send /tmp/mp1/foo.1 | btrfs receive -v /tmp/mp2

    # Make an rw snapshot of the transferred snapshot on the 2nd fs,
    # add something to this rw snapshot
    btrfs sub snap /tmp/mp2/foo.1 /tmp/mp2/foo
    echo 2 >/tmp/mp2/foo/2

    # Make an ro snapshot of the added-to snapshot
    btrfs sub snap -r /tmp/mp2/foo /tmp/mp2/foo.2

    # Now try to transfer it back in the other direction
    btrfs send -p /tmp/mp2/foo.1 /tmp/mp2/foo.2 |
    btrfs receive -v /tmp/mp1
    # "ERROR: could not find parent subvolume"
    # even though both fs have the same foo.1


As I understand it, if "clone" is a clone/parent source, btrfs send
transmits
    clone.uuid
    clone.ctransid
and btrfs receive searches for a subvol "sub" with
    sub.received_uuid == clone.uuid and sub.stransid == clone.ctransid.

But because the direction of the transfer has changed, it can't find
anything. It would work if btrfs send was modified to *additionally*
transmit
    clone.received_uuid
    clone.stransid
and btrfs receive to do a *fallback* search for a subvol with
    sub.uuid == clone.received_uuid and sub.ctransid == clone.stransid

However, since I'm really not familiar with btrfs code, it was easier
for me to just make a rw snapshot of mp1/foo.1 and modify its metadata:

    # can't modify the info about a ro snapshot
    btrfs sub snap /tmp/mp1/foo.1 /tmp/mp1/foo.1rw

    # mp1/foo.1rw.received_uuid := mp2/foo.1.uuid
    # mp1/foo.1rw.stransid      := mp2/foo.1.ctransid
    uu /tmp/mp2 foo.1 /tmp/mp1/foo.1rw

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !! Now we've made it look as if mp1/foo.1 was received from !!
    # !! mp2/foo.1 when actually it was the other way around.     !!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    # Let's retry the original problematic command:
    btrfs send -p /tmp/mp2/foo.1 /tmp/mp2/foo.2 |
    btrfs receive -v /tmp/mp1

    # It works fine! Hurray!
