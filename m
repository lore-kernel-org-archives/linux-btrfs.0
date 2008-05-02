From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 10:34:07 -0400
Message-ID: <200805021034.08358.chris.mason@oracle.com>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Jeff Mahoney" <jeffm@suse.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	"John Johansen" <jjohansen@suse.de>
To: jeffschroeder@computer.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 02 May 2008, Jeff Schroeder wrote:

[ Btrfs oops with apparmor patched in ]

> Make is not my forte, but here is a working test to see if apparmor
> exists in Ubuntu 8.04.
> Maybe have make apply a patch to the btrfs source if this test
> succeeds? Does this work in SUSE?
>
> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test
>_for_btrfs.patch
>

Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
the kernel has the patch.  Lets go back to Jeff's suse patch:

/*
 * Even if AppArmor isn't enabled, it still has different prototypes.
 * Add more distro/version pairs here to declare which has AppArmor applied.
 */
#if defined(CONFIG_SUSE_KERNEL)
# if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
# define REMOVE_SUID_PATH 1
# endif
#endif

Could someone from Ubuntu please suggest a replacement for CONFIG_SUSE_KERNEL 
and KERNEL_VERSION(2,6,22) that would correspond with ubuntu kernels shipped 
with apparmor?  We don't need some define from the apparmor patch, just a 
global flag that says it comes from ubuntu is enough.

-chris
