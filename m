Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33458 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLBIeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 03:34:21 -0500
Date: Tue, 2 Dec 2014 08:34:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
Message-ID: <20141202083419.GK32735@carfax.org.uk>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oqiVxqbeHx5cy56u"
In-Reply-To: <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oqiVxqbeHx5cy56u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 08:51:40AM +0530, Shriramana Sharma wrote:
> On Mon, Dec 1, 2014 at 6:24 AM, Chris Murphy <lists@colorremedies.com> wrote:
> >> But isn't it just possible to move i.e. reparent a
> >> subvol so I can move these two under another subvol and have that as
> >> default?
> >
> > You can move subvolumes.
> 
> OK so I just found out that just mv test1/foo test2/ where test1,
> test2 and foo are all subvolumes is sufficient to reparent foo to
> test2, if what btr sub list shows as "top level" is indeed the parent
> subvolume.
> 
> Is that correct: what btr sub list shows as "top level" is indeed the
> parent subvolume?

   No, it's the top-level subvolume. (See my earlier mail about
nomenclature). "Parent subvolume" has a number of meanings, none of
which should be "the subvolume with subvolid 5".

> > My suggestion is subvolumes containing
> > binaries shouldn't be located within another subvolume that ends up
> > being mounted, that way old binaries with possible vulnerabilities
> > aren't exposed in the normal search path.
> 
> I'm not sure what you mean. Are you saying that for example /usr/bin should be:
> 
> 1) a separate subvolume than / or /usr,
> 2) not a child subvolume of / or /usr?
> 
> > openSUSE uses subvol id 5 for installing the OS to, and some
> > directories are made subvolumes such as home var and maybe usr.
> > Therefore when subvolid 5 is snapshot, those are exempt, and have to
> > be individually snapshot.
> 
> Yes I also noticed that openSUSE creates such separate subvols, but is
> there any particular benefit to making it so?

   In the sense of allowing independent snapshotting, yes. I might
want to back up / (with usr, var, and so forth) only when I do a
system upgrade, but /home every night. Making /home a separate subvol
gives me the ability to snapshot those two areas independently.

> > Fedora uses subvolumes root and home by default, and fstab uses
> > subvol=root and subvol=home to mount them at / and /home respectively.
> 
> This seems similar to Ubuntu's @ and @home setup.
> 
> Is there any advantage to either? That is, one model installs root to
> the topmost subvol and makes usr, home etc nested subvols, whereas
> another makes root a nested subvol under the topmost just like usr
> home etc, and then mounts it to /...
> 
> In general it seems people (or at least distros) prefer avoiding
> nesting subvolumes. Is there any particular reason for this? Esp in
> regard to /usr etc it would seem that if they are nested within the
> subvol for /, then just mounting that subvol would automatically mount
> all nested subvolumes, right? So the extra effort needed to mount the
> nested subvols would not be necessary, no?

   Nested subvols tend to get messy in practice. It's harder to
replace a "higher level" one, because you've got to move the "lower
level" ones around. It's also much harder to make a send/receive
backup of the subvols in their original relationships, because of the
read-only requirement.

   Whilst the theory came first, several years of practice has shown
both that nesting subvolumes is generally more awkward to manage, and
that putting files in the top-level subvol can't do what most people
want to do with it. Hence the recommended subvol management layout at
[1].

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Subvolumes

-- 
Hugo Mills             | We teach people management skills by examining
hugo@... carfax.org.uk | characters in Shakespeare. You could look at
http://carfax.org.uk/  | Claudius's crisis management techniques, for
PGP: 65E74AC0          | example.       Richard Smith-Jones, Slings and Arrows

--oqiVxqbeHx5cy56u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUfXmKAAoJEFheFHXiqx3kKosP/1Gy4p/iPq8/n+kbl9K3FSPQ
I4+fGOnOJhH057yPqIxiGAJ1ECNaRJ17Li+Z2adug7wuFeV9iXvXcSU9/0C8uF3K
V8hiNgMOKDPq5vyWas7MTs8iF4zoyKxIO7NWcX3Sxu7AeTCyijN78nBRwT7crEEm
ezzPDlu3Wjmnl3jWlPmiH2ysrCuIfco06thCB1dTO8Enf2LlBfmN25hEUwWMyIxE
tsruFjhvUzL8oBGeegyzr77C4nBM652dWEXsrxaxDK2MS4FfLaGDJJsr8yirUvSG
Z5+tcL4MDtBjlKEyQa4ivnOqyyLBAoUNPgmu0cgdXMK1ODRp2pG0UlUI+czLJMe3
Fb1RQAQvFONz7HOQNz3EfV8caUKwAYA825RuRVFDW668rpTsTaPr85bhTtIhiuka
6P/dEAyyspgiaatmOKgeJaflD49NYMtnGZsCXu/YE9yOuRXGPu2IrUbTZiVQ4ce6
1nExoHvU8vNAqBv5kz/zP+NUpyz6uv8qDBgOmlkxnOQvZtKRRcUrNok2z+pjFySF
ldvIP+ZThc55Xa1zor+k2wqHYFkKlTPRBMeVtfmmjI+zV66jenazUMYtQtiFAwxx
PdU8ROhPpWSvIOJnbjM56qVsgQPj5kbFVFLZNW5c0tDiNkIuc1MzSHZDOCEN043i
1WKiysl6sOgQO+zRRppk
=2Slw
-----END PGP SIGNATURE-----

--oqiVxqbeHx5cy56u--
