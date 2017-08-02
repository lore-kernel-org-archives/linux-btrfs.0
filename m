Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51092 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdHBJHK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 05:07:10 -0400
Date: Wed, 2 Aug 2017 09:07:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Thomas Wurfbaum <thomas@wurfbaum.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Crashed filesystem, nothing helps
Message-ID: <20170802090709.GA7140@carfax.org.uk>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OGBBnVs4XFPv5LQD"
In-Reply-To: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OGBBnVs4XFPv5LQD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 02, 2017 at 10:27:50AM +0200, Thomas Wurfbaum wrote:
> Hello,
> 
> Yesterday morning i recognized a hard reboot of my system, but the /data 
> filesystem was 
> not possible to mount.
> 
> 
> mainframe:~ # uname -a
> Linux mainframe 4.11.8-2-default #1 SMP PREEMPT Thu Jun 29 14:37:33 UTC 2017 
> (42bd7a0) x86_64 x86_64 x86_64 GNU/Linux
> mainframe:~ # btrfs --version
> btrfs-progs v4.10.2+20170406
> mainframe:~ # btrfs fi show
> Label: none  uuid: 22aaaa76-0885-4683-ac04-477c27cfab80
>         Total devices 1 FS bytes used 2.88TiB
>         devid    1 size 4.53TiB used 2.92TiB path /dev/sdb1
> mainframe:~ # btrfs restore /dev/sdb1 /mnt     
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> Ignoring transid failure
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> Ignoring transid failure
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> Ignoring transid failure
> mainframe:~ # mount /dev/sdb1 /data                 
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> mainframe:~ # mount -o usebackuproot /dev/sdb1 /data
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> mainframe:~ # btrfs check /dev/sdb1
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> Ignoring transid failure
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> Ignoring transid failure
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> Ignoring transid failure
> Checking filesystem on /dev/sdb1
> UUID: 22aaaa76-0885-4683-ac04-477c27cfab80
> checking extents
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> Ignoring transid failure
> parent transid verify failed on 292339712 wanted 1486826 found 1486086
> parent transid verify failed on 292339712 wanted 1486826 found 1486086
> parent transid verify failed on 291078144 wanted 1486826 found 1486085
> parent transid verify failed on 291078144 wanted 1486826 found 1486085
> parent transid verify failed on 291078144 wanted 1486826 found 1486085
> parent transid verify failed on 291078144 wanted 1486826 found 1486085
> Ignoring transid failure
> parent transid verify failed on 292978688 wanted 1486826 found 1486086
> parent transid verify failed on 292978688 wanted 1486826 found 1486086
> parent transid verify failed on 292978688 wanted 1486826 found 1486086
> parent transid verify failed on 292978688 wanted 1486826 found 1486086
> Ignoring transid failure
> parent transid verify failed on 292519936 wanted 1486826 found 1486086
> parent transid verify failed on 292519936 wanted 1486826 found 1486086
> parent transid verify failed on 292536320 wanted 1486826 found 1486086
> parent transid verify failed on 292536320 wanted 1486826 found 1486086
> parent transid verify failed on 292552704 wanted 1486826 found 1486086
> parent transid verify failed on 292552704 wanted 1486826 found 1486086
> parent transid verify failed on 292585472 wanted 1486826 found 1486086
> parent transid verify failed on 292585472 wanted 1486826 found 1486086
> parent transid verify failed on 292585472 wanted 1486826 found 1486086
> parent transid verify failed on 292585472 wanted 1486826 found 1486086
> Ignoring transid failure
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> Ignoring transid failure
> leaf parent key incorrect 290766848
> bad block 290766848
> ERROR: errors found in extent allocation tree or chunk allocation
> parent transid verify failed on 290766848 wanted 1486826 found 1486085
> Ignoring transid failure
> leaf parent key incorrect 290766848
> ERROR: failed to repair root items: Operation not permitted
> mainframe:~ # btrfs rescue super-recover /dev/sdb1
> All supers are valid, no need to recover
> mainframe:~ # btrfs rescue zero-log /dev/sdb1
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> parent transid verify failed on 29392896 wanted 1486833 found 1486836
> Ignoring transid failure
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> parent transid verify failed on 29409280 wanted 1486829 found 1486833
> Ignoring transid failure
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> parent transid verify failed on 29376512 wanted 1327723 found 1486833
> Ignoring transid failure
> Clearing log on /dev/sdb1, previous log_root 0, level 0
> parent transid verify failed on 29474816 wanted 1486833 found 1486837
> Ignoring transid failure
> leaf parent key incorrect 29474816
> disk-io.c:524: update_cowonly_root: BUG_ON `ret` triggered, value -1
> btrfs(+0x26304)[0x555686369304]
> btrfs(btrfs_commit_transaction+0x98)[0x55568636aed8]
> btrfs(+0x69efa)[0x5556863acefa]
> btrfs(main+0x84)[0x555686361e34]
> /lib64/libc.so.6(__libc_start_main+0xf1)[0x7f43653df291]
> btrfs(_start+0x2a)[0x555686361f4a]
> Aborted (core dumped)
> mainframe:~ # btrfs rescue chunk-recover /dev/sdb1
> This command still runs, even after 15 hours.

