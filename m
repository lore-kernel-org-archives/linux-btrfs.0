Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44993 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaD0QaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 12:30:24 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so4184315eek.9
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 09:30:22 -0700 (PDT)
Received: from [192.168.7.195] (5ED60B40.cm-7-7a.dynamic.ziggo.nl. [94.214.11.64])
        by mx.google.com with ESMTPSA id 44sm42848430eek.30.2014.04.27.09.30.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 27 Apr 2014 09:30:21 -0700 (PDT)
From: Jaap Pieroen <jaap@pieroen.nl>
Content-Type: multipart/mixed; boundary="Apple-Mail=_FC1A509D-64E2-4B2E-8C86-6241DF2171BB"
Subject: "kernel BUG at /home/apw/COD/linux/fs/btrfs/extent_io.c:2116!" when deleting device or balancing filesystem.
Message-Id: <C25AA8A9-30B0-4D00-80B5-B681D93D67A3@pieroen.nl>
Date: Sun, 27 Apr 2014 18:30:19 +0200
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_FC1A509D-64E2-4B2E-8C86-6241DF2171BB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hello,

When I try to delete a device from my btrfs filesystem I always get the =
following kernel bug error:
	[  809.161020] kernel BUG at =
/home/apw/COD/linux/fs/btrfs/extent_io.c:2116!
	[  809.166761] invalid opcode: 0000 [#3] SMP
See attached log file for more details. I=92m trying to delete the =
device /dev/sdb from my filesystem.

Steps I tried so far are:
1. mount with the clear_cache option
2. balance the filesystem (results in the same kernel error)
3. scrub the filesystem
4. btrfsck =97repair

During scrubbing and btrfsck some error where found and fixed. But I =
think these where error caused by system lockups during copying data to =
the new btrfs filesystem. These lockups where caused by an extraordinary =
amount of hard links, since I was using rsnapshot to create hourly =
snapshots on my old filesystem that I am migrating towards btrfs. =
Removing these hard links solved the lockup problems.

Something I also noted was that after the btrfsck run, the command =
=91btrfs fi show=92 reported =93devid    4 size 0.0GiB used 98.00GiB =
path /dev/sdb=94 (mind the 0.0GB).

I=92m ready to run any diagnostics necessary, but the filesystem is 4.7T =
so it won=92t be able to provide an image.

System details:
	$ uname -a
	Linux nasbak 3.14.1-031401-generic #201404141220 SMP Mon Apr 14 =
16:21:48 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
	$ btrfs --version
	Btrfs v3.12
	$ sudo btrfs fi show
	Label: btrfs_storage  uuid: 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
		Total devices 6 FS bytes used 4.57TiB
		devid    1 size 1.82TiB used 1.32TiB path /dev/sde
		devid    2 size 1.82TiB used 1.32TiB path /dev/sdf
		devid    3 size 1.82TiB used 1.32TiB path /dev/sdg
		devid    4 size 931.51GiB used 88.00GiB path /dev/sdb
		devid    6 size 2.73TiB used 947.03GiB path /dev/sdh
		devid    7 size 2.73TiB used 947.03GiB path /dev/sdi
=09
	Btrfs v3.12


--Apple-Mail=_FC1A509D-64E2-4B2E-8C86-6241DF2171BB
Content-Disposition: attachment;
	filename=dmesg.log
Content-Type: application/octet-stream;
	name="dmesg.log"
Content-Transfer-Encoding: quoted-printable

=0A=0A=0A[=20=20422.944579]=20BTRFS=20info=20(device=20sde):=20=
relocating=20block=20group=209377568325632=20flags=20129=0A[=20=20=
453.928463]=20BTRFS=20info=20(device=20sde):=20found=201355=20extents=0A=
[=20=20460.766319]=20BTRFS=20info=20(device=20sde):=20found=201334=20=
extents=0A[=20=20462.216853]=20BTRFS=20info=20(device=20sde):=20=
relocating=20block=20group=209385118072832=20flags=20129=0A[=20=20=
476.936402]=20BTRFS=20info=20(device=20sde):=20found=20255=20extents=0A[=20=
=20482.668960]=20BTRFS=20info=20(device=20sde):=20found=20255=20extents=0A=
[=20=20485.991575]=20BTRFS=20info=20(device=20sde):=20relocating=20block=20=
group=209366830907392=20flags=20129=0A[=20=20519.821215]=20BTRFS=20info=20=
(device=20sde):=20found=202609=20extents=0A[=20=20528.389294]=20BTRFS=20=
info=20(device=20sde):=20found=202609=20extents=0A[=20=20530.482818]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9361462198272=20flags=20129=0A[=20=20570.354624]=20BTRFS=20info=20=
(device=20sde):=20found=204829=20extents=0A[=20=20577.648311]=20BTRFS=20=
info=20(device=20sde):=20found=204829=20extents=0A[=20=20579.649814]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9356093489152=20flags=20129=0A[=20=20612.162145]=20BTRFS=20info=20=
(device=20sde):=20found=202314=20extents=0A[=20=20620.911102]=20BTRFS=20=
info=20(device=20sde):=20found=202314=20extents=0A[=20=20623.604673]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9350724780032=20flags=20129=0A[=20=20661.613872]=20BTRFS=20info=20=
(device=20sde):=20found=202621=20extents=0A[=20=20666.546872]=20BTRFS=20=
info=20(device=20sde):=20found=202621=20extents=0A[=20=20667.538488]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9345356070912=20flags=20129=0A[=20=20699.461698]=20BTRFS=20info=20=
(device=20sde):=20found=201972=20extents=0A[=20=20706.284568]=20BTRFS=20=
info=20(device=20sde):=20found=201972=20extents=0A[=20=20707.447620]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9339987361792=20flags=20129=0A[=20=20735.910785]=20BTRFS=20info=20=
(device=20sde):=20found=20321=20extents=0A[=20=20741.392166]=20BTRFS=20=
info=20(device=20sde):=20found=20321=20extents=0A[=20=20742.397313]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9334618652672=20flags=20129=0A[=20=20769.054315]=20BTRFS=20info=20=
(device=20sde):=20found=20312=20extents=0A[=20=20774.363056]=20BTRFS=20=
info=20(device=20sde):=20found=20312=20extents=0A[=20=20775.324702]=20=
BTRFS=20info=20(device=20sde):=20relocating=20block=20group=20=
9329249943552=20flags=20129=0A[=20=20802.202409]=20BTRFS=20info=20=
(device=20sde):=20found=20186=20extents[=20=20807.019172]=20BTRFS=20info=20=
(device=20sde):=20found=20186=20extents=0A[=20=20807.969960]=20BTRFS=20=
info=20(device=20sde):=20relocating=20block=20group=20286718427136=20=
flags=20129=0A[=20=20808.869348]=20BTRFS=20info=20(device=20sde):=20csum=20=
failed=20ino=20267=20off=20107151360=20csum=202668642085=20expected=20=
csum=2070570527=0A[=20=20808.869458]=20BTRFS=20info=20(device=20sde):=20=
csum=20failed=20ino=20267=20off=20107155456=20csum=202021857215=20=
expected=20csum=2070570527=0A[=20=20808.869499]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107159552=20csum=203630881373=20=
expected=20csum=2070570527=0A[=20=20808.869533]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107163648=20csum=201855918840=20=
expected=20csum=2070570527=0A[=20=20808.869568]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107167744=20csum=20623206042=20=
expected=20csum=2070570527=0A[=20=20808.869601]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107171840=20csum=203397419927=20=
expected=20csum=2070570527=0A[=20=20808.869632]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107175936=20csum=202086086655=20=
expected=20csum=2070570527=0A[=20=20808.869664]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107180032=20csum=203838267325=20=
expected=20csum=2070570527=0A[=20=20808.869759]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107184128=20csum=2084619057=20=
expected=20csum=2070570527=0A[=20=20808.869791]=20BTRFS=20info=20(device=20=
sde):=20csum=20failed=20ino=20267=20off=20107188224=20csum=202606067653=20=
expected=20csum=2070570527=0A[=20=20808.869937]=20------------[=20cut=20=
here=20]------------=0A[=20=20808.870030]=20kernel=20BUG=20at=20=
/home/apw/COD/linux/fs/btrfs/extent_io.c:2116!=0A[=20=20808.870137]=20=
invalid=20opcode:=200000=20[#1]=20SMP=0A[=20=20808.870214]=20Modules=20=
linked=20in:=20cuse=20deflate=20ctr=20twofish_generic=20=
twofish_x86_64_3way=20twofish_x86_64=20twofish_common=20camellia_generic=20=
camellia_x86_64=20serpent_sse2_x86_64=20xts=20serpent_generic=20lrw=20=
gf128mul=20glue_helper=20blowfish_generic=20blowfish_x86_64=20=
blowfish_common=20cast5_generic=20cast_common=20ablk_helper=20cryptd=20=
des_generic=20cmac=20xcbc=20rmd160=20crypto_null=20af_key=20xfrm_algo=20=
nfsd=20auth_rpcgss=20nfs_acl=20nfs=20lockd=20sunrpc=20dm_crypt=20fscache=20=
ppdev=20ip6t_REJECT=20xt_hl=20ip6t_rt=20nf_conntrack_ipv6=20=
nf_defrag_ipv6=20kvm=20ipt_REJECT=20xt_comment=20xt_LOG=20microcode=20=
xt_recent=20xt_multiport=20psmouse=20edac_core=20serio_raw=20xt_limit=20=
edac_mce_amd=20k10temp=20xt_tcpudp=20xt_addrtype=20snd_hda_codec_via=20=
ipt_MASQUERADE=20snd_hda_codec_hdmi=20snd_hda_codec_generic=20sp5100_tco=20=
i2c_piix4=20iptable_nat=20nf_nat_ipv4=20ftdi_sio=20snd_hda_intel=20=
usbserial=20snd_hda_codec=20nf_conntrack_ipv4=20nf_defrag_ipv4=20=
snd_hwdep=20xt_conntrack=20rc_tbs_nec(OF)=20snd_pcm=20ip6table_filter=20=
saa716x_tbs_dvb(OF)=20tbs6982fe(POF)=20tbs6680fe(POF)=20ip6_tables=20=
tbs6923fe(POF)=20tbs6985se(POF)=20tbs6928se(POF)=20=
nf_conntrack_netbios_ns=20ir_lirc_codec(OF)=20tbs6982se(POF)=20=
nf_conntrack_broadcast=20lirc_dev(OF)=20tbs6991fe(POF)=20nf_nat_ftp=20=
tbs6618fe(POF)=20nf_nat=20ir_mce_kbd_decoder(OF)=20joydev=20=
saa716x_core(OF)=20nf_conntrack_ftp=20ir_sony_decoder(OF)=20=
tbs6922fe(POF)=20nf_conntrack=20ir_jvc_decoder(OF)=20tbs6928fe(POF)=20=
iptable_filter=20ir_rc6_decoder(OF)=20ip_tables=20tbs6991se(POF)=20=
x_tables=20stv090x(OF)=20ir_rc5_decoder(OF)=20snd_timer=20dvb_core(OF)=20=
ir_nec_decoder(OF)=20snd=20soundcore=20rc_core(OF)=20asus_atk0110=20=
shpchp=20parport_pc=20mac_hid=20lp=20parport=20btrfs=20xor=20raid6_pq=20=
pata_acpi=20hid_generic=20usbhid=20hid=20usb_storage=20radeon=20=
pata_atiixp=20i2c_algo_bit=20r8169=20ttm=20mii=20drm_kms_helper=20drm=20=
ahci=20sata_sil24=20libahci=20wmi=0A[=20=20808.873160]=20CPU:=201=20PID:=20=
1412=20Comm:=20btrfs-endio-3=20Tainted:=20PF=20=20=20=20=20=20=20=20=20=20=
O=203.14.1-031401-generic=20#201404141220=0A[=20=20808.873308]=20=
Hardware=20name:=20System=20manufacturer=20System=20Product=20=
Name/M4A78LT-M,=20BIOS=200802=20=20=20=2008/24/2010=0A[=20=20808.873449]=20=
task:=20ffff88030a360000=20ti:=20ffff88030bb8c000=20task.ti:=20=
ffff88030bb8c000=0A[=20=20808.873563]=20RIP:=200010:[<ffffffffa0313c33>]=20=
=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A[=20=20=
808.873768]=20RSP:=200018:ffff88030bb8dcd8=20=20EFLAGS:=2000010246=0A[=20=
=20808.873851]=20RAX:=200000000000000000=20RBX:=20ffff88023f7405b8=20=
RCX:=200000000000000000=0A[=20=20808.873960]=20RDX:=20ffff88008aca2d20=20=
RSI:=2000000000cccaccc8=20RDI:=20ffff88023f740484=0A[=20=20808.874069]=20=
RBP:=20ffff88030bb8dd28=20R08:=200000000000000000=20R09:=20=
0000000000000000=0A[=20=20808.874178]=20R10:=200000000000000200=20R11:=20=
0000000000000000=20R12:=20ffffea00004bcc00=0A[=20=20808.874286]=20R13:=20=
ffff88014e7a7880=20R14:=20ffff88023f740400=20R15:=200000000006633000=0A[=20=
=20808.874397]=20FS:=20=2000007fa14510d880(0000)=20=
GS:ffff88031fc40000(0000)=20knlGS:0000000000000000=0A[=20=20808.874520]=20=
CS:=20=200010=20DS:=200000=20ES:=200000=20CR0:=20000000008005003b=0A[=20=20=
808.874609]=20CR2:=2000007f16b828f000=20CR3:=20000000008573d000=20CR4:=20=
00000000000007e0=0A[=20=20808.874717]=20Stack:=0A[=20=20808.874752]=20=20=
0000000000006633=20ffff8800cf96c000=200000000000000000=20=
ffff88014e7a7880=0A[=20=20808.874885]=20=20ffffffff81eb1180=20=
ffffea00004bcc00=20ffff88015b03cff0=20ffff88023f7405b8=0A[=20=20=
808.875017]=20=200000000006633000=200000000000000000=20ffff88030bb8ddb8=20=
ffffffffa0313f1b=0A[=20=20808.875149]=20Call=20Trace:=0A[=20=20=
808.875248]=20=20[<ffffffffa0313f1b>]=20=
end_bio_extent_readpage+0x2db/0x3d0=20[btrfs]=0A[=20=20808.875367]=20=20=
[<ffffffff8120a013>]=20bio_endio+0x53/0xa0=0A[=20=20808.875450]=20=20=
[<ffffffff8120a072>]=20bio_endio_nodec+0x12/0x20=0A[=20=20808.875579]=20=20=
[<ffffffffa02ece81>]=20end_workqueue_fn+0x41/0x50=20[btrfs]=0A[=20=20=
808.875726]=20=20[<ffffffffa03247d0>]=20worker_loop+0xa0/0x330=20[btrfs]=0A=
[=20=20808.875867]=20=20[<ffffffffa0324730>]=20?=20=
check_pending_worker_creates.isra.1+0xe0/0xe0=20[btrfs]=0A[=20=20=
808.875996]=20=20[<ffffffff8108ffa9>]=20kthread+0xc9/0xe0=0A[=20=20=
808.876076]=20=20[<ffffffff8108fee0>]=20?=20=
flush_kthread_worker+0xb0/0xb0=0A[=20=20808.876175]=20=20=
[<ffffffff817721bc>]=20ret_from_fork+0x7c/0xb0=0A[=20=20808.876262]=20=20=
[<ffffffff8108fee0>]=20?=20flush_kthread_worker+0xb0/0xb0=0A[=20=20=
808.876357]=20Code:=2000=2000=2083=20f8=2001=200f=208e=2049=20ff=20ff=20=
ff=2049=208b=204d=2018=2049=208b=2055=2010=204d=2089=20e0=2045=208b=204d=20=
2c=2048=208b=207d=20b8=204c=2089=20fe=20e8=2072=20fc=20ff=20ff=20e9=2029=20=
ff=20ff=20ff=20<0f>=200b=2066=2066=202e=200f=201f=2084=2000=2000=2000=20=
00=2000=2066=2066=2066=2066=2090=2055=2048=2089=0A[=20=20808.877002]=20=
RIP=20=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A=
[=20=20808.877157]=20=20RSP=20<ffff88030bb8dcd8>=0A[=20=20808.902677]=20=
------------[=20cut=20here=20]------------=0A[=20=20808.902710]=20---[=20=
end=20trace=2065b3947795acb944=20]---=0A[=20=20808.902845]=20kernel=20=
BUG=20at=20/home/apw/COD/linux/fs/btrfs/extent_io.c:2116!=0A[=20=20=
808.902953]=20invalid=20opcode:=200000=20[#2]=20SMP=0A[=20=20808.903039]=20=
Modules=20linked=20in:=20cuse=20deflate=20ctr=20twofish_generic=20=
twofish_x86_64_3way=20twofish_x86_64=20twofish_common=20camellia_generic=20=
camellia_x86_64=20serpent_sse2_x86_64=20xts=20serpent_generic=20lrw=20=
gf128mul=20glue_helper=20blowfish_generic=20blowfish_x86_64=20=
blowfish_common=20cast5_generic=20cast_common=20ablk_helper=20cryptd=20=
des_generic=20cmac=20xcbc=20rmd160=20crypto_null=20af_key=20xfrm_algo=20=
nfsd=20auth_rpcgss=20nfs_acl=20nfs=20lockd=20sunrpc=20dm_crypt=20fscache=20=
ppdev=20ip6t_REJECT=20xt_hl=20ip6t_rt=20nf_conntrack_ipv6=20=
nf_defrag_ipv6=20kvm=20ipt_REJECT=20xt_comment=20xt_LOG=20microcode=20=
xt_recent=20xt_multiport=20psmouse=20edac_core=20serio_raw=20xt_limit=20=
edac_mce_amd=20k10temp=20xt_tcpudp=20xt_addrtype=20snd_hda_codec_via=20=
ipt_MASQUERADE=20snd_hda_codec_hdmi=20snd_hda_codec_generic=20sp5100_tco=20=
i2c_piix4=20iptable_nat=20nf_nat_ipv4=20ftdi_sio=20snd_hda_intel=20=
usbserial=20snd_hda_codec=20nf_conntrack_ipv4=20nf_defrag_ipv4=20=
snd_hwdep=20xt_conntrack=20rc_tbs_nec(OF)=20snd_pcm=20ip6table_filter=20=
saa716x_tbs_dvb(OF)=20tbs6982fe(POF)=20tbs6680fe(POF)=20ip6_tables=20=
tbs6923fe(POF)=20tbs6985se(POF)=20tbs6928se(POF)=20=
nf_conntrack_netbios_ns=20ir_lirc_codec(OF)=20tbs6982se(POF)=20=
nf_conntrack_broadcast=20lirc_dev(OF)=20tbs6991fe(POF)=20nf_nat_ftp=20=
tbs6618fe(POF)=20nf_nat=20ir_mce_kbd_decoder(OF)=20joydev=20=
saa716x_core(OF)=20nf_conntrack_ftp=20ir_sony_decoder(OF)=20=
tbs6922fe(POF)=20nf_conntrack=20ir_jvc_decoder(OF)=20tbs6928fe(POF)=20=
iptable_filter=20ir_rc6_decoder(OF)=20ip_tables=20tbs6991se(POF)=20=
x_tables=20stv090x(OF)=20ir_rc5_decoder(OF)=20snd_timer=20dvb_core(OF)=20=
ir_nec_decoder(OF)=20snd=20soundcore=20rc_core(OF)=20asus_atk0110=20=
shpchp=20parport_pc=20mac_hid=20lp=20parport=20btrfs=20xor=20raid6_pq=20=
pata_acpi=20hid_generic=20usbhid=20hid=20usb_storage=20radeon=20=
pata_atiixp=20i2c_algo_bit=20r8169=20ttm=20mii=20drm_kms_helper=20drm=20=
ahci=20sata_sil24=20libahci=20wmi=0A[=20=20808.914303]=20CPU:=200=20PID:=20=
4097=20Comm:=20btrfs-endio-3=20Tainted:=20PF=20=20=20=20=20D=20=20=20=20=
O=203.14.1-031401-generic=20#201404141220=0A[=20=20808.922438]=20=
Hardware=20name:=20System=20manufacturer=20System=20Product=20=
Name/M4A78LT-M,=20BIOS=200802=20=20=20=2008/24/2010=0A[=20=20808.930654]=20=
task:=20ffff8800a61a63c0=20ti:=20ffff88023ef70000=20task.ti:=20=
ffff88023ef70000=0A[=20=20808.938876]=20RIP:=200010:[<ffffffffa0313c33>]=20=
=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A[=20=20=
808.947217]=20RSP:=200018:ffff88023ef71cd8=20=20EFLAGS:=2000010246=0A[=20=
=20808.955461]=20RAX:=200000000000000000=20RBX:=20ffff88023f7405b8=20=
RCX:=200000000000000000=0A[=20=20808.963631]=20RDX:=20ffff88008aca2e40=20=
RSI:=2000000000cceeccec=20RDI:=20ffff88023f740484=0A[=20=20808.971681]=20=
RBP:=20ffff88023ef71d28=20R08:=200000000000000000=20R09:=20=
0000000000000000=0A[=20=20808.979597]=20R10:=200000000000000200=20R11:=20=
0000000000000000=20R12:=20ffffea00004bcb80=0A[=20=20808.987375]=20R13:=20=
ffff88014e7a7340=20R14:=20ffff88023f740400=20R15:=200000000006631000=0A[=20=
=20808.995038]=20FS:=20=2000007f2bb7377740(0000)=20=
GS:ffff88031fc00000(0000)=20knlGS:0000000000000000=0A[=20=20809.002615]=20=
CS:=20=200010=20DS:=200000=20ES:=200000=20CR0:=20000000008005003b=0A[=20=20=
809.010059]=20CR2:=2000007f16bc28d000=20CR3:=2000000002ec785000=20CR4:=20=
00000000000007f0=0A[=20=20809.017412]=20Stack:=0A[=20=20809.024589]=20=20=
0000000000006631=20ffff8800cf96c000=200000000000000000=20=
ffff88014e7a7340=0A[=20=20809.031775]=20=20ffff88030a92d300=20=
ffffea00004bcb80=20ffff88015b03c870=20ffff88023f7405b8=0A[=20=20=
809.038841]=20=200000000006631000=200000000000000000=20ffff88023ef71db8=20=
ffffffffa0313f1b=0A[=20=20809.045852]=20Call=20Trace:=0A[=20=20=
809.052796]=20=20[<ffffffffa0313f1b>]=20=
end_bio_extent_readpage+0x2db/0x3d0=20[btrfs]=0A[=20=20809.059740]=20=20=
[<ffffffff8120a013>]=20bio_endio+0x53/0xa0=0A[=20=20809.066601]=20=20=
[<ffffffff8120a072>]=20bio_endio_nodec+0x12/0x20=0A[=20=20809.073438]=20=20=
[<ffffffffa02ece81>]=20end_workqueue_fn+0x41/0x50=20[btrfs]=0A[=20=20=
809.080279]=20=20[<ffffffffa03247d0>]=20worker_loop+0xa0/0x330=20[btrfs]=0A=
[=20=20809.087098]=20=20[<ffffffffa0324730>]=20?=20=
check_pending_worker_creates.isra.1+0xe0/0xe0=20[btrfs]=0A[=20=20=
809.093917]=20=20[<ffffffff8108ffa9>]=20kthread+0xc9/0xe0=0A[=20=20=
809.100721]=20=20[<ffffffff8108fee0>]=20?=20=
flush_kthread_worker+0xb0/0xb0=0A[=20=20809.107532]=20=20=
[<ffffffff817721bc>]=20ret_from_fork+0x7c/0xb0=0A[=20=20809.114294]=20=20=
[<ffffffff8108fee0>]=20?=20flush_kthread_worker+0xb0/0xb0=0A[=20=20=
809.121034]=20Code:=2000=2000=2083=20f8=2001=200f=208e=2049=20ff=20ff=20=
ff=2049=208b=204d=2018=2049=208b=2055=2010=204d=2089=20e0=2045=208b=204d=20=
2c=2048=208b=207d=20b8=204c=2089=20fe=20e8=2072=20fc=20ff=20ff=20e9=2029=20=
ff=20ff=20ff=20<0f>=200b=2066=2066=202e=200f=201f=2084=2000=2000=2000=20=
00=2000=2066=2066=2066=2066=2090=2055=2048=2089=0A[=20=20809.135474]=20=
RIP=20=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A=
[=20=20809.142513]=20=20RSP=20<ffff88023ef71cd8>=0A[=20=20809.149468]=20=
------------[=20cut=20here=20]------------=0A[=20=20809.149603]=20---[=20=
end=20trace=2065b3947795acb945=20]---=0A[=20=20809.161020]=20kernel=20=
BUG=20at=20/home/apw/COD/linux/fs/btrfs/extent_io.c:2116!=0A[=20=20=
809.166761]=20invalid=20opcode:=200000=20[#3]=20SMP=0A[=20=20809.172495]=20=
Modules=20linked=20in:=20cuse=20deflate=20ctr=20twofish_generic=20=
twofish_x86_64_3way=20twofish_x86_64=20twofish_common=20camellia_generic=20=
camellia_x86_64=20serpent_sse2_x86_64=20xts=20serpent_generic=20lrw=20=
gf128mul=20glue_helper=20blowfish_generic=20blowfish_x86_64=20=
blowfish_common=20cast5_generic=20cast_common=20ablk_helper=20cryptd=20=
des_generic=20cmac=20xcbc=20rmd160=20crypto_null=20af_key=20xfrm_algo=20=
nfsd=20auth_rpcgss=20nfs_acl=20nfs=20lockd=20sunrpc=20dm_crypt=20fscache=20=
ppdev=20ip6t_REJECT=20xt_hl=20ip6t_rt=20nf_conntrack_ipv6=20=
nf_defrag_ipv6=20kvm=20ipt_REJECT=20xt_comment=20xt_LOG=20microcode=20=
xt_recent=20xt_multiport=20psmouse=20edac_core=20serio_raw=20xt_limit=20=
edac_mce_amd=20k10temp=20xt_tcpudp=20xt_addrtype=20snd_hda_codec_via=20=
ipt_MASQUERADE=20snd_hda_codec_hdmi=20snd_hda_codec_generic=20sp5100_tco=20=
i2c_piix4=20iptable_nat=20nf_nat_ipv4=20ftdi_sio=20snd_hda_intel=20=
usbserial=20snd_hda_codec=20nf_conntrack_ipv4=20nf_defrag_ipv4=20=
snd_hwdep=20xt_conntrack=20rc_tbs_nec(OF)=20snd_pcm=20ip6table_filter=20=
saa716x_tbs_dvb(OF)=20tbs6982fe(POF)=20tbs6680fe(POF)=20ip6_tables=20=
tbs6923fe(POF)=20tbs6985se(POF)=20tbs6928se(POF)=20=
nf_conntrack_netbios_ns=20ir_lirc_codec(OF)=20tbs6982se(POF)=20=
nf_conntrack_broadcast=20lirc_dev(OF)=20tbs6991fe(POF)=20nf_nat_ftp=20=
tbs6618fe(POF)=20nf_nat=20ir_mce_kbd_decoder(OF)=20joydev=20=
saa716x_core(OF)=20nf_conntrack_ftp=20ir_sony_decoder(OF)=20=
tbs6922fe(POF)=20nf_conntrack=20ir_jvc_decoder(OF)=20tbs6928fe(POF)=20=
iptable_filter=20ir_rc6_decoder(OF)=20ip_tables=20tbs6991se(POF)=20=
x_tables=20stv090x(OF)=20ir_rc5_decoder(OF)=20snd_timer=20dvb_core(OF)=20=
ir_nec_decoder(OF)=20snd=20soundcore=20rc_core(OF)=20asus_atk0110=20=
shpchp=20parport_pc=20mac_hid=20lp=20parport=20btrfs=20xor=20raid6_pq=20=
pata_acpi=20hid_generic=20usbhid=20hid=20usb_storage=20radeon=20=
pata_atiixp=20i2c_algo_bit=20r8169=20ttm=20mii=20drm_kms_helper=20drm=20=
ahci=20sata_sil24=20libahci=20wmi=0A[=20=20809.244598]=20CPU:=201=20PID:=20=
4096=20Comm:=20btrfs-endio-2=20Tainted:=20PF=20=20=20=20=20D=20=20=20=20=
O=203.14.1-031401-generic=20#201404141220=0A[=20=20809.251438]=20=
Hardware=20name:=20System=20manufacturer=20System=20Product=20=
Name/M4A78LT-M,=20BIOS=200802=20=20=20=2008/24/2010=0A[=20=20809.258357]=20=
task:=20ffff8800a61a4ad0=20ti:=20ffff88021e98e000=20task.ti:=20=
ffff88021e98e000=0A[=20=20809.265289]=20RIP:=200010:[<ffffffffa0313c33>]=20=
=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A[=20=20=
809.272315]=20RSP:=200018:ffff88021e98fcd8=20=20EFLAGS:=2000010246=0A[=20=
=20809.279275]=20RAX:=200000000000000000=20RBX:=20ffff88023f7405b8=20=
RCX:=200000000000000000=0A[=20=20809.286186]=20RDX:=20ffff88008aca2720=20=
RSI:=2000000000ccf2ccf0=20RDI:=20ffff88023f740484=0A[=20=20809.292972]=20=
RBP:=20ffff88021e98fd28=20R08:=200000000000000000=20R09:=20=
0000000000000000=0A[=20=20809.299660]=20R10:=200000000000000200=20R11:=20=
0000000000000000=20R12:=20ffffea00004bcd00=0A[=20=20809.306205]=20R13:=20=
ffff88014e7a7e40=20R14:=20ffff88023f740400=20R15:=200000000006637000=0A[=20=
=20809.312650]=20FS:=20=2000007f1faacdc700(0000)=20=
GS:ffff88031fc40000(0000)=20knlGS:0000000000000000=0A[=20=20809.319040]=20=
CS:=20=200010=20DS:=200000=20ES:=200000=20CR0:=20000000008005003b=0A[=20=20=
809.325293]=20CR2:=2000007f16b828f000=20CR3:=20000000030d306000=20CR4:=20=
00000000000007e0=0A[=20=20809.331464]=20Stack:=0A[=20=20809.337504]=20=20=
0000000000006637=20ffff8800cf96c000=200000000000000000=20=
ffff88014e7a7e40=0A[=20=20809.343525]=20=20ffff88030e94c000=20=
ffffea00004bcd00=20ffff88015b03d630=20ffff88023f7405b8=0A[=20=20=
809.349446]=20=200000000006637000=200000000000000000=20ffff88021e98fdb8=20=
ffffffffa0313f1b=0A[=20=20809.355319]=20Call=20Trace:=0A[=20=20=
809.361107]=20=20[<ffffffffa0313f1b>]=20=
end_bio_extent_readpage+0x2db/0x3d0=20[btrfs]=0A[=20=20809.366914]=20=20=
[<ffffffff8120a013>]=20bio_endio+0x53/0xa0=0A[=20=20809.372653]=20=20=
[<ffffffff8120a072>]=20bio_endio_nodec+0x12/0x20=0A[=20=20809.378364]=20=20=
[<ffffffffa02ece81>]=20end_workqueue_fn+0x41/0x50=20[btrfs]=0A[=20=20=
809.384054]=20=20[<ffffffffa03247d0>]=20worker_loop+0xa0/0x330=20[btrfs]=0A=
[=20=20809.389727]=20=20[<ffffffffa0324730>]=20?=20=
check_pending_worker_creates.isra.1+0xe0/0xe0=20[btrfs]=0A[=20=20=
809.395431]=20=20[<ffffffff8108ffa9>]=20kthread+0xc9/0xe0=0A[=20=20=
809.401123]=20=20[<ffffffff8108fee0>]=20?=20=
flush_kthread_worker+0xb0/0xb0=0A[=20=20809.406866]=20=20=
[<ffffffff817721bc>]=20ret_from_fork+0x7c/0xb0=0A[=20=20809.412526]=20=20=
[<ffffffff8108fee0>]=20?=20flush_kthread_worker+0xb0/0xb0=0A[=20=20=
809.418158]=20Code:=2000=2000=2083=20f8=2001=200f=208e=2049=20ff=20ff=20=
ff=2049=208b=204d=2018=2049=208b=2055=2010=204d=2089=20e0=2045=208b=204d=20=
2c=2048=208b=207d=20b8=204c=2089=20fe=20e8=2072=20fc=20ff=20ff=20e9=2029=20=
ff=20ff=20ff=20<0f>=200b=2066=2066=202e=200f=201f=2084=2000=2000=2000=20=
00=2000=2066=2066=2066=2066=2090=2055=2048=2089=0A[=20=20809.430145]=20=
RIP=20=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A=
[=20=20809.435962]=20=20RSP=20<ffff88021e98fcd8>=0A[=20=20809.441833]=20=
---[=20end=20trace=2065b3947795acb946=20]---=0A[=20=20809.447790]=20=
------------[=20cut=20here=20]------------=0A[=20=20809.453488]=20kernel=20=
BUG=20at=20/home/apw/COD/linux/fs/btrfs/extent_io.c:2116!=0A[=20=20=
809.459195]=20invalid=20opcode:=200000=20[#4]=20SMP=0A[=20=20809.464891]=20=
Modules=20linked=20in:=20cuse=20deflate=20ctr=20twofish_generic=20=
twofish_x86_64_3way=20twofish_x86_64=20twofish_common=20camellia_generic=20=
camellia_x86_64=20serpent_sse2_x86_64=20xts=20serpent_generic=20lrw=20=
gf128mul=20glue_helper=20blowfish_generic=20blowfish_x86_64=20=
blowfish_common=20cast5_generic=20cast_common=20ablk_helper=20cryptd=20=
des_generic=20cmac=20xcbc=20rmd160=20crypto_null=20af_key=20xfrm_algo=20=
nfsd=20auth_rpcgss=20nfs_acl=20nfs=20lockd=20sunrpc=20dm_crypt=20fscache=20=
ppdev=20ip6t_REJECT=20xt_hl=20ip6t_rt=20nf_conntrack_ipv6=20=
nf_defrag_ipv6=20kvm=20ipt_REJECT=20xt_comment=20xt_LOG=20microcode=20=
xt_recent=20xt_multiport=20psmouse=20edac_core=20serio_raw=20xt_limit=20=
edac_mce_amd=20k10temp=20xt_tcpudp=20xt_addrtype=20snd_hda_codec_via=20=
ipt_MASQUERADE=20snd_hda_codec_hdmi=20snd_hda_codec_generic=20sp5100_tco=20=
i2c_piix4=20iptable_nat=20nf_nat_ipv4=20ftdi_sio=20snd_hda_intel=20=
usbserial=20snd_hda_codec=20nf_conntrack_ipv4=20nf_defrag_ipv4=20=
snd_hwdep=20xt_conntrack=20rc_tbs_nec(OF)=20snd_pcm=20ip6table_filter=20=
saa716x_tbs_dvb(OF)=20tbs6982fe(POF)=20tbs6680fe(POF)=20ip6_tables=20=
tbs6923fe(POF)=20tbs6985se(POF)=20tbs6928se(POF)=20=
nf_conntrack_netbios_ns=20ir_lirc_codec(OF)=20tbs6982se(POF)=20=
nf_conntrack_broadcast=20lirc_dev(OF)=20tbs6991fe(POF)=20nf_nat_ftp=20=
tbs6618fe(POF)=20nf_nat=20ir_mce_kbd_decoder(OF)=20joydev=20=
saa716x_core(OF)=20nf_conntrack_ftp=20ir_sony_decoder(OF)=20=
tbs6922fe(POF)=20nf_conntrack=20ir_jvc_decoder(OF)=20tbs6928fe(POF)=20=
iptable_filter=20ir_rc6_decoder(OF)=20ip_tables=20tbs6991se(POF)=20=
x_tables=20stv090x(OF)=20ir_rc5_decoder(OF)=20snd_timer=20dvb_core(OF)=20=
ir_nec_decoder(OF)=20snd=20soundcore=20rc_core(OF)=20asus_atk0110=20=
shpchp=20parport_pc=20mac_hid=20lp=20parport=20btrfs=20xor=20raid6_pq=20=
pata_acpi=20hid_generic=20usbhid=20hid=20usb_storage=20radeon=20=
pata_atiixp=20i2c_algo_bit=20r8169=20ttm=20mii=20drm_kms_helper=20drm=20=
ahci=20sata_sil24=20libahci=20wmi=0A[=20=20809.536319]=20CPU:=201=20PID:=20=
4098=20Comm:=20btrfs-endio-4=20Tainted:=20PF=20=20=20=20=20D=20=20=20=20=
O=203.14.1-031401-generic=20#201404141220=0A[=20=20809.543111]=20=
Hardware=20name:=20System=20manufacturer=20System=20Product=20=
Name/M4A78LT-M,=20BIOS=200802=20=20=20=2008/24/2010=0A[=20=20809.549942]=20=
task:=20ffff8800a61a31e0=20ti:=20ffff8802a595c000=20task.ti:=20=
ffff8802a595c000=0A[=20=20809.556833]=20RIP:=200010:[<ffffffffa0313c33>]=20=
=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A[=20=20=
809.563769]=20RSP:=200018:ffff8802a595dcd8=20=20EFLAGS:=2000010246=0A[=20=
=20809.570680]=20RAX:=200000000000000000=20RBX:=20ffff88023f7405b8=20=
RCX:=200000000000000000=0A[=20=20809.577508]=20RDX:=20ffff88008aca2120=20=
RSI:=2000000000ccf6ccf4=20RDI:=20ffff88023f740484=0A[=20=20809.584249]=20=
RBP:=20ffff8802a595dd28=20R08:=200000000000000000=20R09:=20=
0000000000000000=0A[=20=20809.590855]=20R10:=200000000000000200=20R11:=20=
0000000000000000=20R12:=20ffffea00004bce00=0A[=20=20809.597358]=20R13:=20=
ffff88014e7a7e80=20R14:=20ffff88023f740400=20R15:=20000000000663b000=0A[=20=
=20809.603738]=20FS:=20=2000007f1faacdc700(0000)=20=
GS:ffff88031fc40000(0000)=20knlGS:0000000000000000=0A[=20=20809.610046]=20=
CS:=20=200010=20DS:=200000=20ES:=200000=20CR0:=20000000008005003b=0A[=20=20=
809.616250]=20CR2:=2000007f16b828f000=20CR3:=20000000030d306000=20CR4:=20=
00000000000007e0=0A[=20=20809.622360]=20Stack:=0A[=20=20809.628317]=20=20=
000000000000663b=20ffff8800cf96c000=200000000000000000=20=
ffff88014e7a7e80=0A[=20=20809.634275]=20=20ffffffff81eb1180=20=
ffffea00004bce00=20ffff88015b03d3b0=20ffff88023f7405b8=0A[=20=20=
809.640147]=20=20000000000663b000=200000000000000000=20ffff8802a595ddb8=20=
ffffffffa0313f1b=0A[=20=20809.645949]=20Call=20Trace:=0A[=20=20=
809.651693]=20=20[<ffffffffa0313f1b>]=20=
end_bio_extent_readpage+0x2db/0x3d0=20[btrfs]=0A[=20=20809.657451]=20=20=
[<ffffffff8120a013>]=20bio_endio+0x53/0xa0=0A[=20=20809.663138]=20=20=
[<ffffffff8120a072>]=20bio_endio_nodec+0x12/0x20=0A[=20=20809.668771]=20=20=
[<ffffffffa02ece81>]=20end_workqueue_fn+0x41/0x50=20[btrfs]=0A[=20=20=
809.674402]=20=20[<ffffffffa03247d0>]=20worker_loop+0xa0/0x330=20[btrfs]=0A=
[=20=20809.680019]=20=20[<ffffffffa0324730>]=20?=20=
check_pending_worker_creates.isra.1+0xe0/0xe0=20[btrfs]=0A[=20=20=
809.685664]=20=20[<ffffffff8108ffa9>]=20kthread+0xc9/0xe0=0A[=20=20=
809.691304]=20=20[<ffffffff8108fee0>]=20?=20=
flush_kthread_worker+0xb0/0xb0=0A[=20=20809.696948]=20=20=
[<ffffffff817721bc>]=20ret_from_fork+0x7c/0xb0=0A[=20=20809.702548]=20=20=
[<ffffffff8108fee0>]=20?=20flush_kthread_worker+0xb0/0xb0=0A[=20=20=
809.708131]=20Code:=2000=2000=2083=20f8=2001=200f=208e=2049=20ff=20ff=20=
ff=2049=208b=204d=2018=2049=208b=2055=2010=204d=2089=20e0=2045=208b=204d=20=
2c=2048=208b=207d=20b8=204c=2089=20fe=20e8=2072=20fc=20ff=20ff=20e9=2029=20=
ff=20ff=20ff=20<0f>=200b=2066=2066=202e=200f=201f=2084=2000=2000=2000=20=
00=2000=2066=2066=2066=2066=2090=2055=2048=2089=0A[=20=20809.720025]=20=
RIP=20=20[<ffffffffa0313c33>]=20clean_io_failure+0x1a3/0x1b0=20[btrfs]=0A=
[=20=20809.725918]=20=20RSP=20<ffff8802a595dcd8>=0A[=20=20809.731767]=20=
---[=20end=20trace=2065b3947795acb947=20]---=

--Apple-Mail=_FC1A509D-64E2-4B2E-8C86-6241DF2171BB--
