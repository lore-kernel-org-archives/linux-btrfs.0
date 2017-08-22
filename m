Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33813 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932513AbdHVOXi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:23:38 -0400
Date: Tue, 22 Aug 2017 14:23:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822142336.GB32302@carfax.org.uk>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
 <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
 <20170822135301.GF14804@rus.uni-stuttgart.de>
 <ebb608fe-15f3-3b51-b06f-28c1dcfb6612@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
In-Reply-To: <ebb608fe-15f3-3b51-b06f-28c1dcfb6612@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 10:12:25AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-08-22 09:53, Ulli Horlacher wrote:
> >On Tue 2017-08-22 (09:37), Austin S. Hemmelgarn wrote:
> >
> >>>root@fex:~# df -T /local/.backup/home
> >>>Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> >>>-              -    1073740800 104252160 967766336  10% /local/.backup/home
> >>
> >>Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and
> >>16.04.3 VM's I have (I only run current and the most recent LTS
> >>version), and neither of them behave like this.
> >
> >I have this kind of output on all of my Ubuntu hosts:
> >
> >root@moep:~# grep PRETTY_NAME /etc/os-release
> >PRETTY_NAME="Ubuntu 16.04.3 LTS"
> >
> >root@moep:~# df -T /usb/UF/tmp/blubb
> >Filesystem     Type 1K-blocks    Used Available Use% Mounted on
> >-              -     12581888 3690524   7253700  34% /usb/UF/tmp/blubb
> >
> >root@moep:~# btrfs subvolume show /usb/UF/tmp/blubb
> >/usb/UF/tmp/blubb
> >         Name:                   blubb
> >         UUID:                   ecf8c804-d4a3-9948-89fe-b0c1971c25cb
> >         Parent UUID:            -
> >         Received UUID:          -
> >         Creation time:          2017-08-22 12:54:16 +0200
> >         Subvolume ID:           262
> >         Generation:             23
> >         Gen at creation:        22
> >         Parent ID:              5
> >         Top level ID:           5
> >         Flags:                  -
> >         Snapshot(s):
> >
> >root@moep:~# dpkg -l | grep btrfs
> >ii  btrfs-tools                                 4.4-1ubuntu1                                 amd64        Checksumming Copy on Write Filesystem utilities
> >
> Hmm, interesting.  Are you using qgroups by chance?

   I get this behaviour (the "- -") only if it's a non-mounted
subvolume:

hrm@amelia:~ $ df -T .
Filesystem     Type  1K-blocks     Used Available Use% Mounted on
/dev/sdb1      btrfs 117220284 95271852  18611060  84% /home

hrm@amelia:~ $ sudo btrfs sub crea foo
Create subvolume './foo'

hrm@amelia:~ $ df -T ./foo
Filesystem     Type 1K-blocks     Used Available Use% Mounted on
-              -    117220284 95271880  18611032  84% /home/hrm/foo

hrm@amelia:~ $ sudo mkdir foo/bar
hrm@amelia:~ $ df -T foo/bar
Filesystem     Type 1K-blocks     Used Available Use% Mounted on
-              -    117220284 95271852  18611060  84% /home/hrm/foo

hrm@amelia:~ $ mkdir foo2

hrm@amelia:~ $ sudo mount /dev/sdb1 ./foo2 -o subvol=home/hrm/foo

hrm@amelia:~ $ df -T foo2
Filesystem     Type  1K-blocks     Used Available Use% Mounted on
/dev/sdb1      btrfs 117220284 95272384  18610528  84% /home/hrm/foo2

   Hugo.

-- 
Hugo Mills             | "Your problem is that you have a negative
hugo@... carfax.org.uk | personality."
http://carfax.org.uk/  | "No, I don't!"
PGP: E2AB1DE4          |                              Londo and Vir, Babylon 5

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZnD5oAAoJEFheFHXiqx3kCakP/RkhRwxuGmbibkZ6LinbGPAW
1spCPCLfH/uZTwQMlR6Adl5gV+5clmhlFNDJBY3o69pq7e2Cm4iviXJWhijb823M
1mYf1unIA+L6p0d84xjNFdrlc3JhgCTkLC8EB8DtfHF2J0mm3XL0rF3ryIUlUTwK
QQz3okZhoOKEOCJsFpITQTf6iD9VkNJxugM7+SJhIwVPetPahTezySfrnw3FWJzk
2170dcQd9a2urkuyGdZLvPCItPUPxAs4C8E5/fVZdV+Onod8hg3EnW5QPPrQ4iLL
55JRhqCbc7zDjFBw6YQsWM1/ShTSy7Ja4BDE5p+er1yr2F2RNQzWlr4B/HqKC6FW
SHkrnzAcgNwkfnrtguKwP2WVVXdVzg3au50epaear54Oocnzw+3E5A8DGdBT5c5F
oaK4OW9YuwdAIWDXe6UKcuTDz0YEtXyHUNFCI7ewEyU1qs475qZev9Ju3nf4KPlk
5huUrW8JkAoZR2LYDzYOzF4RKvmBTTHq8OGIU0q0Vk8IUS/ppFQcA4VZqtCXMj6o
H8PC9fH2sfSI48H+RPeqGdHyeLSJW6m1oMsQrE6yvUPusRm61PpwaDY+brC1uvA4
ZWwawDs8ChrpTqUeBmINQoAJZCLRsk6HhYarGVeVrNCRxvBzQ+9L/azuNDZ06rx5
uXWODBz4MthF9WCNWUOO
=+Y+K
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
