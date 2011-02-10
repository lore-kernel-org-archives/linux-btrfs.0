From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Corrupt filesystem after power failure
Date: Thu, 10 Feb 2011 12:57:20 +0000
Message-ID: <20110210125720.GA22398@carfax.org.uk>
References: <AANLkTikujRv82iNQ4vNvyGGqDotH_bOxfFCqqnC0ycU2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Cc: linux-btrfs@vger.kernel.org
To: Anil Kumar <anilet@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikujRv82iNQ4vNvyGGqDotH_bOxfFCqqnC0ycU2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2011 at 10:29:41PM +1100, Anil Kumar wrote:
> Full backtrace is at http://pastebin.com/4Re7tVFP

   Pastebins aren't archived. For posterity, here it is:

Feb 10 21:57:36 linux-wuce kernel: [  337.522818] Btrfs loaded
Feb 10 21:57:36 linux-wuce kernel: [  337.538044] device fsid d0485eeb56124=
34f-456b063393781ea9 devid 1 transid 131812 /dev/sda7
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.616905] ------------[ cut here ]------------
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.616919] invalid opcode: 0000 [#1] PREEMPT SMP
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.616926] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:0=
0/PNP0A08:00/device:32/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/voltage_now
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.617148] Stack:
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.617173] Call Trace:
=20
Message from syslogd@linux-wuce at Feb 10 21:57:40 ...
 kernel:[  341.617866] Code: f4 52 96 e0 31 c0 48 81 c4 98 00 00 00 5b 5d 4=
1 5c 41 5d 41 5e 41 5f c3 b8 fe ff ff ff eb e7 0f 0b 0f 0b 0f 0b 0f 0b 0f 0=
b 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 48 81 ec 28 01 00 00 48
Feb 10 21:57:40 linux-wuce kernel: [  341.616905] ------------[ cut here ]-=
-----------
Feb 10 21:57:40 linux-wuce kernel: [  341.616912] kernel BUG at /usr/src/pa=
ckages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/fs/btrfs/tree-log.c:813!
Feb 10 21:57:40 linux-wuce kernel: [  341.616919] invalid opcode: 0000 [#1]=
 PREEMPT SMP
Feb 10 21:57:40 linux-wuce kernel: [  341.616926] last sysfs file: /sys/dev=
ices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:32/PNP0C09:00/PNP0C0A:00/pow=
er_supply/BAT0/voltage_now
Feb 10 21:57:40 linux-wuce kernel: [  341.616932] CPU 0
Feb 10 21:57:40 linux-wuce kernel: [  341.616935] Modules linked in: btrfs =
zlib_deflate crc32c libcrc32c arc4 ecb ip6t_LOG xt_tcpudp xt_pkttype ipt_LO=
G xt_limit af_packet vmsync vmblock snd_pcm_oss snd_mixer_oss snd_seq snd_s=
eq_device edd vboxdrv ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK=
 ipt_REJECT xt_state iptable_raw iptable_filter cpufreq_conservative cpufre=
q_userspace cpufreq_powersave acpi_cpufreq mperf ip6table_mangle nf_conntra=
ck_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6ta=
ble_filter ip6_tables x_tables vfat fat fuse loop dm_mod snd_hda_codec_inte=
lhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm s=
nd_timer snd soundcore sr_mod iTCO_wdt usb_storage r8192se_pci atl1c iTCO_v=
endor_support cdrom sg pcspkr acer_wmi snd_page_alloc i2c_i801 battery ac j=
oydev rfkill wmi ext4 jbd2 crc16 sd_mod i915 ahci libata drm_kms_helper scs=
i_mod drm i2c_algo_bit video intel_agp button fan thermal processor thermal=
_sys [last unloaded: preloadtrace]
Feb 10 21:57:40 linux-wuce kernel: [  341.617054]
Feb 10 21:57:40 linux-wuce kernel: [  341.617060] Pid: 7628, comm: mount No=
t tainted 2.6.34.7-0.7-desktop #1 E7214          /E7214         =20
Feb 10 21:57:40 linux-wuce kernel: [  341.617065] RIP: 0010:[<ffffffffa07d5=
eb3>]  [<ffffffffa07d5eb3>] add_inode_ref+0x4a3/0x4b0 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617094] RSP: 0018:ffff8800b09af8b=
8  EFLAGS: 00010246
Feb 10 21:57:40 linux-wuce kernel: [  341.617098] RAX: 0000000000000000 RBX=
: 0000000000000097 RCX: 0000000000000000
Feb 10 21:57:40 linux-wuce kernel: [  341.617103] RDX: 0000000000000002 RSI=
: ffff880074374820 RDI: ffff8800b0d9a280
Feb 10 21:57:40 linux-wuce kernel: [  341.617107] RBP: 0000000000000002 R08=
: 0000000000000000 R09: ff6dc8d155c6ee03
Feb 10 21:57:40 linux-wuce kernel: [  341.617112] R10: 0000000000000000 R11=
: 0000000000000000 R12: ffff8800b09afb78
Feb 10 21:57:40 linux-wuce kernel: [  341.617116] R13: ffff88007215db50 R14=
: 0000000000000009 R15: ffff8800b09af9d8
Feb 10 21:57:40 linux-wuce kernel: [  341.617121] FS:  00007fb2eddb07e0(000=
0) GS:ffff880001e00000(0000) knlGS:0000000000000000
Feb 10 21:57:40 linux-wuce kernel: [  341.617126] CS:  0010 DS: 0000 ES: 00=
00 CR0: 000000008005003b
Feb 10 21:57:40 linux-wuce kernel: [  341.617131] CR2: 00007f01f58e5020 CR3=
: 00000000b1d7f000 CR4: 00000000000006f0
Feb 10 21:57:40 linux-wuce kernel: [  341.617135] DR0: 0000000000000000 DR1=
: 0000000000000000 DR2: 0000000000000000
Feb 10 21:57:40 linux-wuce kernel: [  341.617140] DR3: 0000000000000000 DR6=
: 00000000ffff0ff0 DR7: 0000000000000400
Feb 10 21:57:40 linux-wuce kernel: [  341.617145] Process mount (pid: 7628,=
 threadinfo ffff8800b09ae000, task ffff8800b1dca540)
