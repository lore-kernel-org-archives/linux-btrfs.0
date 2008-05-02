From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 08:38:12 -0600
Message-ID: <20080502143811.GC14976@parisc-linux.org>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
	Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	John Johansen <jjohansen@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200805021034.08358.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 02, 2008 at 10:34:07AM -0400, Chris Mason wrote:
> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
> the kernel has the patch.  Lets go back to Jeff's suse patch:

Do we really need to support kernels compiled with the apparmour patch
applied but not enabled?  That would be a custom kernel build, and I get
the impression that people Just Don't Do That -- if they want a newer
kernel, they fetch one from kernel.org.  Maybe I'm wrong though.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
