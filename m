Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35447 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbcGCVa0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jul 2016 17:30:26 -0400
Date: Sun, 3 Jul 2016 23:30:20 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag questions
Message-ID: <20160703213020.GA23178@angband.pl>
References: <5776CF08.5040601@mail.ru>
 <20160703123341.7c297efa@jupiter.sol.kaishome.de>
 <CAPmG0jZ3RMuDX-fzK7WyuNH+NeSyZw8zhWerTo7ve-CgTADSPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPmG0jZ3RMuDX-fzK7WyuNH+NeSyZw8zhWerTo7ve-CgTADSPw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 03, 2016 at 04:15:02PM +0200, Henk Slager wrote:
> >> Provided that Dropbox is running in the system, does it mean that it
> >> cannot be defagmented?
> >
> > That is probably true. Files that are mapped into memory (like running
> > executables) cannot be changed on disk. You could make a copy of that
> > file, remove the original, and rename the new into place. As long as
> > the executable is running it will stay on disk but you can now
> > defragment the file and next time dropbox is started it will use the
> > new one.
> 
> I get:
> ERROR: cannot open ./dropbox: Text file busy
> 
> when I run:
> btrfs fi defrag -v ./dropbox
> 
> This is with kernel 4.6.2 and progs 4.6.1, dropbox running and mount
> option compress=lzo

This is the same thing as with dedupe: the kernel requires you to have the
file opened for writing despite there being no direct reasons for this.
Defragging is not a write operation in POSIX sense: it doesn't alter the
file's contents in any way.

I think it'd be good to relax this requirement to check whether the user
_could_ open the file for writing (ie, cap or w permissions).

-- 
An imaginary friend squared is a real enemy.
