Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40104 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbaHAMWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 08:22:00 -0400
Date: Fri, 1 Aug 2014 08:21:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hugo Mills <hugo@carfax.org.uk>, Nicholas Krause <xerofoify@gmail.com>,
        clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support to check for FALLOC_FL_COLLAPSE_RANGE  and
 FALLOC_FL_ZERO_RANGE crap modes
Message-ID: <20140801122154.GA15110@thunk.org>
References: <1406829213-4759-1-git-send-email-xerofoify@gmail.com>
 <20140731190910.GP31950@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140731190910.GP31950@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 31, 2014 at 08:09:10PM +0100, Hugo Mills wrote:
> On Thu, Jul 31, 2014 at 01:53:33PM -0400, Nicholas Krause wrote:
> > This adds checks for the stated modes as if they are crap we will return error
> > not supported.
> 
>    You've just enabled two options, but you haven't actually
> implemented the code behind it. I would tell you *NOT* to do anything
> else on this work until you can answer the question: What happens if
> you apply this patch, create a large file called "foo.txt", and then a
> userspace program executes the following code?
> 
> int fd = open("foo.txt", O_RDWR);
> fallocate(fd, FALLOCATE_FL_COLLAPSE_RANGE, 50, 50);
> 
>    Try it on a btrfs filesystem, both with and without your patch.
> Also try it on an ext4 filesystem.
> 
>    Once you've done all of that, reply to this mail and tell me what
> the problem is with this patch. You need to make two answers: what are
> the technical problems with the patch? What errors have you made in
> the development process?

There are also the conceptual failures.  Before you do anything else,
you need to be able to answer the question, "what do you think the
flags FALLOC_FL_COLLAPSE_RANGE and FALLOC_FL_ZERO_RANGE are supposed
to do?"  What are the possible appropriate things for btrfs to do if
it sees these flags?  (Hint: there is more than one correct answer,
and its current choice is one of them.  What is the other one?)

Nick, the fact that you call these modes "crap" is a hint that you
have a fundamental lack of understanding --- and before you waste more
of kernel developers' time, you need to get that understanding first,
for any bit of code that you propose to "improve".

This is why I suggested that you work on userspace testing scripts
first.  It's pretty clear you are (a) incredibly sloppy, and (b)
lacking conceptual understanding of a lot of technical details, and
(c) even worse, aren't letting this lack of understanding stop you
from posting patches.  As a result you are adding negative value to
whatever project or subsystem you try to attach yourself to --- you're
not helping.

						- Ted

P.S.   As a further hint, change the above code to read:

	int fd = open("foo.txt", O_RDWR);
	if (fallocate(fd, FALLOCATE_FL_COLLAPSE_RANGE, 4096, 8192) < 0)
		perror("fallocate");

And then run "filefrag -vs foo.txt" before and after running the above
code fragment and then try something like this:

     cp /usr/share/dict/words foo.txt
     filefrag -vs foo.txt
     ls -l foo.txt
     /tmp/fallocate-test-prog
     filefrag -vs foo.txt
     ls -l foo.txt
     diff /usr/share/dict/words foo.txt

Try doing this on an ext4 or xfs system and a btrfs file system.
