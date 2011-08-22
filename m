From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs over nfs
Date: Mon, 22 Aug 2011 22:28:47 +0100
Message-ID: <20110822212847.GA5412@carfax.org.uk>
References: <CAGFoeJ8J4f2_r=bdWapr0CM+Oq+aSJ78-E4D2zP5atHXdovoFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Cc: linux-btrfs@vger.kernel.org
To: Jim Maloney <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGFoeJ8J4f2_r=bdWapr0CM+Oq+aSJ78-E4D2zP5atHXdovoFw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 22, 2011 at 05:07:45PM -0400, Jim Maloney wrote:
> I have been experimenting exporting btrfs subvolumes over nfs.  Main
> subvolume is filesys1 mounted at /filesys1.  Below this is subvolume
> base, user1 is in base and documents is in user1.   documents is
> mounted at /documents.  /etc/exports is:
> /filesys1/base/user1    172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)
> /filesys1/user1-snapshot        172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)
> /documents      172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)

   I think you need to specify a different fsid for each export.
That's what I've got here, and it seems to work.

   Hugo.

> 
> On the client machine I mount user1 as /mnt/user and all data from
> user is present.
> I can also umount /mnt/usr and mount /documents as /mnt/documents and
> all data is present.
> However, if I mount user1 as /mnt/user and then mount /documents as
> /mnt/documents
> the data from the last subvolume mounted shows in both mounts.  Mount
> also shows:
> 172.16.0.28:/documents/ on /mnt/user type nfs
> (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.16.0.28,mountvers=3,mountport=892,mountproto=udp,local_lock=none,addr=172.16.0.28)
> 172.16.0.28:/documents/ on /mnt/documents type nfs
> (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.16.0.28,mountvers=3,mountport=892,mountproto=udp,local_lock=none,addr=172.16.0.28)
> 
> The initial mount of user1 on /mnt/user showed correctly in mount.
> Mount changes when I add the mount for /documents.
> I don't know how to troubleshoot this.  I am happy to provide any info
> which can help.
> Btrfs is currently on a centOS6 machine running kernel 3.0.1 with
> btrfs-progs from git unstable.
> NFS is v3 on both server and client and the client is Fedora 15 kernel
> 2.6.40-4.fc15.x86_64
> Thanks
> Jim Maloney
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOUsoPIKyzvlFcI40RAkm1AJ4no85LpWeJEHDQKM+FYmGhyQOnrgCeOYlU
hdRi30122c6NTzMYX9y2XvY=
=nwXm
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
