Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52927 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2HUPgd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 11:36:33 -0400
Date: Tue, 21 Aug 2012 17:36:18 +0200
From: David Sterba <dave@jikos.cz>
To: C Anthony Risinger <anthony@xtfx.me>
Cc: dg1727 <dg1727@hushmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to get Btrfs on 2nd partition of USB HDD to automount as
 read/write
Message-ID: <20120821153618.GM17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120819195147.6EA7EA6E3F@smtp.hushmail.com>
 <CAGAVQTEvYtgzPP9rjt=rnYi9yNpMRXjj86TzG-kiUio7uOMPHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGAVQTEvYtgzPP9rjt=rnYi9yNpMRXjj86TzG-kiUio7uOMPHA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 19, 2012 at 03:05:11PM -0500, C Anthony Risinger wrote:
> On Sun, Aug 19, 2012 at 2:51 PM, dg1727 <dg1727@hushmail.com> wrote:
> > permissions of the directories in /dev are drwx------ for the NTFS
> > and dr-xr-xr-x for the Btrfs.
> >
> > How can the OS be set up so that the Btrfs will automount
> > read/write?
> 
> try:
> 
> chmod u+w /path/to/btrfs/mount
> 
> ... for whatever reason mkfs.btrfs created new subvolumes (but not
> snapshots!) with 555 perms, which essentially says "writable to nobody
> at all" ... IIRC, this was changed within the last year or so.

The issue with subvols pemr 0700 was indeed fixed, on the kernel side.

The problem with missing 'w' (ie mode 555) on a freshly mkfs'ed image is
still present and it's the user-space tools (mkfs) proble. Patch has
been sent some time ago

http://www.spinics.net/lists/linux-btrfs/msg17909.html

The workaround is to chmod as you suggested and is permanent once done.


david
