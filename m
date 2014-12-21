Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40374 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaLUWRG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 17:17:06 -0500
Date: Sun, 21 Dec 2014 22:17:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: constantine <costas.magnuse@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Uncorrectable errors on RAID-1?
Message-ID: <20141221221700.GC25267@carfax.org.uk>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
 <54974226.2080300@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
In-Reply-To: <54974226.2080300@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 01:56:54PM -0800, Robert White wrote:
> On 12/21/2014 11:34 AM, constantine wrote:
> >Some months ago I had 6 uncorrectable errors. I deleted the files that
> >contained them and then after scrubbing I had 0 uncorrectable errors.
> >After some weeks I encountered new uncorrectable errors.
> >
> >Question 1:
> >Why do I have uncorrectable errors on a RAID-1 filesystem in the first place?
> 
> These are disk/platter/hardware errors. They happen for one of two
> reasons. (most likely) There is a flaw, new or existing, on the
> platter itself and data just cannot live in that spot. (least
> likely) You suffered an environmental hazard (hard jolt) while a
> sector was being written and the drive is just choking on the
> digital wreckage.
> 
> 
> >Question 2:
> >How do I properly correct them? (Again by deleting their files? :( )
> 
> You have to _force_ the system to write the sector. If the disk can
> correct the sector (not a hardware flaw) the problem goes away
> forever. If it can't the drive will re-map the sector with a spare
> sector and it will seem to go away forever.

   Note that one of the drives already has reallocated sectors, so
it's on its way to failing, and you should start saving up your
pennies for a new one now, even if it hasn't gone properly boom
yet. However, that doesn't explain on its own why you're getting
unrecoverable errors -- the FS should be able to deal with that.

[snip]

> The good news is that since you are using RAID1 and checksums you
> shouldn't need to delete any files. Just coerce the write and then
> btrfs scrub your filesystem and the checksum/rewrite thing should
> recover the degraded copy from the good copy in the mirror.

   If btrfs detects a checksum error, it will try to fix it by reading
the other copy and then writing good data to the broken copy
again. You don't have to force a write to the FS in order to make it
fix broken data this way. A scrub will do this check-and-repair on all
content of the filesystem.

   If the FS is reporting uncorrectable errors, then it's tried both
copies and both fail their checksums. This is basically not fixable
without removing the files and replacing them with copies from your
backup. It's not obvious why you've got correlated errors on two
devices, though, and I'm not sure how to work it out.

   I'd suggest running the full SMART tests on the disks, and running
a scrub on the FS, and checking your logs for SATA errors and similar
problems.

   Hugo.

[snip]

-- 
Hugo Mills             | I must be musical: I've got *loads* of CDs
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                     Fran, Black Books

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUl0bcAAoJEFheFHXiqx3kw0oQAIKMkizjTpc6kZR0SCM5806m
E9hI6rRD5rzI7nt27D+bXw2pbE2Gm7QqYIcL+2KZnyt0bJa/XpLzwB1gS2UtRnYu
u8r9YlyBvyUU9ONIK4uJlJ5JfhrEm2CiXogri9bk7Gm9E/WNZiAJybgKOCmWCWtQ
4BcVadXIbG0/mw12g/nqfYqfjO4hozdvNYTr9e6Z9OD2A9JZjoeLvsBGa8PdCUXv
kZk60dGM4dTQaoemXCBv+zAIiCT+5QUhAMB+Myi9+r3BXPnyWPIitplN9Khsr1lQ
2lJ+W+OLNDH20nM9HINnJJfFb0Sl64Q3FuRIBKnxXl+qBoD3mnpyl1hFrPrmSvdh
xJGPii/P2dSCoThD75GornepOj15MUvoHRK9axW7qghvxlXIwzD5hxn5xFLd5sQp
JpSFWi0mMHlqINM1422oXc+atm2Oj2UHVmUzap/HD4RbT2dCPDts5oGhaqs3sp6j
99zsUIpkKkkK/69N4auEyPOUiJ7btEfVuqyqc+jkykA/zADpowsfGfpqHhF6xFJM
50rU9xtZzYDQtHeZspDsnhVUOU4mTPqjkQbnUU+8sDyr6JkNyEgiKITuh7GREwDu
W5dO5LdpK+JMuEvH2squpC0jV9cEHORl57A+I8cW/GepbEH+ZdgN5eUlXlQxC7Wn
DOiIYFhIFNZssyzgb1TU
=ZEjx
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
