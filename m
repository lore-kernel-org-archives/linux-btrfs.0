Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58546 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdBELzI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 06:55:08 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1caLPI-0007zS-Fg
        for linux-btrfs@vger.kernel.org; Sun, 05 Feb 2017 12:55:00 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Sun, 5 Feb 2017 12:54:58 +0100
Message-ID: <20170205125458.252c68df@jupiter.sol.kaishome.de>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 1 Feb 2017 17:43:32 +0000
schrieb Graham Cobb <g.btrfs@cobb.uk.net>:

> On 01/02/17 12:28, Austin S. Hemmelgarn wrote:
> > On 2017-02-01 00:09, Duncan wrote:  
> >> Christian Lupien posted on Tue, 31 Jan 2017 18:32:58 -0500 as
> >> excerpted: 
>  [...]  
> >>
> >> I'm just a btrfs-using list regular not a dev, but AFAIK, the
> >> behavior is likely to be by design and difficult to change,
> >> because the send stream is simply a stream of userspace-context
> >> commands for receive to act upon, and any other suitably
> >> privileged userspace program could run the same commands.  (If
> >> your btrfs-progs is new enough receive even has a dump option,
> >> that prints the metadata operations in human readable form, one
> >> operation per line.)
> >>
> >> So making the receive snapshot read-only during the transfer would
> >> prevent receive itself working.  
> > That's correct.  Fixing this completely would require implementing
> > receive on the kernel side, which is not a practical option for
> > multiple reasons.  
> 
> I am with Christian on this. Both the effects he discovered go against
> my expectation of how send/receive would or should work.
> 
> This first bug is more serious because it appears to allow a
> non-privileged user to disrupt the correct operation of receive,
> creating a form of denial-of-service of a send/receive based backup
> process. If I decided that I didn't want my pron collection (or my
> incriminating emails) appearing in the backups I could just make sure
> that I removed them from the receive snapshots while they were still
> writeable.
> 
> You may be right that fixing this would require receive in the kernel,
> and that is undesirable, although it seems to me that it should be
> possible to do something like allow receive to create the snapshot
> with a special flag that would cause the kernel to treat it as
> read-only to any requests not delivered through the same file
> descriptor, or something like that (or, if that can't be done, at
> least require root access to make any changes). In any case, I
> believe it should be treated as a bug, even if low priority, with an
> explicit warning about the possible corruption of receive-based
> backups in the btrfs-receive man page.

How about mounting the receiver below a directory only traversable by
root (chmod og-rwx)? Backups shouldn't be directly accessible by
ordinary users anyway.

If you want a backup becoming accessible, you can later snapshot it to
an accessible location after send/receive finished without errors.

An in-transit backup, however, should always be protected from possible
disruptive access. This is an issue with any backup software. So place
the receive within an inaccessible directory. This is not something the
backup process should directly bother with for simplicity.


-- 
Regards,
Kai

Replies to list-only preferred.

