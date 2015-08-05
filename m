Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from baraddur.eliasprobst.eu ([78.47.157.163]:42402 "EHLO
	eliasprobst.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbHEId5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 04:33:57 -0400
To: linux-btrfs@vger.kernel.org
Date: Wed, 05 Aug 2015 10:28:05 +0200
Subject: Lockup in BTRFS_IOC_CLONE/Kernel 4.2.0-rc5
Message-ID: <55C1C915.4070106@eliasprobst.eu>
From: "Elias Probst" <mail@eliasprobst.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="XEKnqFi1ls27T7xbI395r1Eh4sdnveBOF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XEKnqFi1ls27T7xbI395r1Eh4sdnveBOF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I can reproduce a hard btrfs lockup (process issuing the ioctl() is in
D-state, same goes for btrfs-transacti process) on Kernel 4.2.0-rc5.

I had the same issue on 4.1, so it's unlikely a regression introduced in
4.2.

## With the following steps, I can reproduce the problem:

1. Create a new clean btrfs volume for /var/lib/machines
machinectl set-limit 6G

2. Paste this to /tmp/yum.conf
[main]
reposdir=3D/dev/null
gpgcheck=3D0
logfile=3D/var/log/yum.log
installroot=3D/var/lib/machines/centos7.1-base
assumeyes=3D1

[base]
name=3DCentOS 7.1.1503 - x86_64
baseurl=3Dhttp://mirror.centos.org/centos/7.1.1503/os/x86_64/
enabled=3D1

3. Bootstrap a CentOS 7.1 base image
/usr/bin/yum -c /tmp/yum.conf groupinstall Base

4. Start an ephemeral systemd-nspawn container based on 'centos7.1-base'
strace -o /tmp/systemd-nspawn.out -s 500 -f systemd-nspawn -xbD
/var/lib/machines/centos7.1-base/


`systemd-nspawn` will now just hang forever.
I couldn't come up yet with a shorter/more low-level way to reproduce thi=
s as I lack quite a bit of btrfs experience.

## Results:

