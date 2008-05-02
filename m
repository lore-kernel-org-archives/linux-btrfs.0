From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 02 May 2008 14:01:33 -0400
Message-ID: <481B56FD.9020807@suse.com>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com> <481B409A.2070607@suse.com> <alpine.LNX.1.10.0805021959150.6463@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tim Gardner <timg@tpi.com>, Chris Mason <chris.mason@oracle.com>,
	jeffschroeder@computer.org,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0805021959150.6463@fbirervta.pbzchgretzou.qr>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan Engelhardt wrote:
> On Friday 2008-05-02 18:26, Jeff Mahoney wrote:
>>> To the best of my knowledge, the AppArmor patches are arch and flavour
>>> independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
>>> compiled. This is certainly the case for Hardy. Neither Kees or myself
>>> are aware of any reason why it won't also hold true for Intrepid.
>> Grumble. The issue isn't whether AA is enabled, it's whether it's
>> present in the source. Patching the source with AA modifies a bunch of
>> core VFS function prototypes. CONFIG_SECURITY_APPARMOR won't exist if AA
>> isn't enabled, but the prototypes will have changed anyway.
> 
> So... add an invisible CONFIG_HAVE_APPARMOR, much like
> CONFIG_X86_HAVE_CMPXCHG (or whatever it's called), and test for that.
> As long as you are not in the mainline kernel, every hack is
> forgiven.

That'll work moving forward, but btrfs also supports older releases.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkgbVv0ACgkQLPWxlyuTD7JLrACfUKFXwh/nYuwDw7oT3lFLs/E7
cNQAn2LQKNJkIc/SDQJJ2ykuvYAg++D8
=1Ami
-----END PGP SIGNATURE-----