Feb 10 21:57:40 linux-wuce kernel: [  341.617148] Stack:
Feb 10 21:57:40 linux-wuce kernel: [  341.617151]  0000000000000000 0000000=
000000000 ffffffffa079a930 ffff88007215db50
Feb 10 21:57:40 linux-wuce kernel: [  341.617158] <0> ffff8800b17fe000 ffff=
88007e035eb0 ffff8800b5991000 0000000000000009
Feb 10 21:57:40 linux-wuce kernel: [  341.617165] <0> ffff8800b09af9b8 ffff=
880074374d78 ffff88007215db50 0000000000000004
Feb 10 21:57:40 linux-wuce kernel: [  341.617173] Call Trace:
Feb 10 21:57:40 linux-wuce kernel: [  341.617309]  [<ffffffffa07d66e8>] rep=
lay_one_buffer+0x2e8/0x3b0 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617421]  [<ffffffffa07d3d85>] wal=
k_down_log_tree+0x375/0x540 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617529]  [<ffffffffa07d4053>] wal=
k_log_tree+0x103/0x280 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617637]  [<ffffffffa07d8223>] btr=
fs_recover_log_trees+0x223/0x310 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617748]  [<ffffffffa079f049>] ope=
n_ctree+0x1269/0x18e0 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617793]  [<ffffffffa077cc0e>] btr=
fs_get_sb+0x31e/0x430 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617809]  [<ffffffff811271e0>] vfs=
_kern_mount+0x80/0x210
Feb 10 21:57:40 linux-wuce kernel: [  341.617819]  [<ffffffff811273e3>] do_=
kern_mount+0x53/0x130
Feb 10 21:57:40 linux-wuce kernel: [  341.617829]  [<ffffffff81141f20>] do_=
mount+0x200/0x250
Feb 10 21:57:40 linux-wuce kernel: [  341.617839]  [<ffffffff8114205a>] sys=
_mount+0x9a/0xf0
Feb 10 21:57:40 linux-wuce kernel: [  341.617851]  [<ffffffff81002ffb>] sys=
tem_call_fastpath+0x16/0x1b
Feb 10 21:57:40 linux-wuce kernel: [  341.617863]  [<00007fb2ed4f0ffa>] 0x7=
fb2ed4f0ffa
Feb 10 21:57:40 linux-wuce kernel: [  341.617866] Code: f4 52 96 e0 31 c0 4=
8 81 c4 98 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 b8 fe ff ff ff eb e7 0=
f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00=
 48 81 ec 28 01 00 00 48
Feb 10 21:57:40 linux-wuce kernel: [  341.617921] RIP  [<ffffffffa07d5eb3>]=
 add_inode_ref+0x4a3/0x4b0 [btrfs]
Feb 10 21:57:40 linux-wuce kernel: [  341.617941]  RSP <ffff8800b09af8b8>
Feb 10 21:57:40 linux-wuce kernel: [  341.617972] ---[ end trace 22bed547f3=
298140 ]---
Feb 10 21:57:45 linux-wuce kernel: [  346.284240] rtl8192se_update_ratr_tab=
le: ratr_index=3D0 ratr_table=3D0x00000ff5
Feb 10 21:58:08 linux-wuce kernel: [  369.474197] SetHwReg8192SE():HW_VAR_A=
C_PARAM eACI:0:a425

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---      =20

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNU+CwIKyzvlFcI40RAncVAKDLsfJXC99gkahLQSy4sjunYNK0GACbBsQx
6SsAH0bQ6fBzKAvI2/lUiaA=
=J/Xb
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
