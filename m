Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5557C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 20:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98CFA218D3
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 20:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfADUeI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 15:34:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:42368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbfADUeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 15:34:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB4CCAD52;
        Fri,  4 Jan 2019 20:34:05 +0000 (UTC)
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
To:     Giuseppe Della Bianca <giusdbg@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
Date:   Fri, 4 Jan 2019 15:34:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <2282965.574ZSNQ4d8@exnet.gdb.it>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sIxNF1aN9XZfwUPVjGzGgU1dJNdus2zpU"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sIxNF1aN9XZfwUPVjGzGgU1dJNdus2zpU
Content-Type: multipart/mixed; boundary="fEwfuM8rpR1bjps4W4Q0ywJTkLqzRJ7pc";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Giuseppe Della Bianca <giusdbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <067ee226-4636-4ede-1ce7-2bedcc5b4507@suse.com>
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can
 hangs.
References: <2543962.HIiRWmuHEy@exnet.gdb.it>
 <3834bc23-03bf-f6e4-dd56-2cf028469a82@suse.com>
 <2282965.574ZSNQ4d8@exnet.gdb.it>
In-Reply-To: <2282965.574ZSNQ4d8@exnet.gdb.it>

--fEwfuM8rpR1bjps4W4Q0ywJTkLqzRJ7pc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/1/19 11:37 AM, Giuseppe Della Bianca wrote:
> In data gioved=C3=AC 9 agosto 2018 20:48:03 CEST, Jeff Mahoney ha scrit=
to:
>> On 8/9/18 11:15 AM, Giuseppe Della Bianca wrote:
>>> Hi.
>>>
>>> My system:
>>> - Fedora 28 x86_64
>>> - kernel-4.17.7-200
>>> - btrfs-progs-4.15.1-1
>>>
>>> The command 'btrfs subvolume sync -s 2 xyz' hangs in this case:
>>>
>>> - Run command 'btrfs subvolume sync -s 2 xyz' .
>>> - After some time the kernel reports an error on the filesystem.
>>>
>>>   (error that existed before the command was launched.)
>>>
>>> - The filesystem goes in read-only mode.
>>> - The command hangs.
>>
>> Can you provide the output of 'dmesg' and the contents of
>> /proc/<pid>/stack where <pid> is the pid of the btrfs command process?=

>>
>> -Jeff
>=20
> I had the problem again.
> This is the information you asked for:
>=20
> root     17133 17127  0 17:17 ?        00:00:00 btrfs subvolume sync -s=
 2 /
> tmp/tmp.p9SiQ1GnpV
>=20
> cat /proc/17133/stack=20
> [<0>] hrtimer_nanosleep+0xce/0x1e0
> [<0>] __x64_sys_nanosleep+0x77/0xa0
> [<0>] do_syscall_64+0x5b/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff

Ok, so this is it just sleeping between tree searches.

> ...............
> [ 1558.053812] CPU: 0 PID: 16871 Comm: btrfs-cleaner Not tainted=20
> 4.17.19-200.fc28.x86_64 #1
> [ 1558.053815] Hardware name: System manufacturer System Product Name/M=
2N,=20
> BIOS 0902    02/16/2009
> [ 1558.053904] RIP: 0010:__btrfs_free_extent.isra.70+0x782/0xb10 [btrfs=
]
> [ 1558.053907] RSP: 0018:ffffa63985f8fc30 EFLAGS: 00010246
> [ 1558.053912] RAX: 00000000fffffffe RBX: ffff8b71313f8380 RCX:=20
> 0000000000000000
> [ 1558.053914] RDX: 0000000000000000 RSI: 0000000000000000 RDI:=20
> ffff8b711d8ef578
> [ 1558.053916] RBP: 00000011cb804000 R08: ffffa63985f8fba4 R09:=20
> 0000000000000018
> [ 1558.053919] R10: 0000000000000835 R11: 0000000000000000 R12:=20
> ffff8b715f5d4000
> [ 1558.053921] R13: 00000000fffffffe R14: 0000000000000000 R15:=20
> 00000000000005aa
> [ 1558.053925] FS:  0000000000000000(0000) GS:ffff8b717fa00000(0000) kn=
lGS:
> 0000000000000000
> [ 1558.053928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1558.053930] CR2: 00007fdfdffffa08 CR3: 00000000b05b0000 CR4:=20
> 00000000000006f0
> [ 1558.053934] Call Trace:
> [ 1558.054011]  __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
> [ 1558.054011]  ? btrfs_free_tree_block+0x82/0x2c0 [btrfs]
> [ 1558.054011]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
> [ 1558.054011]  btrfs_should_end_transaction+0x3e/0x60 [btrfs]
> [ 1558.054011]  btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
> [ 1558.054011]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> [ 1558.054011]  btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
> [ 1558.054011]  cleaner_kthread+0x129/0x160 [btrfs]
> [ 1558.054011]  kthread+0x112/0x130
> [ 1558.054011]  ? kthread_create_worker_on_cpu+0x70/0x70
> [ 1558.054011]  ret_from_fork+0x35/0x40
> [ 1558.054011] Code: b8 00 00 00 48 8b 7c 24 18 e8 bb b7 ff ff 41 89 c5=
 58 5a=20
