Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36473 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaG3ONd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 10:13:33 -0400
Date: Wed, 30 Jul 2014 10:13:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hugo Mills <hugo@carfax.org.uk>, Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
Message-ID: <20140730141329.GC20353@thunk.org>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
 <20140730093821.GJ31950@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140730093821.GJ31950@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 10:38:21AM +0100, Hugo Mills wrote:
> qemu/kvm is good for this, because it has a mode
> that bypasses the BIOS and bootloader emulation, and just directly
> runs a kernel from a file on the host machine. This is fast. You can
> pass large sparse files to the VM to act as scratch disks, plus keep
> another smaller file for the guest OS (and a copy of it so that you
> can throw one away and make another one quickly and easily).

Nick,

The xfstests-bld/kvm-xfstests git tree I pointed out to you has an
example of a test infrastructure which does this for ext4.  It's been
on my todo list to support other file systems, and I have some plans
for how to do thi, but it's been low on my priority list.  If someone
in the btrfs development community is interested in working with me on
this, they should contact me.

Or the btrfs developers can create their own automated systems which
then gets promulgated, but either way, it's something that I strongly
recommend.  The set of test configs that ext4 developers would run
significantly increased after I cleaned up my test scripts and made it
something that other people could use, and it means that I can ask
people who are implementing new features that they run a complete
regression test run, with many different file systems features enabled
and disabled, so they find the problems before they propose a patch
for merging.

Cheers,

					- Ted