- Last 'strace' lines
6095  fchown(16, 0, 0)                  =3D 0
6095  fchmod(16, 0755)                  =3D 0
6095  utimensat(16, NULL, {{1402362275, 0}, {1438761285, 819041906}}, 0) =
=3D 0
6095  flistxattr(15, "", 100)           =3D 0
6095  getdents(15, /* 3 entries */, 32768) =3D 80
6095  newfstatat(15, "coreutils.mo", {st_mode=3DS_IFREG|0644, st_size=3D3=
57263, ...}, AT_SYMLINK_NOFOLLOW) =3D 0
6095  openat(15, "coreutils.mo", O_RDONLY|O_NOCTTY|O_NOFOLLOW|O_CLOEXEC) =
=3D 17
6095  openat(16, "coreutils.mo", O_WRONLY|O_CREAT|O_EXCL|O_NOCTTY|O_NOFOL=
LOW|O_CLOEXEC, 0644) =3D 18
6095  fstat(18, {st_mode=3DS_IFREG|0644, st_size=3D0, ...}) =3D 0
6095  ioctl(18, BTRFS_IOC_CLONE

- call trace in Kernel journal:
Aug 05 10:10:03 moria kernel: INFO: task btrfs-transacti:4175 blocked for=
 more than 120 seconds.
Aug 05 10:10:03 moria kernel:       Tainted: G           O    4.2.0-rc5 #=
2
Aug 05 10:10:03 moria kernel: "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
Aug 05 10:10:03 moria kernel: btrfs-transacti D ffff8800b13279f8     0  4=
175      2 0x00080080
Aug 05 10:10:03 moria kernel:  ffff8800b13279f8 ffff88018fd3a380 ffff8800=
ab4521c0 0000000000000246
Aug 05 10:10:03 moria kernel:  ffff8800b1328000 ffff88018d5c8518 ffff8801=
8debdba0 ffff880232d64990
Aug 05 10:10:03 moria kernel:  0000000000000197 ffff8800b1327a18 ffffffff=
86999201 0000000000000000
Aug 05 10:10:03 moria kernel: Call Trace:
Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] schedule+0x74/0x83
Aug 05 10:10:03 moria kernel:  [<ffffffff863ef8f0>] btrfs_tree_lock+0xa7/=
0x1b7
Aug 05 10:10:03 moria kernel:  [<ffffffff86137ed7>] ? wait_woken+0x74/0x7=
4
Aug 05 10:10:03 moria kernel:  [<ffffffff8639d30f>] push_leaf_right+0x9a/=
0x19f
Aug 05 10:10:03 moria kernel:  [<ffffffff8639dd9b>] split_leaf+0x100/0x63=
f
Aug 05 10:10:03 moria kernel:  [<ffffffff86398f09>] ? leaf_space_used+0xb=
b/0xea
Aug 05 10:10:03 moria kernel:  [<ffffffff863efa61>] ? btrfs_set_lock_bloc=
king_rw+0x52/0x95
Aug 05 10:10:03 moria kernel:  [<ffffffff8639ea46>] btrfs_search_slot+0x7=
6c/0x8b3
Aug 05 10:10:03 moria kernel:  [<ffffffff863a0107>] btrfs_insert_empty_it=
ems+0x58/0xa3
Aug 05 10:10:03 moria kernel:  [<ffffffff8640805a>] btrfs_insert_delayed_=
items+0x7f/0x3bb
Aug 05 10:10:03 moria kernel:  [<ffffffff8640842e>] __btrfs_run_delayed_i=
tems+0x98/0x1c0
Aug 05 10:10:03 moria kernel:  [<ffffffff86408739>] btrfs_run_delayed_ite=
ms+0xc/0xe
Aug 05 10:10:03 moria kernel:  [<ffffffff863bdc50>] btrfs_commit_transact=
ion+0x298/0xb66
Aug 05 10:10:03 moria kernel:  [<ffffffff863be8d0>] ? start_transaction+0=
x3b2/0x535
Aug 05 10:10:03 moria kernel:  [<ffffffff863b9cd9>] transaction_kthread+0=
x100/0x1d6
Aug 05 10:10:03 moria kernel:  [<ffffffff863b9bd9>] ? btrfs_cleanup_trans=
action+0x49f/0x49f
Aug 05 10:10:03 moria kernel:  [<ffffffff8611eca9>] kthread+0xcd/0xd5
Aug 05 10:10:03 moria kernel:  [<ffffffff8611ebdc>] ? kthread_create_on_n=
ode+0x17d/0x17d
Aug 05 10:10:03 moria kernel:  [<ffffffff8699d29f>] ret_from_fork+0x3f/0x=
70
Aug 05 10:10:03 moria kernel:  [<ffffffff8611ebdc>] ? kthread_create_on_n=
ode+0x17d/0x17d
Aug 05 10:10:03 moria kernel: INFO: task systemd-nspawn:6095 blocked for =
more than 120 seconds.
Aug 05 10:10:03 moria kernel:       Tainted: G           O    4.2.0-rc5 #=
2
Aug 05 10:10:03 moria kernel: "echo 0 > /proc/sys/kernel/hung_task_timeou=
t_secs" disables this message.
Aug 05 10:10:03 moria kernel: systemd-nspawn  D ffff88019f3e3668     0  6=
095   6090 0x00080083
Aug 05 10:10:03 moria kernel:  ffff88019f3e3668 ffffffff86e5d480 ffff8801=
8fd3a380 0000000000000246
Aug 05 10:10:03 moria kernel:  ffff88019f3e4000 ffff88018debdc08 ffff8801=
8fd3a380 ffff88019f3e36b8
Aug 05 10:10:03 moria kernel:  ffff88018fd3a380 ffff88019f3e3688 ffffffff=
86999201 0000000000000000
Aug 05 10:10:03 moria kernel: Call Trace:
Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] schedule+0x74/0x83
Aug 05 10:10:03 moria kernel:  [<ffffffff863ef64c>] btrfs_tree_read_lock+=
0xc0/0xea
Aug 05 10:10:03 moria kernel:  [<ffffffff86137ed7>] ? wait_woken+0x74/0x7=
4
Aug 05 10:10:03 moria kernel:  [<ffffffff8639f0a7>] btrfs_search_old_slot=
+0x51a/0x810
Aug 05 10:10:03 moria kernel:  [<ffffffff863a129b>] btrfs_next_old_leaf+0=
xdf/0x3ce
Aug 05 10:10:03 moria kernel:  [<ffffffff86413a00>] ? ulist_add_merge+0x1=
b/0x127
Aug 05 10:10:03 moria kernel:  [<ffffffff86411688>] __resolve_indirect_re=
fs+0x62a/0x667
Aug 05 10:10:03 moria kernel:  [<ffffffff863ef546>] ? btrfs_clear_lock_bl=
ocking_rw+0x78/0xbe
Aug 05 10:10:03 moria kernel:  [<ffffffff864122d3>] find_parent_nodes+0xa=
f3/0xfc6
Aug 05 10:10:03 moria kernel:  [<ffffffff86412838>] __btrfs_find_all_root=
s+0x92/0xf0
Aug 05 10:10:03 moria kernel:  [<ffffffff864128f2>] btrfs_find_all_roots+=
0x45/0x65
Aug 05 10:10:03 moria kernel:  [<ffffffff8639a75b>] ? btrfs_get_tree_mod_=
seq+0x2b/0x88
Aug 05 10:10:03 moria kernel:  [<ffffffff863e852e>] check_ref+0x64/0xc4
Aug 05 10:10:03 moria kernel:  [<ffffffff863e9e01>] btrfs_clone+0x66e/0xb=
5d
Aug 05 10:10:03 moria kernel:  [<ffffffff863ea77f>] btrfs_ioctl_clone+0x4=
8f/0x5bb
Aug 05 10:10:03 moria kernel:  [<ffffffff86048a68>] ? native_sched_clock+=
0x28/0x77
Aug 05 10:10:03 moria kernel:  [<ffffffff863ed9b0>] btrfs_ioctl+0xabc/0x2=
5cb
Aug 05 10:10:03 moria kernel:  [<ffffffff86998f25>] ? __schedule+0x590/0x=
7f8
Aug 05 10:10:03 moria kernel:  [<ffffffff86999201>] ? schedule+0x74/0x83
Aug 05 10:10:03 moria kernel:  [<ffffffff86111b2e>] ? ptrace_stop+0x227/0=
x236
Aug 05 10:10:03 moria kernel:  [<ffffffff8612ba10>] ? account_system_time=
+0xf2/0x10f
Aug 05 10:10:03 moria kernel:  [<ffffffff86111bbc>] ? ptrace_do_notify+0x=
7f/0x8c
Aug 05 10:10:03 moria kernel:  [<ffffffff861fff2e>] do_vfs_ioctl+0x369/0x=
423
Aug 05 10:10:03 moria kernel:  [<ffffffff8617c29f>] ? __audit_syscall_ent=
ry+0xba/0xdc
Aug 05 10:10:03 moria kernel:  [<ffffffff86200021>] SyS_ioctl+0x39/0x61
Aug 05 10:10:03 moria kernel:  [<ffffffff8699cfd5>] tracesys_phase2+0x84/=
0x89


