Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:42441 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbeDPALj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 20:11:39 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <20180415141338.GA22870@thunk.org>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard> <20180415011735.GB21830@thunk.org>
 <CAHWVdUXAyyeTGNXrtTTc+tUbA3t9TUjJPSF=M4Cetj4+d1w3eQ@mail.gmail.com> <20180415141338.GA22870@thunk.org>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Sun, 15 Apr 2018 19:10:52 -0500
Message-ID: <CAPaz=ELkYavvWYuMg=t+L_nSZ7fZ8CkaZr-qfGVN3QfydbOh7w@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ted,

On Sun, Apr 15, 2018 at 9:13 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Sat, Apr 14, 2018 at 08:35:45PM -0500, Vijaychidambaram Velayudhan Pillai wrote:
>> I was one of the authors on that paper, and I didn't know until today you
>> didn't like that work :) The paper did *not* suggest we support invented
>> guarantees without considering the performance impact.
>
> I hadn't noticed that you were one of the authors on that paper,
> actually.
>
> The problem with that paper was I don't think the researchers had
> talked to anyone who had actually designed production file systems.
> For example, there are some the hypothetical ext3-fast file system
> proposed in the paper has some real practical problems.  You can't
> just switch between having the file contents being journaled via the
> data=journal mode, and file contents being written via the normal page
> cache mechanisms.  If you don't do some very heavy-weight, performance
> killing special measures, data corruption is a very real possibility.

I don't think this is what the paper's ext3-fast does. All the paper
says is if you have a file system where the fsync of a file persisted
only data related to that file, it would increase performance.
ext3-fast is the name given to such a file system. Note that we do not
present a design of ext3-fast or analyze it in any detail. In fact, we
explicitly say "The ext3-fast file system (derived from inferences
provided by ALICE) seems interesting for application safety, though
further investigation is required into the validity of its design."

> I agree that documenting what behavior applications can depend upon is
> useful.  However, this needs to be done as a conversation --- and a
> negotiation --- between application and file system developers.  (And
> not necessarily just from one operating system, either!  Application
> authors might care about whether they can get robustness guarantees on
> other operationg systems, such as Mac OS X.)  Also, the tradeoffs may
> in some cases probabilities of data loss, and not hard guarantees.
>
> Formal documentation also takes a lot of effort to write.  That's
> probably why no one has tried to formally codify it since POSIX.  We
> do have informal agreements, such as adding an implied data flush
> after certain close or renames operations.  And sometimes these are
> written up, but only informally.  A good example of this is the
> O_PONIES controversy, wherein the negotiations/conversation happened
> on various blog entries, and ultimately at an LSF/MM face-to-face
> meeting:
>
>         http://blahg.josefsipek.net/?p=364
>         https://sandeen.net/wordpress/uncategorized/coming-clean-on-o_ponies/
>         https://lwn.net/Articles/322823/
>         https://lwn.net/Articles/327601/
>         https://lwn.net/Articles/351422/
>
> Note that the implied file writebacks after certain renames and closes
> (as documented at the end of https://lwn.net/Articles/322823/) was
> implemented for ext4, and then after discussion at LSF/MM, there was
> general agreement across multiple major file system maintainers that
> we should all provide similar behavior.
>
> So doing this kind of standardization, especially if you want to take
> into account all of the stakeholders, takes time and is not easy.  If
> you only take one point of view, you can have what happened with the C
> standard, where the room was packed with compiler authors, who were
> only interested in what kind of cool compiler optimizations they could
> do, and completely ignored whether the resulting standard would
> actually be useful by practicing system programmers.  Which is why the
> Linux kernel is only really supported on gcc, and then with certain
> optimizations allowed by the C standard explicitly turned off.  (Clang
> support is almost there, but not everyone trust a kernel built by
> Clang won't have some subtle, hard-to-debug problems...)

I definitely agree it takes time and effort. I'm hoping our work on
CrashMonkey can help here, by codifying the crash-consistency
guarantees into tests that new file-system developers can use.

>
> Academics could very well have a place in helping to facilitate the
> conversation.  I think my primary concern with the Pillai paper is
> that the authors apparently talked a whole bunch to application
> authors, but not nearly as much to file system developers.

I agree with this criticism. This is why my research group engages
with the file-system community right from project start, as we have
been doing with CrashMonkey.

>> But in any case, coming back to our main question, the conclusion seems to
>> be: symlinks aren't standard, so we shouldn't be studying their
>> crash-consistency properties. This is useful to know. Thanks!
>
> Well, symlinks are standardized.  But what the standards say about
> them is extremely limited.  And the crash-consistency properties you
> were looking at, which is what fsync() being called on a file
> descriptor opened via a symlink, is definitely not consistent with
> either the Posix/SUS standard, or historical practice by BSD and other
> Unix systems, as well as Linux.

Thanks! As I mentioned before, this is useful. I have a follow-up
question. Consider the following workload:

 creat foo
 link (foo, A/bar)
 fsync(foo)
 crash

In this case, after the file system recovers, do we expect foo's link
count to be 2 or 1? I would say 2, but POSIX is silent on this, so
thought I would confirm. The tricky part here is we are not calling
fsync() on directory A.

In this case, its not a symlink; its a hard link, so I would say the
link count for foo should be 2. But btrfs and F2FS show link count of
1 after a crash.

Thanks,
Vijay Chidambaram
http://www.cs.utexas.edu/~vijay/
