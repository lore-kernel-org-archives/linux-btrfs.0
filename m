Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44466 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbbFOIww convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 04:52:52 -0400
Date: Mon, 15 Jun 2015 10:53:33 +0200
From: =?UTF-8?B?R8OhYm9y?= Nyers <pubny@xs4all.nl>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: "@" prefix in subvolume paths
Message-ID: <20150615105333.640a6a1f@host22323.xs4all.nl>
In-Reply-To: <5578E95B.70105@suse.com>
References: <20150609195505.12ace1e8@host22323.xs4all.nl>
	<20150610231014.GF18226@carfax.org.uk>
	<5578E95B.70105@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jeff,

Thanks for elaborating on this. I'm wondering where in the
SLES/openSUSE documentation these considerations are documented. Do you
have a pointer?

Thanks,
Gábor


On Wed, 10 Jun 2015 21:50:19 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 6/10/15 7:10 PM, Hugo Mills wrote:
> > On Tue, Jun 09, 2015 at 07:55:05PM +0200, pubny@xs4all.nl wrote:
> >> Hi,
> >> 
> >> I've noticed this "@" sign in the subvolume's path with SLES12.
> >> I'm wondering what is its purpose. openSUSE 13.2 doesn't seem to
> >> be using it.
> > 
> > They created a subvolume called "@" and then put all the other 
> > subvolumes under there. There's nothing special about it.
> > 
> > The @ is often used as a prefix on subvolumes (e.g. in Ubuntu) to 
> > indicate that they're subvolumes, but it's not required, and
> > doesn't have any extra meaning beyond being a useful naming
> > convention.
> 
> Yep. That explanation is accurate but is missing the rest of the
> story. The choice of @ is probably due to following the convention
> started by the Ubuntu folks but also because it's the least
> complicated of the alternative names we could have used. The @
> subvolume is set as the default subvolume. As you'd expect, it's
> mounted at / and used as such. The reason we use a separate subvolume
> is so we can easily implement our boot-and-rollback-from-snapshot
> functionality in SLE12. Having the root file system as a separate
> subvolume means we can move one of the snapshot subvolumes into the fs
> tree root, move the other @ subvolumes into that subvolume, and we
> have a rolled back system from which we can easily remove the
> now-unused root. If we didn't use a separate subvolume for it, it
> would make the rollback very complicated. It's used in concert with
> our GRUB implementation that iterates and presents possible snapshots
> to use as a root file system in lieu of the "real" one should a
> problem occur.
> 
> - -Jeff
> 
> >> 
> >> SLES12: # btrfs sub list / ID 257 gen 2270 top level 5 path @ ID
> >> 258 gen 1655 top level 257 path @/boot/grub2/i386-pc ID 259 gen
> >> 4263 top level 257 path @/boot/grub2/x86_64-efi ID 260 gen 4037
> >> top level 257 path @/opt ID 261 gen 2553 top level 257 path
> >> @/srv ID 262 gen 4521 top level 257 path @/tmp ID 263 gen 4492
> >> top level 257 path @/usr/local ID 264 gen 1655 top level 257 path
> >> @/var/crash ID 265 gen 1655 top level 257 path @/var/lib/mailman 
> >> ID 266 gen 1655 top level 257 path @/var/lib/named ID 267 gen
> >> 1655 top level 257 path @/var/lib/pgsql ID 268 gen 4523 top level
> >> 257 path @/var/log ID 269 gen 1655 top level 257 path @/var/opt 
> >> ID 270 gen 4524 top level 257 path @/var/spool ID 271 gen 4521
> >> top level 257 path @/var/tmp ID 275 gen 4505 top level 257 path
> >> @/.snapshots
> >> 
> >> 
> >> openSUSE 13.2:
> >> 
> >> # btrfs subvol list / ID 257 gen 3481911 top level 5 path
> >> boot/grub2/i386-pc ID 258 gen 3481911 top level 5 path
> >> boot/grub2/x86_64-efi ID 259 gen 3517714 top level 5 path home ID
> >> 260 gen 3515789 top level 5 path opt ID 261 gen 3513493 top level
> >> 5 path srv ID 262 gen 3513372 top level 5 path tmp ID 263 gen
> >> 3517660 top level 5 path usr/local ID 264 gen 3513372 top level 5
> >> path var/crash ID 265 gen 3513372 top level 5 path
> >> var/lib/mailman ID 266 gen 3513372 top level 5 path
> >> var/lib/named ID 267 gen 3513372 top level 5 path var/lib/pgsql 
> >> ID 268 gen 3517714 top level 5 path var/log ID 269 gen 3513372
> >> top level 5 path var/opt ID 270 gen 3517714 top level 5 path
> >> var/spool ID 271 gen 3517706 top level 5 path var/tmp ID 276 gen
> >> 3517669 top level 5 path .snapshots
> > 
> 
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
> 
> iQIcBAEBAgAGBQJVeOlbAAoJEB57S2MheeWy0JYP/1mbM5ybHNcwEB21CbS+5ujv
> omBmiVhX6nAcTDAJ2OJG7MsrE4L1j93R8gv/xRkPjBLuaiqJ+wr88VaG/AcKvtSZ
> qMF64PJCNzsXFd0FFPi8CNXxhVbJyEKF+m8Xl+tfRsMhsNIKdbqkMHInMc99qWJH
> dMLTSYObvdo9AYIkOj8PM6nBjeQ4zEBQY9uOf9M9HL8Ulc1VQgzSu1giuvHg8/Cf
> Ela2iZJi2APZeNisQtQcJssMyBaDTbSH0RhQh8kcdfG6GCruSDR8AWbyuY36OeaG
> 5Ifp4J7oSS+eUwlTtvLFfZl079VmJWZbF/KEy8GfY++kp+BVB95Z8QOKVOVTEA8A
> 4AvkMfdGvtykZJNRskXGaIsUIX07iTmT2f+VyN7jbfp2J5FyBALp+i4Ub5fyjUZG
> +OWcAIkTC9z2AQW77ZMdA4DdkHk5bi3aRSCNV1gSPGDib5CH5ZLyMY/KKtxCLSnO
> syNdcZmQs4bb7FZBfcM4CQraUYsnBl4ArGechkMWpJCrMx2dtRrGlKlh+7KmG+m8
> 60xBKU3ApmZrcKUTAcWvN2cy72xmc8GZaOPnNepAUhMLduarsEtyCemOkGCZxRiu
> c0QRGhGBgK91MBF1KxXzrnO0cm1ijdjMAbwmol6vEYRzXItXK3AeD74IeY6Abqr/
> U2lTFYlKYpkTmzhk0gM8
> =lO/K
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