> c6 44 24 24 00 45 85 ed 0f 84 97 f9 ff ff 41 83 fd fe 0f 85 63 fc ff ff=
 <0f>=20
> 0b 48 8b 3b e8 84 ca 00 00 4d 89 f8 4c 89 f1 48 89 ea ff b4=20
> [ 1558.054011] ---[ end trace c4eefd1fdc016cea ]---
> [ 1558.054832] BTRFS info (device sda3): leaf 62678286336 gen 6388 tota=
l ptrs=20
> 148 free space 6202 owner 2
> [ 1558.054837]  item 0 key (76427296768 169 0) itemoff 16250 itemsize 3=
3
> [ 1558.054841]          extent refs 1 gen 6256 flags 258
> [ 1558.054844]          ref#0: shared block backref parent 76512641024
> [ 1558.054850]  item 1 key (76427313152 169 0) itemoff 16217 itemsize 3=
3
> [ 1558.054853]          extent refs 1 gen 6256 flags 258
> [ 1558.054854]          ref#0: shared block backref parent 76512641024
>=20
> ]zac[
> ...................................
> ]zac[

This part is actually important since we see below that we're searching
for bytenr 76428623872 which, if present, would be in the cut portion of
your log.

> [ 1558.056504]  item 145 key (76429721600 169 1) itemoff 10004 itemsize=
 33
> [ 1558.056506]          extent refs 1 gen 6303 flags 258
> [ 1558.056508]          ref#0: tree block backref root 1434
> [ 1558.056512]  item 146 key (76429737984 169 0) itemoff 9962 itemsize =
42
> [ 1558.056515]          extent refs 2 gen 6277 flags 258
> [ 1558.056516]          ref#0: shared block backref parent 81665769472
> [ 1558.056519]          ref#1: shared block backref parent 66383904768
> [ 1558.056524]  item 147 key (76429754368 169 0) itemoff 9902 itemsize =
60
> [ 1558.056526]          extent refs 4 gen 6256 flags 258
> [ 1558.056528]          ref#0: shared block backref parent 81731174400
> [ 1558.056531]          ref#1: shared block backref parent 76512641024
> [ 1558.056533]          ref#2: shared block backref parent 76450250752
> [ 1558.056536]          ref#3: shared block backref parent 66397339648
> [ 1558.056544] BTRFS error (device sda3): unable to find ref byte nr=20
> 76428623872 parent 0 root 1450  owner 1 offset 0
> [ 1558.056554] ------------[ cut here ]------------
> [ 1558.056556] BTRFS: Transaction aborted (error -2)
> [ 1558.056718] WARNING: CPU: 0 PID: 16871 at fs/btrfs/extent-tree.c:700=
7=20
> __btrfs_free_extent.isra.70+0x7e2/0xb10 [btrfs]
> [ 1558.056720] Modules linked in: fuse xt_CHECKSUM ipt_MASQUERADE=20
> nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns nf_conntrack_broadca=
st=20
> xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack devlink ip_=
set=20
> nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat=20
> nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_r=
aw=20
> ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_i=
pv4=20
> nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security ebtable=
_filter=20
> ebtables ip6table_filter ip6_tables it87 hwmon_vid sunrpc snd_hda_codec=
_analog=20
> snd_hda_codec_generic snd_hda_codec_hdmi btrfs powernow_k8 amd64_edac_m=
od=20
> edac_mce_amd snd_hda_intel snd_hda_codec kvm_amd xor ccp zstd_compress =

> snd_hda_core snd_hwdep kvm snd_seq snd_seq_device ppdev snd_pcm raid6_p=
q=20
> irqbypass
> [ 1558.056785]  libcrc32c k8temp snd_timer zstd_decompress xxhash i2c_n=
force2=20
> snd asus_atk0110 soundcore shpchp parport_pc parport ata_generic pata_a=
cpi=20
> nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm serio_raw=
=20
> sata_nv forcedeth
> [ 1558.056819] CPU: 0 PID: 16871 Comm: btrfs-cleaner Tainted: G        =
W        =20
> 4.17.19-200.fc28.x86_64 #1
> [ 1558.056821] Hardware name: System manufacturer System Product Name/M=
2N,=20
> BIOS 0902    02/16/2009
> [ 1558.056905] RIP: 0010:__btrfs_free_extent.isra.70+0x7e2/0xb10 [btrfs=
]
> [ 1558.056908] RSP: 0018:ffffa63985f8fc30 EFLAGS: 00010286
> [ 1558.056912] RAX: 0000000000000000 RBX: ffff8b71313f8380 RCX:=20
> 0000000000000006
> [ 1558.056914] RDX: 0000000000000007 RSI: 0000000000000086 RDI:=20
> ffff8b717fa16930
> [ 1558.056916] RBP: 00000011cb804000 R08: 0000000000000038 R09:=20
> 000000000000059a
> [ 1558.056918] R10: 0000000000000000 R11: 0000000000000001 R12:=20
> ffff8b715f5d4000
> [ 1558.056920] R13: 00000000fffffffe R14: 0000000000000000 R15:=20
> 00000000000005aa
> [ 1558.056924] FS:  0000000000000000(0000) GS:ffff8b717fa00000(0000) kn=
lGS:
> 0000000000000000
> [ 1558.056927] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1558.056929] CR2: 00007fdfdffffa08 CR3: 00000000b05b0000 CR4:=20
> 00000000000006f0
> [ 1558.056931] Call Trace:
> [ 1558.057011]  __btrfs_run_delayed_refs+0x216/0x10b0 [btrfs]
> [ 1558.057011]  ? btrfs_free_tree_block+0x82/0x2c0 [btrfs]
> [ 1558.057011]  btrfs_run_delayed_refs+0x78/0x180 [btrfs]
> [ 1558.057011]  btrfs_should_end_transaction+0x3e/0x60 [btrfs]
> [ 1558.057011]  btrfs_drop_snapshot+0x3cf/0x820 [btrfs]
> [ 1558.057011]  ? btree_submit_bio_start+0x20/0x20 [btrfs]
> [ 1558.057011]  btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
> [ 1558.057011]  cleaner_kthread+0x129/0x160 [btrfs]
> [ 1558.057011]  kthread+0x112/0x130
> [ 1558.057011]  ? kthread_create_worker_on_cpu+0x70/0x70
> [ 1558.057011]  ret_from_fork+0x35/0x40
> [ 1558.057011] Code: 10 48 8b 40 50 f0 48 0f ba a8 30 23 00 00 02 0f 92=
 c0 41=20
