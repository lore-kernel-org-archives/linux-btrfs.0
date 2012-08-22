Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40896 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab2HVOhQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 10:37:16 -0400
Date: Wed, 22 Aug 2012 16:37:06 +0200
From: David Sterba <dave@jikos.cz>
To: Not Zippy <notzippy@gmail.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: Computer crash, btrfs partition errors
Message-ID: <20120822143705.GR17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
 <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
 <20120821160019.GN17430@twin.jikos.cz>
 <CANDob0LpwsWP=jcyMkxZor0_6AnFeHY6zt-Sp6V0HH+Pd2SH=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANDob0LpwsWP=jcyMkxZor0_6AnFeHY6zt-Sp6V0HH+Pd2SH=w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2012 at 09:50:58AM -0700, Not Zippy wrote:
> Thanks for the analysis, unfortunately I get the same assert error
> when I attempt to run the repair from the compiled source.
> 
> # ./work/builds/btrfs-progs/btrfsck
> usage: btrfsck dev
> Btrfs Btrfs v0.19

'git describe' would be more helpful, but as the following command
succeded, I assume that you're on the right version.

> # ./work/builds/btrfs-progs/btrfsck --repair /dev/sda2
> enabling repair mode
> checking extents
> leaf parent key incorrect 46329503744
> bad block 46329503744
> owner ref check failed [46329503744 4096]
> repair deleting extent record: key 46329503744 168 4096
> adding new tree backref on start 46329503744 len 4096 parent 256 root 256
> repaired damaged extent references

so it's able to fix that error, but due to failure in the next phase the
change is not permanent -- a quick hack here would be to commit
immediatelly after this phase

--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3572,6 +3572,8 @@ int main(int ac, char **av)
        if (ret)
                fprintf(stderr, "Errors found in extent allocation tree\n");

+       goto out;
+
        fprintf(stderr, "checking fs roots\n");
        ret = check_fs_roots(root, &root_cache);
        if (ret)
---

> checking fs roots
> btrfsck: btrfsck.c:397: process_inode_item: Assertion `!(rec->ino !=
> key->objectid || rec->refs > 1)' failed.
> Aborted

This would need more information to analyze further, like full output of
btrfs-debug-tree, and capture actual values from the Assertion to match
them against the output. Additionally, I'm still interested in details
about conditions that lead to this corruption, it's less painful to
reproduce it locally than the remote debugging ping-pong (though
sometimes nothing else is available).
I think it'd be interesting to dig deeper, but you were able to get to
your data so it's not probably that urgent for both of us.


david
