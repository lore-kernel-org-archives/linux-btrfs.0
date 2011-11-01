From: Chris Mason <chris.mason@oracle.com>
Subject: new integration-danger branch pushed out (kernel)
Date: Mon, 31 Oct 2011 22:49:57 -0400
Message-ID: <20111101024957.GH4468@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pushed out a new integration branch, but it is not for general use.

I'm still going through and hammering on the new logging code code to
make sure it is properly backwards compatible with older kernels and
that it hasn't introduced any new bugs.

*** Please do not use this code on anything other than test filesystems that
can easily be reformatted. ***

In testing the new sub-transid logging code, I've spent a lot of time
hunting logging bugs, and writing new tests to try and make sure the
logging code is working correctly in general.  Between that and some new
tests from Arne, I've had to make some pretty big changes to the code.

This meant collapsing Fujitsu's original nicely broken out patches into
a larger patch so that I could be sure later kernel bisections wouldn't
run into problems.  All credit to Liu Bo and Fujitsu for getting the
sub-transid work going, any bugs in the pushed patch are probably ones
I introduced.

integration-danger merges in the new sub-transid logging code along with
all of the fixes Dave Sterba has been tracking, and Josef's code.

I'm still merging in trees from Arne and Jan Schmidt, those should get
pushed out tomorrow afternoon.

-chris