> 59 84 c0 0f 85 cc a4 09 00 44 89 ee 48 c7 c7 98 9e 75 c0 e8 58 33 a0 e7=
 <0f>=20
> 0b e9 b6 a4 09 00 48 89 df e8 bf 0c ff ff 49 8b 74 24 28 4d=20
> [ 1558.057011] ---[ end trace c4eefd1fdc016ceb ]---
> [ 1558.057734] BTRFS: error (device sda3) in __btrfs_free_extent:7007: =

> errno=3D-2 No such entry
> [ 1558.057742] BTRFS info (device sda3): forced readonly
> [ 1558.057757] BTRFS: error (device sda3) in btrfs_run_delayed_refs:307=
6:=20
> errno=3D-2 No such entry

This is the more important part.  The file system has gone read-only due
to a missing extent backref.  This is corruption.

It also means that the subvolume is never going to disappear during this
mount and 'btrfs subvol sync' will wait forever.

-Jeff
--=20
Jeff Mahoney
SUSE Labs



--fEwfuM8rpR1bjps4W4Q0ywJTkLqzRJ7pc--

--sIxNF1aN9XZfwUPVjGzGgU1dJNdus2zpU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlwvwzwACgkQHntLYyF5
5bLShQ//Xo23JkOJhiAE5OhwJlHcOEZJZHgk707tZ/iXcn8E/OQgP2wZJdCS+sFW
kmDNb60h8evsJ4eOpHcGRCe9Qmjxi9InnTONjuhX9SzjdG3a7TUaR3wNEQgiJHFP
7hewIGN4csW8gZIDPJV8nUCpdBjI+rXDWgkgxo0U+eJrxNjDOmHvF0HkmygQdHYx
YIQoRGXpE6+3Bk9M5mGrrQiqlWRjesa5n0Yc/xmjCowQwvXZhIUZeS+DdJKNbER/
AiI7c8/WYJoZ3rgkL8A9/dLnuySzK7dClu8QnMOCDrAbdFxEoJZMcRrs7L7E5SSt
g9hn3UhMxFUMgw+3/UG81NPN5ho+uANoXenVI197eGvZuylo3yzxQUhXwOPatMXw
IUu/Bo6FG4FUlHUxEyZy9uvlzg3S15M5D3KFYhAC98kxzF6OLv8lOiI3c7kx4k9u
FqqXaY1CINhcnKWD5wzRGwttGK38ZOrqbPcQDnv45i60cun7qcEtbQoix/sasZSO
6cWBMpYaA6mZdl9R1TBNGO9nfYaqb9ueVfMnJ9cjhH0s6cfKMqmKCPwpDnAQMthm
4/RdLV34pZDI94wgnCBNaGesbEcr9iMnyhhAISnsgEb3n2ma99QTqmNoxJAasA4S
mEL/zBIZZd+ZzoWQ8ewrEJmKeUHiQ/YqZHd71bxzDWdfiIN2o6Q=
=NQvz
-----END PGP SIGNATURE-----

--sIxNF1aN9XZfwUPVjGzGgU1dJNdus2zpU--
