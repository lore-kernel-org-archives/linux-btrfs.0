Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753986AbcIBOJ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 10:09:26 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <93618edf-7a7b-b55c-4233-a845ad730941@suse.com>
Date: Fri, 2 Sep 2016 10:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <1472676550.8145.1.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="H0XtlOx4dcFTWIaoLdIujAkRT6N0F3O8P"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H0XtlOx4dcFTWIaoLdIujAkRT6N0F3O8P
Content-Type: multipart/mixed; boundary="L3Hji8dxwRoT4XikI9HoVrSXKgDMVawM8";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <93618edf-7a7b-b55c-4233-a845ad730941@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
In-Reply-To: <1472676550.8145.1.camel@gmail.com>

--L3Hji8dxwRoT4XikI9HoVrSXKgDMVawM8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/31/16 4:49 PM, Ronan Arraes Jardim Chagas wrote:
> Hi guys!
>=20
> And the problem happened again. This time, I was only using Mozilla
> Firefox. I could get the very first message after the error. I hope it
> brings more information:

Ok, so I think this is a race that can happen when one thread is
starting a transaction and another thread is committing a transaction
that involves creating a snapshot.

We reserve blocks at the top of start_transaction and that reservation
stays with the root.  In: btrfs_commit_transaction->
create_pending_snapshots-> create_pending_snapshot->
qgroup_account_snapshot-> commit_fs_roots, we clear that reservation
from the root via btrfs_qgroup_free_meta_all, potentially while
start_transaction is waiting to join a new transaction.  Or not.  It can
happen asynchronously, which is the point of having the reservation
prior to that.

So the thing is that this error can only occur if start_transaction
fails after this race occurs.  That, combined with your report that you
were seeing ENOSPC instead of EDQUOT, leads me to believe that this is
just a side effect of whatever is causing you to not hit ENOSPC.  I
expect that you'll see it again -- you just won't see the WARN_ON
anymore since quotas are disabled.  I suspect it's probably the
btrfs_block_rsv_add call immediately after the reservation, but there's
no way to tell without tracing.

-Jeff


> [28039.672199] ------------[ cut here ]------------
> [28039.672253] WARNING: CPU: 3 PID: 31800 at ../fs/btrfs/qgroup.c:2667
> btrfs_qgroup_free_meta+0x88/0x90 [btrfs]
> [28039.672255] Modules linked in: fuse nf_log_ipv6 xt_pkttype
> nf_log_ipv4 nf_log_common xt_LOG xt_limit af_packet iscsi_ibft
> iscsi_boot_sysfs msr ip6t_REJECT nf_reject_ipv6 xt_tcpudp
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4=

> iptable_raw xt_CT nvidia_drm(PO) nvidia_modeset(PO) iptable_filter
> nvidia(PO) ip6table_mangle nf_conntrack_netbios_ns
> nf_conntrack_broadcast drm_kms_helper nf_conntrack_ipv4 drm
> nf_defrag_ipv4 fb_sys_fops snd_hda_codec_hdmi joydev
> snd_hda_codec_realtek ip_tables syscopyarea snd_hda_codec_generic
> xt_conntrack snd_hda_intel sysfillrect intel_rapl sb_edac edac_core
> snd_hda_codec hp_wmi x86_pkg_temp_thermal intel_powerclamp snd_hda_core=

> snd_hwdep nf_conntrack sparse_keymap sysimgblt coretemp kvm_intel kvm
> rfkill irqbypass snd_pcm snd_timer crct10dif_pclmul
> [28039.672305]  e1000e crc32_pclmul ghash_clmulni_intel snd aesni_intel=

> ip6table_filter aes_x86_64 lrw gf128mul glue_helper ablk_helper
> iTCO_wdt iTCO_vendor_support mei_wdt ioatdma pcspkr cryptd ip6_tables
> ptp lpc_ich fjes i2c_i801 dca mfd_core soundcore pps_core shpchp
> tpm_infineon tpm_tis tpm mei_me mei x_tables btrfs xor raid6_pq
> hid_generic usbhid crc32c_intel serio_raw xhci_pci ehci_pci sr_mod
> firewire_ohci xhci_hcd ehci_hcd cdrom firewire_core crc_itu_t isci
> usbcore usb_common libsas ata_generic mpt3sas raid_class
> scsi_transport_sas wmi button sg
> [28039.672373] CPU: 3 PID: 31800 Comm: gnome-terminal- Tainted:
> P        W  O    4.7.1-1-default #1
> [28039.672375] Hardware name: Hewlett-Packard HP Z820 Workstation/158B,=

