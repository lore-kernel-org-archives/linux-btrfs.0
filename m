From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 16:58:00 -0400
Message-ID: <200805021658.01459.chris.mason@oracle.com>
References: <200804291601.32945.chris.mason@oracle.com> <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
	Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	John Johansen <jjohansen@suse.de>
To: Tim Gardner <timg@tpi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <481B3C0E.502@tpi.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 02 May 2008, Tim Gardner wrote:
> Chris Mason wrote:
> > On Friday 02 May 2008, Jeff Schroeder wrote:
> >
> > [ Btrfs oops with apparmor patched in ]
> >
> >> Make is not my forte, but here is a working test to see if apparmor
> >> exists in Ubuntu 8.04.
> >> Maybe have make apply a patch to the btrfs source if this test
> >> succeeds? Does this work in SUSE?
> >>
> >> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_t
> >>est _for_btrfs.patch
> >
> > Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell
> > if the kernel has the patch.  Lets go back to Jeff's suse patch:
> >

I ended up using the CONFIG_SECURITY_APPARMOR test because the other test 
suggested here sounded like something that might eventually not be very 
ubuntu specific (instead of the nice a plain CONFIG_SUSE_KERNEL).

Thanks to everyone for the hints, if someone could please test:

http://btrfs.wiki.kernel.org/index.php/Hot_Fixes

I'd be grateful.

-chris
