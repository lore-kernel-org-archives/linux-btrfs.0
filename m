Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:38669 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388348AbeGXNWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 09:22:34 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M04uG-1g0q4H04Ro-00uGJX for
 <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2018 14:16:21 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: File permissions lost during send/receive?
Date: Tue, 24 Jul 2018 14:16:15 +0200
Message-ID: <8202618.Xtt70Sb46P@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8073226.WS8yGQltbI"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart8073226.WS8yGQltbI
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi list,

(Preemptive note: this was with btrfs-progs 4.15.1, I have since upgraded to 
4.17.  My kernel version is 4.14.52-gentoo.)

I recently had to restore the root FS of my desktop from backup (extent tree 
corruption; not sure how, possibly a loose SATA cable?).  Everything was fine, 
even if restoring was slower than expected.  However, I encountered two files 
with permission problems, namely:

- /bin/ping, which caused running ping as a normal user to fail due to missing 
permissions, and

- /sbin/unix_chkpwd (part of PAM), which prevented me from unlocking the KDE 
Plasma lock screen; I needed to log into a TTY and run "loginctl unlock-
session".

Both were easily fixed by reinstalling the affected packages (iputils and 
pam), but I wonder why this happened after restoring from backup.

I originally thought it was related to the SUID bit not being set, because of 
the explanation in the ping(8) man page (section "SECURITY"), but cannot find 
evidence of that -- that is, after reinstallation, "ls -lh" does not show the 
sticky bit being set, or any other special permission bits, for that matter:

% ls -lh /bin/ping /sbin/unix_chkpwd 
-rwx--x--x 1 root root 60K 22. Jul 14:47 /bin/ping*                                                                                                                                                                                                                            
-rwx--x--x 1 root root 31K 23. Jul 00:21 /sbin/unix_chkpwd*

(Note: no ACLs are set, either.)

I do remember the qcheck program (a Gentoo-specific program that checks the 
integrity of installed packages) complaining about wrong file permissions, but 
I didn't save its output, and there's a chance it *might* have been because I 
ran qcheck without root permissions :-/ .

I vaguely remember some patches and/or discussion regarding permission 
transfer issues with send/receive on this ML, but didn't find anything after 
searching through my Email archive, so I might be misremembering.

Does anybody have any idea what possibly went wrong, or any similar experience 
to speak of?

Greetings
-- 
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart8073226.WS8yGQltbI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAltXGI8ACgkQv9DmhiyI
ePTwHBAAxJznmJ+h1bpKbyx/uBdTneIdmntsJ6bB/K4dOMFf3a7aaSvrS9ymExmy
1mfFfYHRq4zOWygIWhdT1NvzwHmN0mO3OZJZPdGKJXet37tMMHnuXwtLKYFdtms7
csAOqkHSCLIyLo28UgbnRQNHjtCOIOMDOXh0IXfjv90eZBQvW+ym32dvuBpO3e9B
b/+9uywXuTXrl1Eq8Z2cYBQUcNsPYGCLLs39UIMBHnvmOEzv2eC0/xMpOMD8GO1h
I86+TIoDJ3/LgabxoEYjVF2XiaWMNoVRCMjSiIgtrtPJjj1EqlfOXqzJOj5eEDbj
6UzUQ7nZrqcI+TOiZvSOao9zCn4K7UeQQsSySxxIjuMvcO7+ws9cFtDzoy1QOg36
C1sYtKHGXBntFdp6KG6CSyeu8L6ZWF4RxQwION+i9KI8s/mx9HmFqjvxtRw46Atc
rv7DWurxfL3VuMknpex1CtF9G+ihB1FDHRYaDEPH9cxacAXSEqn7DZlBBJv10JAG
YguCRRPcMXH+e1lSYwPbiDUXispkMB2eG8CkNi6GcDfdmQjagpmPj1ooUMUNSyMy
5C4bo1JSkSD3dRE7U4LXPkb7dyr761o1dL+4OZwLg8XpkFV3V37vWt/n1UYdqByA
plVIQUyyWRpKGtCoOhKgA4KPELjHtZsRRxvfrHbrMK8EHvuKHSw=
=0ui7
-----END PGP SIGNATURE-----

--nextPart8073226.WS8yGQltbI--



