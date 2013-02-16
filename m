Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24305 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab3BPHzN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 02:55:13 -0500
Date: Sat, 16 Feb 2013 18:55:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hugo Mills <hugo@carfax.org.uk>, Hemanth Kumar <hemanthkumar51@gmail.com>,
        linux-btrfs@vger.kernel.org, skjmca51@gmail.com,
        ganeshkumar14@gmail.com, kirantpatil@gmail.com, praneethu.u@gmail.com,
        chethan.casey@gmail.com, sensille@gmx.net, bo.li.liu@oracle.com,
        sandeen@redhat.com
Subject: Re: [btrfs-progs] testing btrfs hierarchical quotas
Message-ID: <20130216075509.GW26694@dastard>
References: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
 <20130215205906.GI28997@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130215205906.GI28997@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 15, 2013 at 08:59:06PM +0000, Hugo Mills wrote:
>    Hi, Hemanth,
> 
>    Here's a question -- what are you testing? (Not just here, but in
> general, with your test infrastructure)
> 
>    There are (at least) three classes of tests you could be doing:
> 
> 1) Unit tests, which test individual functions within the code and
>    ensure they do what they're meant to do.
> 
> 2) Integration tests, which test the full end-to-end system.
> 
> 3) Partial integration tests, which exercise the kernel
>    filesystem code.
> 
> 4) Partial integration tests, which exercise the userspace tools code.
> 
> 
>    Now, clearly you're not doing (1) here. It's going to be hard to
> separate (2) from (3) and (4), but it's possible to write your tests
> to do more of one or of the other. (*)
> 
>    xfstests clearly is much more geared to (3), and stresses the
> kernel filesystem implementation rather than the userspace tools. If

Definitely not. There are lots of userspace tools tests in xfstests
for stuff like mkfs.xfs, xfs_repair, xfs_dump/restore,
xfs_quota, xfs_metadump/restore, xfs_copy, etc.


> you want to test the implementation of qgroups, it belongs in
> xfstests. If you want to test the userspace code, you need to make
> sure that (over all your tests) you cover every command-line option,
> and every different way of using the tool, and ensure that it does the
> right things.

Yup, that's why there are are so many xfs specific tests. :) e.g.
there are 31 tests that use xfsdump/restore in lots of different
ways, including exercising dumping to tape devices if you have the
hardware...

Another small comment that needs to be pointed out:

> > +cleanup()
> > +{
> > +    btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
> > +    btrfs subvolume delete $TEST_DIR/vol1/vol2
> > +    btrfs subvolume delete $TEST_DIR/vol1
> > +    btrfs subvolume disable $TEST_DIR
> > +}
> > +
> > +#trap "_cleanup ; exit \$status" 0 1 2 3 15

This test is clearly derived from an xfstests test script (status,
the trap, the cleanup function, the tmp variable, use of TEST_DEV
and TEST_DIR, etc), but it clearly isn't a functional test without
the rest of the xfstests harness...

> > +btrfs quota enable $TEST_DIR
> > +echo "quota enabled on $TEST_DEV"
> > +btrfs subvolume create $TEST_DIR/vol1
> > +btrfs subvolume create $TEST_DIR/vol1/vol2
> > +btrfs subvolume create $TEST_DIR/vol1/vol2/vol3
> > +btrfs qgroup limit 5m $TEST_DIR/vol1
> > +btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
> > +btrfs qgroup limit 2m $TEST_DIR/vol1/vol2/vol3
> > +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file1 bs=3M count=1
> > +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file1 bs=2M count=1
> > +dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
> 
>    What happens if one of these commands fails?

The xfstests harness would catch the error message because it
wouldn't match the golden output.

>    You should be testing
> the exit status of almost every command.

No need with xfstests. As I said, the golden output image matching
will catch the error message emitted by the failed comand...

> Then you can fail in one of
> two different ways: a failure of the test (where the thing you were
> trying to test has not succeeded), or a failure of the test harness
> (where the setup functions have gone wrong).

But both can be detected the same way without having to put anything
in the test script to detect it.

>    I'd do this with a setup function to set up the test environment, a
> teardown function to undo it cleanly afterwards, and one or more test
> functions which can be used to run tests.

Which is already provided by xfstests.

> > +cleanup
> > +exit
> 
>    It's the end of the script. You don't need to use exit here.

Copied again from a xfstests test, obviously without understanding
what the commented out trap does. 

$ man bash
.....
	exit [n]
              Cause the shell to exit with a status of n.  If n is
	      omitted, the exit status is that of the last command
	      executed.  A  trap  on  EXIT  is  executed before the
	      shell terminates.
.....

	trap [-lp] [[arg] sigspec ...]
.....
              If a sigspec is EXIT (0) the command arg is executed
	      on exit from the shell.

IOWs, the trap command causes the cleanup function to be called
automatically on exit....

Seriously, guys, just write new tests for xfstests. Everything you
need to run btrfs-progs tests is already there. Don't try to
re-invent the wheel simply because you don't understand how the
current wheels we have are made....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
