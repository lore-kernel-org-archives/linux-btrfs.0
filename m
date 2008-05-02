From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 11:14:56 -0700
Message-ID: <c24352ca0805021114u4c4cdf56leced2d6c23ae2bd4@mail.gmail.com>
References: <200804291601.32945.chris.mason@oracle.com>
	 <200805020852.51125.chris.mason@oracle.com>
	 <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
	 <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com>
	 <481B409A.2070607@suse.com>
	 <alpine.LNX.1.10.0805021959150.6463@fbirervta.pbzchgretzou.qr>
	 <481B56FD.9020807@suse.com>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Tim Gardner" <timg@tpi.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-btrfs@vger.kernel.org, "John Johansen" <jjohansen@suse.de>
To: "Jeff Mahoney" <jeffm@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <481B56FD.9020807@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 2, 2008 at 11:01 AM, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
>  Hash: SHA1
>
>
>
> Jan Engelhardt wrote:
>  > On Friday 2008-05-02 18:26, Jeff Mahoney wrote:
>  >>> To the best of my knowledge, the AppArmor patches are arch and flavour
>  >>> independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
>  >>> compiled. This is certainly the case for Hardy. Neither Kees or myself
>  >>> are aware of any reason why it won't also hold true for Intrepid.
>  >> Grumble. The issue isn't whether AA is enabled, it's whether it's
>  >> present in the source. Patching the source with AA modifies a bunch of
>  >> core VFS function prototypes. CONFIG_SECURITY_APPARMOR won't exist if AA
>  >> isn't enabled, but the prototypes will have changed anyway.
>  >
>  > So... add an invisible CONFIG_HAVE_APPARMOR, much like
>  > CONFIG_X86_HAVE_CMPXCHG (or whatever it's called), and test for that.
>  > As long as you are not in the mainline kernel, every hack is
>  > forgiven.
>
>  That'll work moving forward, but btrfs also supports older releases.
>
>
>  - -Jeff

So how about this for older releases? It should work on Ubuntu 7.10 or
8.10 installs with apparmor enabled by default:

#if defined(CONFIG_VERSION_SIGNATURE)
# if (LINUX_VERSION_CODE = KERNEL_VERSION(2,6,24)) ||
(LINUX_VERSION_CODE = KERNEL_VERSION(2,6,20))
# define REMOVE_SUID_PATH 1
# endif
#endif

Maybe add a blurb in the install doc about this for users trying to
build ubuntu kernels with no apparmor (probably a rarity).

CONFIG_VERSION_SIGNATURE can be likened to CONFIG_SUSE

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
