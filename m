From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 10:52:43 -0400
Message-ID: <200805021052.44076.chris.mason@oracle.com>
References: <200804291601.32945.chris.mason@oracle.com> <200805021034.08358.chris.mason@oracle.com> <20080502143811.GC14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
	Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	John Johansen <jjohansen@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080502143811.GC14976@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 02 May 2008, Matthew Wilcox wrote:
> On Fri, May 02, 2008 at 10:34:07AM -0400, Chris Mason wrote:
> > Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell
> > if the kernel has the patch.  Lets go back to Jeff's suse patch:
>
> Do we really need to support kernels compiled with the apparmour patch
> applied but not enabled?  That would be a custom kernel build, and I get
> the impression that people Just Don't Do That -- if they want a newer
> kernel, they fetch one from kernel.org.  Maybe I'm wrong though.

Yeah, if there's no better test I'll just use the one for the apparmor config 
(and stop spamming l-k with this btrfs specific stuff).

-chris


