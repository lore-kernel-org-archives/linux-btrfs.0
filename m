From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 20:00:22 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805021959150.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com> <481B409A.2070607@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tim Gardner <timg@tpi.com>, Chris Mason <chris.mason@oracle.com>,
	jeffschroeder@computer.org,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <481B409A.2070607@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2008-05-02 18:26, Jeff Mahoney wrote:
>> 
>> To the best of my knowledge, the AppArmor patches are arch and flavour
>> independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
>> compiled. This is certainly the case for Hardy. Neither Kees or myself
>> are aware of any reason why it won't also hold true for Intrepid.
>
>Grumble. The issue isn't whether AA is enabled, it's whether it's
>present in the source. Patching the source with AA modifies a bunch of
>core VFS function prototypes. CONFIG_SECURITY_APPARMOR won't exist if AA
>isn't enabled, but the prototypes will have changed anyway.

So... add an invisible CONFIG_HAVE_APPARMOR, much like
CONFIG_X86_HAVE_CMPXCHG (or whatever it's called), and test for that.
As long as you are not in the mainline kernel, every hack is
forgiven.
