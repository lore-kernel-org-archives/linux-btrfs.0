Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43526 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752464AbeDOUxb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 16:53:31 -0400
Date: Sun, 15 Apr 2018 10:13:38 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Cc: Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Symlink not persisted even after fsync
Message-ID: <20180415141338.GA22870@thunk.org>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard>
 <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard>
 <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 14, 2018 at 08:35:45PM -0500, Vijaychidambaram Velayudhan Pillai wrote:
> I was one of the authors on that paper, and I didn't know until today you
> didn't like that work :) The paper did *not* suggest we support invented
> guarantees without considering the performance impact.

I hadn't noticed that you were one of the authors on that paper,
actually.

The problem with that paper was I don't think the researchers had
talked to anyone who had actually designed production file systems.
For example, there are some the hypothetical ext3-fast file system
proposed in the paper has some real practical problems.  You can't
just switch between having the file contents being journaled via the
data=journal mode, and file contents being written via the normal page
cache mechanisms.  If you don't do some very heavy-weight, performance
killing special measures, data corruption is a very real possibility.

(If you're curious as to why, see the comments in the function
ext4_change_journal_flag() in fs/ext4/inode.c, which is called when
clearing the per-file data journal flag.  We need to stop the journal,
write all dirty, journalled buffers to disk, empty the journal, and
only then can we switch a file from using data journalling to the
normal ordered data mode handling.  Now imagine ext3-fast needing to
do all of this...)

The paper also talked in terms of what file system designers should
consider; it didn't really make the same recommendation to application
authors.  If you look at Table 3(c), which listed application
"vulnerabilities" under current file systems, for the applications
that do purport to provide robustness against crashes (e.g., Postgres,
LMDB, etc.) , most of them actually work quite well, with little or
vulerabilities.  A notable example is Zookeeper --- but that might be
an example where the application is just buggy, and should be fixed.

> I don't disagree with any of this. But you can imagine how this can be all
> be confusing to file-system developers and research groups who work on file
> systems: without formal documentation, what exactly should they test or
> support? Clearly current file systems provide more than just POSIX and
> therefore POSIX itself is not very useful.

I agree that documenting what behavior applications can depend upon is
useful.  However, this needs to be done as a conversation --- and a
negotiation --- between application and file system developers.  (And
not necessarily just from one operating system, either!  Application
authors might care about whether they can get robustness guarantees on
other operationg systems, such as Mac OS X.)  Also, the tradeoffs may
in some cases probabilities of data loss, and not hard guarantees.

Formal documentation also takes a lot of effort to write.  That's
probably why no one has tried to formally codify it since POSIX.  We
do have informal agreements, such as adding an implied data flush
after certain close or renames operations.  And sometimes these are
written up, but only informally.  A good example of this is the
O_PONIES controversy, wherein the negotiations/conversation happened
on various blog entries, and ultimately at an LSF/MM face-to-face
meeting:

	http://blahg.josefsipek.net/?p=364
	https://sandeen.net/wordpress/uncategorized/coming-clean-on-o_ponies/	
	https://lwn.net/Articles/322823/
	https://lwn.net/Articles/327601/
	https://lwn.net/Articles/351422/

Note that the implied file writebacks after certain renames and closes
(as documented at the end of https://lwn.net/Articles/322823/) was
implemented for ext4, and then after discussion at LSF/MM, there was
general agreement across multiple major file system maintainers that
we should all provide similar behavior.

So doing this kind of standardization, especially if you want to take
into account all of the stakeholders, takes time and is not easy.  If
you only take one point of view, you can have what happened with the C
standard, where the room was packed with compiler authors, who were
only interested in what kind of cool compiler optimizations they could
do, and completely ignored whether the resulting standard would
actually be useful by practicing system programmers.  Which is why the
Linux kernel is only really supported on gcc, and then with certain
optimizations allowed by the C standard explicitly turned off.  (Clang
support is almost there, but not everyone trust a kernel built by
Clang won't have some subtle, hard-to-debug problems...)

Academics could very well have a place in helping to facilitate the
conversation.  I think my primary concern with the Pillai paper is
that the authors apparently talked a whole bunch to application
authors, but not nearly as much to file system developers.

> But in any case, coming back to our main question, the conclusion seems to
> be: symlinks aren't standard, so we shouldn't be studying their
> crash-consistency properties. This is useful to know. Thanks!

Well, symlinks are standardized.  But what the standards say about
them is extremely limited.  And the crash-consistency properties you
were looking at, which is what fsync() being called on a file
descriptor opened via a symlink, is definitely not consistent with
either the Posix/SUS standard, or historical practice by BSD and other
Unix systems, as well as Linux.

Cheers,

					- Ted
