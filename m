From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 02 May 2008 12:26:02 -0400
Message-ID: <481B409A.2070607@suse.com>
References: <200804291601.32945.chris.mason@oracle.com> <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com> <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, jeffschroeder@computer.org,
	Jan Engelhardt <jengelh@medozas.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Tim Gardner <timg@tpi.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <481B3C0E.502@tpi.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tim Gardner wrote:
> Chris Mason wrote:
>> On Friday 02 May 2008, Jeff Schroeder wrote:
>>
>> [ Btrfs oops with apparmor patched in ]
>>
>>> Make is not my forte, but here is a working test to see if apparmor
>>> exists in Ubuntu 8.04.
>>> Maybe have make apply a patch to the btrfs source if this test
>>> succeeds? Does this work in SUSE?
>>>
>>> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test
>>> _for_btrfs.patch
>>>
>> Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell if 
>> the kernel has the patch.  Lets go back to Jeff's suse patch:
>>
>> /*
>>  * Even if AppArmor isn't enabled, it still has different prototypes.
>>  * Add more distro/version pairs here to declare which has AppArmor applied.
>>  */
>> #if defined(CONFIG_SUSE_KERNEL)
>> # if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
>> # define REMOVE_SUID_PATH 1
>> # endif
>> #endif
>>
>> Could someone from Ubuntu please suggest a replacement for CONFIG_SUSE_KERNEL 
>> and KERNEL_VERSION(2,6,22) that would correspond with ubuntu kernels shipped 
>> with apparmor?  We don't need some define from the apparmor patch, just a 
>> global flag that says it comes from ubuntu is enough.
>>
>> -chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> To the best of my knowledge, the AppArmor patches are arch and flavour
> independent. If CONFIG_SECURITY_APPARMOR exists, then the AA code is
> compiled. This is certainly the case for Hardy. Neither Kees or myself
> are aware of any reason why it won't also hold true for Intrepid.

Grumble. The issue isn't whether AA is enabled, it's whether it's
present in the source. Patching the source with AA modifies a bunch of
core VFS function prototypes. CONFIG_SECURITY_APPARMOR won't exist if AA
isn't enabled, but the prototypes will have changed anyway.

The SUSE kernel doesn't export information about the presence of
particular features, but it does identify itself as a SUSE kernel so
that the pair of CONFIG_SUSE_KERNEL and the version number will identify
a release. For our enterprise kernels, where the version number won't
change over the lifetime of the release, we identify release version and
service pack levels as well.

I took a look at config-2.6.24-16-generic from 8.04 and didn't see
anything comparable.

At any rate, it's probably enough to ignore that corner case and assume
that any kernel with AA patched in will have it enabled. Anyone building
a distro kernel themselves to disable AA will probably also have the
knowledge to work around it in the btrfs source.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkgbQJoACgkQLPWxlyuTD7KhZACfZeZMBNx6x/avk5a2AED1g4rV
deEAnjgTp18gxVn4d7USmdfSXOeweG52
=/yZN
-----END PGP SIGNATURE-----