> Is there anything else i could do?

   Well, a good start would be to take a time machine and go back a
day or so and not run all the random recovery tools you can get your
hands on... Most of them are quite specialised (super-recover,
chunk-recover, zero-log). It's fairly unlikely that they've made
things worse, but it's not certain. Certainly zero-log will have
modified the filesystem. I don't know about the other two.

   More productively, it's definitely worth trying to mount with the
-o usebackuproot option. (And -o usebackuproot,ro as well). The
transid verify failure is a small difference in generations, and it's
likely that the older metadata is still there. If that's the case, the
mount with usebackuproot will work, and you should be good to continue
as normal.

   If that doesn't work, then btrfs restore to refresh your backups is
probably the way to go, followed by mkfs and restore from backup.

   Hugo.

-- 
Hugo Mills             | "How deep will this sub go?"
hugo@... carfax.org.uk | "Oh, she'll go all the way to the bottom if we don't
http://carfax.org.uk/  | stop her."
PGP: E2AB1DE4          |                                                  U571

--OGBBnVs4XFPv5LQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZgZY9AAoJEFheFHXiqx3k8WAP/0/0r7s4m4qChkYCmfDifm9U
gGZ3mskfN8gXfhAvnT6EVuXZmV6+qOH8+avU96IbfCrN+jPZRXwS9amAoSnxd6bc
LNXpX+Mn6/ZNpC5rqFKQfV1PDSno6ZhC9l+auC9HTB0WBYY/DpLvm0hu2lVZzN1d
Kk49ulM3mmHIBDv7/9NyVzCTicjy+wp30J22zlh1W/h8m36HPOFs2Dv9SIowHMxZ
R8QSH3wes9rnjK4EELWQUhdr87wAvrKMrMc5OiDqOwoQVlk8158hyfUjYuXf5p3c
M4WHjlGPnRMWS1O2xuYFq3VHDURY5MHELpq4Hh7bmbbw50SIfjJ2wde/4cvTwSst
4I/hkpvMNhUYkxzT75rnuc1sUvOaR+vYsdvm8b1T26vX9/Emt2caY04KRBSpXTkm
wVwY9bx8RuYVSSYVYQuiXVZwCKugeMH3o5D5VlQ7IPRVzilfW0HHKhJlZ5KRSiUr
4nZXowRJP25Nb0VUt+m5S9SFuuxNfeJmwTP1G2tObbmwd9Jz/58pkiDrpZa5jH5p
TTv+oOXsL976QQmoHZcbxyHwqoBnC4BjWDv0lmJ8yBFt8SWdHBc8o2pzKnXfU2SO
jVNkGn1CDHbyat/HcfCSvCGUjGHyx0Q+KVfLtLsXMcd/9Wgs/y68O3xpjQQK2oal
NfEYgB00EmOyR50ZPNX/
=g91w
-----END PGP SIGNATURE-----

--OGBBnVs4XFPv5LQD--