> BIOS J63 v03.65 12/19/2013
> [28039.672378]  0000000000000000 ffffffff81393104 0000000000000000
> 0000000000000000
> [28039.672382]  ffffffff8107ca1e ffff881008780800 0000000000014000
> ffff881008780800
> [28039.672386]  ffffffffffffffe4 ffff88100b297c00 ffff88053b7e3540
> ffffffffa02c9f58
> [28039.672390] Call Trace:
> [28039.672406]  [<ffffffff8102ed5e>] dump_trace+0x5e/0x320
> [28039.672413]  [<ffffffff8102f12c>] show_stack_log_lvl+0x10c/0x180
> [28039.672419]  [<ffffffff8102fe41>] show_stack+0x21/0x40
> [28039.672425]  [<ffffffff81393104>] dump_stack+0x5c/0x78
> [28039.672430]  [<ffffffff8107ca1e>] __warn+0xbe/0xe0
> [28039.672461]  [<ffffffffa02c9f58>] btrfs_qgroup_free_meta+0x88/0x90
> [btrfs]
> [28039.672492]  [<ffffffffa0261023>] start_transaction+0x3c3/0x4f0
> [btrfs]
> [28039.672521]  [<ffffffffa0271078>] btrfs_create+0x38/0x1d0 [btrfs]
> [28039.672528]  [<ffffffff8121e8fb>] path_openat+0x139b/0x14a0
> [28039.672535]  [<ffffffff8121fb2e>] do_filp_open+0x7e/0xe0
> [28039.672541]  [<ffffffff8120e7a4>] do_sys_open+0x124/0x1f0
> [28039.672547]  [<ffffffff816bb4f6>]
> entry_SYSCALL_64_fastpath+0x1e/0xa8
> [28039.676186] DWARF2 unwinder stuck at
> entry_SYSCALL_64_fastpath+0x1e/0xa8


--=20
Jeff Mahoney
SUSE Labs


--L3Hji8dxwRoT4XikI9HoVrSXKgDMVawM8--

--H0XtlOx4dcFTWIaoLdIujAkRT6N0F3O8P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyYgPAAoJEB57S2MheeWyrFgP/jl+ai0XbcuUVt88yrYyj/dw
48VIDIreJf0FLJVEFRt0Yj9PznjLC2lgX/tbKhTES+9yWPyF3jnovLG55Qqun3RN
7NkA+Mb+/nNdeWUe//YP0Pc24hNYlU5oPyRid6tsbuEPiBm9wvD1vlHsHcx3/3Xx
hgAAsbXizk16kL0Na8yNTz8TSw0A5M/93X5zc+Z5FjxxPKgLXB6krCPFxGB/SskF
aj3HkzJ+M9K3/n7JihQZqxwcooXmS6QMpbvx4QwOisQcSbSh3OT7KLpbcd0IzffO
E77w8b02WdtoMw+2HYMAxSRk5xOhyxykHlVbJxe7Y/ChB/P3CuKoFHd2iBDBRSWl
rTdn5u89zt2g/JHr1aV72f34Ry5ndsO2m4kJCdcK8/p3wKpv46DbYLNWkFiRlACi
IN2HMcYNE/L2u54zmUX+isUK5d3gefATQ+S85VjmMQbA3uwINaVOzwdxa2g3iidL
SjYDu23OXu71/ZqxD9EKbLsRsh0yqfW8DJ5kedGNwsamhbB7guSs/SQad7AjMmDY
+TWw0K99pU+pA3lyUd/EkIt2Tpjf4OWN6ikdFjZbCwr5VWycYIRjza0e5ZeDlfMd
BR/MvUrRxvsMk8dz/6guF6kn3hmDjPI/SibWFxojndxPCrFK549fpuJ/CcpFFyRj
vdguaUXJhgVOmqLUvmnc
=X7Bv
-----END PGP SIGNATURE-----

--H0XtlOx4dcFTWIaoLdIujAkRT6N0F3O8P--
