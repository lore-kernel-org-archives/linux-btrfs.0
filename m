Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40010 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJRXlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 19:41:46 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Robert White <rwhite@pobox.com>
Subject: Re: strange 3.16.3 problem
Date: Sun, 19 Oct 2014 10:41:41 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <201410181454.19375.russell@coker.com.au> <54426C16.5030206@pobox.com>
In-Reply-To: <54426C16.5030206@pobox.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201410191041.42013.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 19 Oct 2014, Robert White <rwhite@pobox.com> wrote:
> On 10/17/2014 08:54 PM, Russell Coker wrote:
> > # find . -name "*546"
> > ./1412233213.M638209P10546
> > # ls -l ./1412233213.M638209P10546
> > ls: cannot access ./1412233213.M638209P10546: No such file or directory
> > 
> > Any suggestions?
> 
> Does "ls -l *546" show the file to exist? e.g. what happens if you use
> the exact same wildcard in the ls command as you used in the find?

# ls -l *546 
ls: cannot access 1412233213.M638209P10546: No such file or directory

That gives the same result as find, the shell matches the file name but then 
ls can't view it.

lstat64("1412233213.M638209P10546", 0x9fab0c8) = -1 ENOENT (No such file or 
directory)

>From strace, the lstat64 system call fails.
 
> It is possible (and back in the day it was quite common) for files to be
> created with non-renderable nonsense in the name. for instance if the
> first four characters of the name were "13^H4" (where ^H is the single
> backspace character) the file wold look like it was named 14* but it
> would be listed by ls using "13*". If the file name is "damaged", which
> is usually a failing in the program that created the file, then it can
> be "hidden in plain sight".

If that's the case then it's still a kernel bug somewhere.  Maildrop and 
Dovecot don't create files with any unusual characters in the names.

> Note that this sort of name is hidden from the copy-paste done in the
> terminal window because the binary nonsense is just not in the output
> any more by the time you select it with the mouse.
> 
> It doesn't have to be a backspace, BTW, it can be any character that the
> terminal window will not render.
> 
> If things get really ugly you may need to remove the file using
> 
> find . -name "*546" -exec rm "{}" \;

# find . -name "*546" -exec rm "{}" \;
rm: cannot remove `./1412233213.M638209P10546': No such file or directory

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
