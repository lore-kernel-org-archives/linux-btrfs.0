Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47776 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbcCDA13 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 19:27:29 -0500
Date: Fri, 4 Mar 2016 00:27:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: niya levi <niyalevi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: problems mounting subvolumes using nfs
Message-ID: <20160304002727.GG27786@carfax.org.uk>
References: <56D8D3C4.3030308@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="APlYHCtpeOhspHkB"
In-Reply-To: <56D8D3C4.3030308@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--APlYHCtpeOhspHkB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 04, 2016 at 12:16:04AM +0000, niya levi wrote:
> 
> i have a luks encrypted btrfs fileserver and have created this subvolume
> structure on the server for my samba shares
> 
> samba                    top level
> ---|home                subvolume
> ---|---|gen                subvolume
> ---|---|---|s4user        subvolume
> ---|profile                subvolume
> ---|print_driver        subvolume
> 
> these are my export configurations
> 
> cat /etc/exports
> # /etc/exports - exports(5) - directories exported to NFS clients
> #
> /samba/home      
> 192.168.1.0/24(rw,no_subtree_check,no_root_squash,sync,sec=none:sys:krb5:krb5i:krb5p,insecure)
> /samba/profiles  
> 192.168.1.0/24(rw,no_subtree_check,no_root_squash,sync,sec=none:sys:krb5:krb5i:krb5p,insecure)
> /samba/Printer_drivers  
> 192.168.1.0/24(rw,no_subtree_check,no_root_squash,sync,sec=none:sys:krb5:krb5i:krb5p,insecure)
> 
> cat /etc/fstab
> # /etc/fstab: static file system information
> #
> # encryped samba home partition
> /dev/mapper/samba_crypt  /samba     btrfs    defaults        0       0
> 
> # mount
> /dev/mapper/samba_crypt on /samba type btrfs (rw,relatime,space_cache)
> 
> # exportfs
> exportfs
> /samba/home               192.168.1.0/24
> /samba/profiles           192.168.1.0/24
> /samba/Printer_drivers    192.168.1.0/24

   I don't know if this is related to your problem, but one thing you
need to do here is specify different fsid fields for each exported
subvol on the same FS. If you don't, NFS can't tell which subvol was
intended, and will export the same subvol for each one. So:

/samba/home               -fsid=0x1729 192.168.1.0/24
/samba/profiles           -fsid=0x172a 192.168.1.0/24
/samba/Printer_drivers    -fsid=0x172b 192.168.1.0/24

   I suspect that you may not be able to export nested subvols, either
(which is probably your conclusion below). I haven't actually tested
that theory, though. (I don't tend to use nested subvols at all;
they're more trouble than they're worth in most cases, in my
experience).

   I would suggest mounting, or bind-mounting, to /samba/$whatever
every individual subvol that you want to be able to export, and
putting in a separate export entry for it in /etc/exports.

   Hugo.

