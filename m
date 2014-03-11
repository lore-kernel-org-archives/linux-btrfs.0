Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21298 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbaCKRNV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 13:13:21 -0400
Message-ID: <531F4419.8010109@fb.com>
Date: Tue, 11 Mar 2014 13:12:57 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG: btrfs send - Incremental backup
References: <2853810.EcqZt5vpol@tethys>
In-Reply-To: <2853810.EcqZt5vpol@tethys>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/08/2014 02:35 AM, Swâmi Petaramesh wrote:
> Hi there,
> 
> I tried to perform an incremental backup as described in 
> https://urldefense.proofpoint.com/v1/url?u=https://btrfs.wiki.kernel.org/index.php/Incremental_Backup&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=b7nDm4ij%2BOl6zWwvbxbx%2BbfpaygHhTjGu8dUoBmQj8E%3D%0A&s=550780a62cfd5275891e088623e3d05c78f828ee008ef9b1cb99957ee3752a5d
> between 2 external USB drives,
> 
> The 1st "btrfs send foo/snap1 | btrfs receive bar" went well,
> although it took 5-6 times the time the same workload takes in
> ZFS.
> 
> Then "btrfs send -v -p foo/snap1 foo/snap2 | btrfs receive bar"
> crashed on me.
> 
> After a reboot and retry, I get a KERNEL BUG again :
> 
> 

Well that's odd, I can't think of how this would happen.  Can pull
down btrfs-next and run that and verify you still hit the BUG_ON?  If
you do please apply this patch and re-run and reply with the dmesg.

http://paste.fedoraproject.org/84393/55775013

This will spit out something like this

cur_ino=<NUMBER>, cmp_key objectid=<OTHER NUMBER>

then I need you to unmount your fs and run

btrfs-debug-tree /dev/whatever > blah.txt

You have about 1.5 gig of metadata so that is going to take a while.
Once that is done you want to go through blah.txt and look for

item <number> key (<OTHER NUMBER FROM ABOVE> EXTENT_DATA <number>)

You need to find all of these entries and copy them down, an example
output looks like this

item 1 key (286 EXTENT_DATA 577536) itemoff 3889 itemsize 53
        extent data disk byte 12763136 nr 4096
        extent data offset 0 nr 4096 ram 4096
        extent compression 0

That is what I'm looking for, you will have multiple of these.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTH0P+AAoJEANb+wAKly3BA+8QAMuccHP7+IIQ62g9WRRgOuBh
Mz/XG+lxpGwbHSwwp7MZPGO10Ee9rJiIJJp/VgHSyNcb/6VHB7HtU1ijifcBFaGj
NkgdTTVHRHl/z17wv2cuiRfCZKOyzXtNvRYGY+lhEfITxeGklUSjwMdCBtG73XqK
gWU3f9hvBjbTtN8Q7RD0O/TRNyrcUK5sEGtfJGM/a0U+avlZpE+Vu89g716BUi5L
F2I5OFRtkVj9WpZLzT6e3PM/5hc0Rg0kgd54fnJoTD34GyNCyqCo1GRhON4DG+ew
NCedZI3aY+/yK9iiaAfcdDpm9332xiVfrJt9tq7EJus/EVyHoDGCUbdN4D2JV+TM
8xapBtcRfy4KExORVtxOpsaamx/xPz53mngN9AH+9mLRO0OZ9xYN5SrN7FCSi/ja
dhdCSR2ndEXmsy3MvcaK0g+d2DntL4uliHb3S6GUlAsDaJuiKoINa4no/FmISc62
uVEbc/cJD0KUKFlUGEcEKst3ja6ecOKFqvutII3t73R7c0N1cvf0yU4WJCTv44CZ
iClBqTI/d23Du6VZpN9hcGSvFap5HiZDO+YCLA/+o5mqMJ2bG8pNQ2cXRzJlSpCN
7zZLAo8Xz0C734F6/SxnoFb+fZATQOz6VX40ZbgL1x931s/jaTJ35c0ZrlBcNSJY
Y8HYBWVEOlXCUkbap7XT
=hcwz
-----END PGP SIGNATURE-----
