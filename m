Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38647 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdLLQYZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 11:24:25 -0500
Date: Tue, 12 Dec 2017 16:24:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Neal Becker <ndbecker2@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: broken btrfs filesystem
Message-ID: <20171212162423.GB18793@carfax.org.uk>
References: <CAG3t+pHLcrMLH8XxWSc+P6v-gtMZds+RNKBz6RKzAWdWr8ObhQ@mail.gmail.com>
 <20171212145201.GA18793@carfax.org.uk>
 <CAG3t+pH3+B08M4y1t+K4p2SEk5KURtF_jTitL0RWZ2E-yVAHgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
In-Reply-To: <CAG3t+pH3+B08M4y1t+K4p2SEk5KURtF_jTitL0RWZ2E-yVAHgg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 12, 2017 at 04:18:09PM +0000, Neal Becker wrote:
> Is it possible to check while it is mounted?

   Certainly not while mounted read-write. While mounted read-only --
I'm not certain. Possibly.

   Hugo.

> On Tue, Dec 12, 2017 at 9:52 AM Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Tue, Dec 12, 2017 at 09:02:56AM -0500, Neal Becker wrote:
> > > sudo ls -la ~/
> > > [sudo] password for nbecker:
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > ls: cannot access '/home/nbecker/.bash_history': No such file or
> > directory
> > > total 11652
> > > drwxr-xr-x. 1 nbecker nbecker     5826 Dec 12 08:48  .
> > > drwxr-xr-x. 1 root    root          48 Aug  2 19:32  ..
> > > [...]
> > > -rwxrwxr-x. 1 nbecker nbecker      207 Dec  3  2015  BACKUP.sh
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -?????????? ? ?       ?              ?            ?  .bash_history
> > > -rw-r--r--. 1 nbecker nbecker       18 Oct  8  2014  .bash_logout
> > > [...]
> >
> >    Could you show the result of btrfs check --readonly on this FS? The
> > rest, below, doesn't show up anything unusual to me.
> >
> >    Hugo.
> >
> > > uname -a
> > > Linux nbecker2 4.14.3-300.fc27.x86_64 #1 SMP Mon Dec 4 17:18:27 UTC
> > > 2017 x86_64 x86_64 x86_64 GNU/Linux
> > >
> > >  btrfs --version
> > > btrfs-progs v4.11.1
> > >
> > > sudo btrfs fi show
> > > Label: 'fedora'  uuid: 93c586fa-6d86-4148-a528-e61e644db0c8
> > > Total devices 1 FS bytes used 80.96GiB
> > > devid    1 size 230.00GiB used 230.00GiB path /dev/sda3
> > >
> > > sudo btrfs fi df /home
> > > Data, single: total=226.99GiB, used=78.89GiB
> > > System, single: total=4.00MiB, used=48.00KiB
> > > Metadata, single: total=3.01GiB, used=2.07GiB
> > > GlobalReserve, single: total=222.36MiB, used=0.00B
> > >
> > > dmesg.log is here:
> > > https://nbecker.fedorapeople.org/dmesg.txt
> > >
> > > mount | grep btrfs
> > > /dev/sda3 on / type btrfs
> > > (rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/root)
> > > /dev/sda3 on /home type btrfs
> > > (rw,relatime,seclabel,ssd,space_cache,subvolid=318,subvol=/home)
> > >
> >

-- 
Hugo Mills             | Let me past! There's been a major scientific
hugo@... carfax.org.uk | break-in!
http://carfax.org.uk/  | Through! Break-through!
PGP: E2AB1DE4          |                                          Ford Prefect

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaMAK3AAoJEFheFHXiqx3krogQAIMszK0eUmxuxzeXq1mF/2bL
0riArpV01w4G+ItFSeKSf1sMUxq96vWZybicXPrMOuq4Ov+/D8YtbOU+QlWUFx0j
QHAy0/TdGeK/UBLaViv0cGjANaoXbfxlo1hl38PXdiVs0jnyZBkXcnxKZFnz+fDq
v6SX78KEzlaHmimJ9LEL2wW2n8bhaSBkkDsjJ34Iep8kHGbpx8PSOG4MgxIpVBNv
J7Df3ZDx0qbdX0e8ZnsnnUtL1DxXFge5uoSVStzZLS2fiqA08VDnTNDbjCr70ke7
Gr2Uu7h4e+pamlnoOtONckLkKH6Rrx3YKVO1n0U3Xrgv760J5LHhJL5mI4S60uoY
Sq5NujADwhgVN2LbhCCt7st3EY3VoFYjDBPK93P1056xFSr5dZb7eUABllQcrwsO
IJJ5Iuma9YkR9ep6vdvBf1qMKP0sHNrIrHC4ak+ATvj2lTLB///ePm5UpFWwbc2x
yvKcx1ISE7NIQPsVyA8+qY6oogWoZlu2woU9WVI2UGTuYFpbxB5hwKQseuc9zUWL
eFyKfy+uGeLMbizzEPHxfQIa9D9RtlZ0RrXf2Qxw0wVLsDEgiyB6GhP/oee8phKu
+43np9mmrGRxcKM7WRoaMDYVZJ1oHFAh3AEfytm+RXh9J/8W+DIq0Q4fjChGDDBZ
zz+tuzuP40u4X1ncDNqh
=AEu5
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