> # btrfs subvolume list /samba
> ID 257 gen 266 top level 5 path Printer_drivers
> ID 258 gen 292 top level 5 path home
> ID 259 gen 291 top level 5 path profiles
> ID 261 gen 295 top level 258 path home/.snapshots
> ID 262 gen 28 top level 261 path home/.snapshots/1/snapshot
> ID 267 gen 262 top level 258 path home/gen
> ID 268 gen 293 top level 267 path home/gen/s4user
> ID 275 gen 61 top level 261 path home/.snapshots/12/snapshot
> ID 278 gen 295 top level 268 path home/gen/s4user/.snapshots
> ID 280 gen 72 top level 278 path home/gen/s4user/.snapshots/1/snapshot
> ID 321 gen 143 top level 261 path home/.snapshots/36/snapshot
> ID 322 gen 144 top level 278 path home/gen/s4user/.snapshots/22/snapshot
> 
> on the server using autofs
> i can mount /samba/profile and /samba/print_driver
> i can also mount /samba/home and enter the gen and gen/s4user subvolumes
> i cannot mount /samba/home/gen or /samba/home/gen/s4user
> from what i can gather the problem is todo with the subvolume layout of
> /samba/home/gen and /samba/home/gen/s4user or the export of /samba/home
> or with the automount specification in auto.master or auto.samba_home
> any pointers to getting the mounts to work would be appreciated
> 
> # uname -a
> Linux tardis 4.1.18-1-ARCH #1 SMP Sat Feb 20 17:48:11 MST 2016 armv7l
> GNU/Linux
> 
> # btrfs --version
> btrfs-progs v4.4
> 
> # btrfs fi show
> Label: 'smbhome'  uuid: 1cec48c5-a2c5-490f-8e9b-63f325721169
>         Total devices 1 FS bytes used 1.39MiB
>         devid    1 size 149.05GiB used 2.02GiB path /dev/mapper/samba_crypt
> 
> # btrfs fi df /samba
> Data, single: total=8.00MiB, used=256.00KiB
> System, DUP: total=8.00MiB, used=16.00KiB
> Metadata, DUP: total=1.00GiB, used=1.12MiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> cat auto.master
> /samba/home       /etc/autofs/auto.samba_home
> /samba/profiles       /etc/autofs/auto_profiles
> /-     /etc/autofs/auto.prindrvs
> +dir:/etc/autofs/auto.master.d
> +auto.master
> 
> # cat auto_profiles
> * -fstype=nfs,rw,nosuid,hard,sec=sys,vers=3
> my.server.my.domain:/samba/profiles/&      
> 
> # cat auto.prindrvs
> /samba/Printer_drivers -fstype=nfs,rw,nosuid,hard,sec=sys,vers=3
> my.server.my.domain:/samba/Printer_drivers      
> 
> # cat auto.samba_home
> * -fstype=nfs,rw,nosuid,hard,vers=3,sec=sys 
> my.server.my.domain:/samba/home/&
> 
> # ls -al /samba/home/gen/s4user
> ls: cannot access /samba/home/gen/s4user: No such file or directory
> 
> # journalctl -f -u autofs
> handle_packet: type = 3
> handle_packet_missing_indirect: token 53, name gen, request pid 22842
> attempting to mount entry /samba/home/gen
> lookup_mount: lookup(file): looking up gen
> lookup_mount: lookup(file): gen ->
> -fstype=nfs,rw,nosuid,hard,vers=3,sec=sys  my.server.my.domain:/samba/home/&
> parse_mount: parse(sun): expanded entry:
> -fstype=nfs,rw,nosuid,hard,vers=3,sec=sys 
> my.server.my.domain:/samba/home/gen
> parse_mount: parse(sun): gathered options:
> fstype=nfs,rw,nosuid,hard,vers=3,sec=sys
> parse_mount: parse(sun): dequote("my.server.my.domain:/samba/home/gen")
> -> my.server.my.domain:/samba/home/gen
> parse_mount: parse(sun): core of entry:
> options=fstype=nfs,rw,nosuid,hard,vers=3,sec=sys,
> loc=my.server.my.domain:/samba/home/gen
> sun_mount: parse(sun): mounting root /samba/home, mountpoint gen, what
> my.server.my.domain:/samba/home/gen, fstype nfs, options
> rw,nosuid,hard,vers=3,sec=sys
> mount_mount: mount(nfs): root=/samba/home name=gen
> what=my.server.my.domain:/samba/home/gen, fstype=nfs,
> options=rw,nosuid,hard,vers=3,sec=sys
> mount_mount: mount(nfs): nfs options="rw,nosuid,hard,vers=3,sec=sys",
> nobind=0, nosymlink=0, ro=0
> mount_mount: mount(nfs): calling mkdir_path /samba/home/gen
> mount_mount: mount(nfs): calling mount -t nfs -s -o
> rw,nosuid,hard,vers=3,sec=sys my.server.my.domain:/samba/home/gen
> /samba/home/gen
> >> mount.nfs: access denied by server while mounting
> my.server.my.domain:/samba/home/gen
> mount(nfs): nfs: mount failure my.server.my.domain:/samba/home/gen on
> /samba/home/gen
> dev_ioctl_send_fail: token = 53
> failed to mount /samba/home/gen
> st_expire: state 1 path /samba/home
> expire_proc: exp_proc = 1960834160 path /samba/home
> expire_cleanup: got thid 1960834160 path /samba/home stat 0
> expire_cleanup: sigchld: exp 1960834160 finished, switching from 2 to 1
> st_ready: st_ready(): state = 2 path /samba/home
> st_expire: state 1 path /-
> expire_proc: exp_proc = 1960834160 path /-
> expire_cleanup: got thid 1960834160 path /- stat 0
> expire_cleanup: sigchld: exp 1960834160 finished, switching from 2 to 1
> st_ready: st_ready(): state = 2 path /-
> 
> Shadrock
> 
> 

-- 
Hugo Mills             | My karma has run over my dogma.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--APlYHCtpeOhspHkB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW2NZvAAoJEFheFHXiqx3ke50P/254duzzs/3RpUi2AsKcbC3y
67KSKKNIm9wHQN6qdeDtgfztSarNdMBalVKHmNt0nRAnqxsl0DLUkGaB6g4E80zc
DbKYolkw93swxcYdoNe8uM7CiNkw+R3G7jTqMuBXmIHTFaYyEEo7ze4hLoJtMGyp
f48UrxWfm7L2uqk+r3TO3UvckhghPaBceFidQCy8Eykm98MNk0ISniHRpkgM441S
rRzmIKXx8cQhco325MQrG1DNLguPYrO9LDhBrGf7RczkE99wPnrcK5ilZXm8HWSQ
L5gSBR50Utbi2KMX65EUB6XP7g/NBLwiJRsCABRxuOUUNALbOY3t912LrWVoTJJK
o0kCirCu8xRfZR+FwEeKLPxkY6OWxZGC1a5ssfR1Df2bi/GoVciX/kn6FtGz9z3V
89/ox4ycURmsDxfnFl8yF56hpi7TYdONHgiXOHalt9AVkQxNrb0hXfApKeM2N92z
iW+40O8VUD/hTa6UKEyuN4BFZ+jtl8MPuzXwM9DUV36LT7Z/VjZJIEvAmIQpMhrt
LaFtrOt4excJd+MY2m6wY4S5ak5AzYDs7an8/FgNuOSdwj+sPp3ZdegPqhnzxmP1
F20UJD1B4e/Vu0o9Y0fHfs2o4FjQkfz+2uq3lIW8iLUSJqKQHckB3ka67ww6BDIJ
enkK50/GN0KkPvrm5UoA
=0Lkb
-----END PGP SIGNATURE-----

--APlYHCtpeOhspHkB--
