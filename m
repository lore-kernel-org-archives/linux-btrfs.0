From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Can't mount
Date: Thu, 3 May 2012 16:31:27 +0100
Message-ID: <20120503153127.GG9860@carfax.org.uk>
References: <CAPAyKow8hk5kzAkkTG=nmOMpnhjx3cjM_-uLGNVmNWXNc+1j=g@mail.gmail.com>
 <CAPAyKowHusQXh-BzvgQRBL8=82yTgP+marcdVq8wLtSxuoCyvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f5QefDQHtn8hx44O"
Cc: linux-btrfs@vger.kernel.org
To: Yo'av Moshe <bjesus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPAyKowHusQXh-BzvgQRBL8=82yTgP+marcdVq8wLtSxuoCyvQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--f5QefDQHtn8hx44O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 03:18:01PM +0000, Yo'av Moshe wrote:
> Hey,
> 
> When I try to mount my Btrfs filesystem it fails and this shows up on dmesg:
> 
> device fsid 97727502-a678-4ed1-a96c-409b852d76bf devid 1 transid
> 135714 /dev/sda4
> btrfs: enabling auto recoveryparent transid verify failed on
> 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> btrfs: open_ctree failed
> 
> Using the latest btrfs-progs, btrfsck and btrfs-debug-tree gives this:
> 
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> parent transid verify failed on 216925220864 wanted 135714 found 135713
> Ignoring transid failure
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
> `!(path->slots[0] == 0)' failed.
> 
> I also couldn't find anything valid using btrfs-select-super.
> 
> This is find-root's output:
> http://pastebin.com/KycgzhaP
> 
> Is there anything else I can try?
> 
> I'm using kernel 3.2 on Ubuntu 12.04.

   In approximate order:

 * Try a 3.3 or 3.4-rc5 kernel. I don't think those will do anything
   to fix this particular issue, but it's worth a try.

 * You have the last-but-one generation listed by find-root:

Well block 216926195712 seems great, but generation doesn't match, have=135713, want=135714

   so you can use the restore tool[1] with that block number (and -t)
   to copy off any data that you need that isn't backed up.

 * There's btrfsck --repair, which may do something to fix it
   in-place, but may not (or may damage your filesystem more)

 * And, of course, there's your backups that you can restore from.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=Restore

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                 

--f5QefDQHtn8hx44O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPoqTPIKyzvlFcI40RAmf2AJ9HdKCI4OzXzmK/QQX/uYf+aFxntQCdFAcN
yXnRI+mxwbTUM/9SL98APGI=
=h2p6
-----END PGP SIGNATURE-----

--f5QefDQHtn8hx44O--