--XEKnqFi1ls27T7xbI395r1Eh4sdnveBOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJVwckfAAoJEILFEoJlEbrbDi8QAJy94OiP6Ykda6foFqlXyOEB
HPVwriyHQOYE0HIuV2eiJYX5hBAoNtDEiji68C+U2zrSBv0hzr21BDC37i/BHx7J
TARr8VPkOQWnWN26JNeid7qly7y/h4szvx5RrxAMfT9hzYfDqo/HktTzufJ8bDtR
am2uiReA7sZRXnvZDthhjWT5CvFk2+aLkSOg0DmKXxsQvEwIw96c8fQXpsnTrRLG
9CypYlWQdDvdiUL56IR70OyPHn3gntjpJ1IqxGcGFIQVCd4UUclgkY6vpKcMEeT+
r5vLioGP111WSCGzIURq61l961CqAAqGfMOy+XLRX7PTspNg7CtR7kaeMLY7CA1P
ne50nmi9D9H2mirxeyg6L/a22kpAZEOYuh03hjSZ9sELELJMLuKGRxhg8yiNLKAX
AMrFY7dTcYkuPjqwWilRsYd99Wf1nO0KhKBrXafiiOAJKJh9k8tETw1s1rSYU+2U
3Ziz/AhNTwrxQQN7rlnFNhrbD68SlY+tU7F/r9AX5EaufrQLbTfhZFofUdPvxUbC
XyhEwG9Dcplg0m/Wdh6KTTMCZonUz2E6bF5+l+bbeJY7eqJtg7wZVBg4+Oxz34/G
dEjXVI81IrEE20+CNa5zB+L9LF3ZPKQIRrZ7fZYBrUkpAzwtPJbskSgEfaq9BnXl
W9IPI29ePWM30XB8P93h
=YcCS
-----END PGP SIGNATURE-----

--XEKnqFi1ls27T7xbI395r1Eh4sdnveBOF--
