From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: Re: [PATCH] Btrfs: Fix balance panic
Date: Wed, 2 Feb 2011 14:12:31 -0600
Message-ID: <AANLkTikUsXk7kzO8wfiCZ=y0iHZPQAMU3+x-cQk3Knf9@mail.gmail.com>
References: <4D3FF9B3.3030504@linux.intel.com>
	<BearyfWi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BearyfWi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Helmut,

On Wed, Jan 26, 2011 at 9:33 AM, Helmut Hullen <Hullen@t-online.de> wro=
te:
>
> Sorry - didn't solve my problem:
>
> -------------- last lines from "dmesg" ---------------
>
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
>
> [...] more than 800 such lines
>
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/volumes.c:2097!
> invalid opcode: 0000 [#1]
> last sysfs file: /sys/devices/pci0000:00/0000:00:07.1/host1/target1:0=
:0/1:0:0:0/block/sdb/dev
> Modules linked in: sg nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE ipta=
ble_nat nf_nat xt_DSCP xt_multiport xt_recent nf_conntrack_ipv4 nf_defr=
ag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter iptab=
le_mangle ip_tables xt_iprange x_tables nfsd exportfs 8139too 8139cp sa=
vagefb fb_ddc i2c_algo_bit vgastate i2c_piix4 piix e100 mii intel_agp i=
ntel_gtt agpgart cmd64x video thermal_sys ac battery yenta_socket pcmci=
a_rsrc pcmcia pcmcia_core thinkpad_acpi hwmon rfkill nvram fuse
>
> Pid: 5991, comm: btrfs Not tainted 2.6.38-rc2-OD1 #2 26478EG/26478EG
> EIP: 0060:[<c1235264>] EFLAGS: 00010282 CPU: 0
> EIP is at btrfs_balance+0x2d4/0x2e0
> EAX: fffffffb EBX: cfa58000 ECX: d7ce6c18 EDX: d7ce6818
> ESI: d0574000 EDI: cf958400 EBP: cc4e3e9c ESP: cc4e3e38
> =A0DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> Process btrfs (pid: 5991, ti=3Dcc4e2000 task=3Dcce6c3c0 task.ti=3Dcc4=
e2000)
> Stack:
> =A099cc0000 00000001 000000e4 00100000 00000000 00000100 ccdcc000 cce=
8d058
> =A0aea58000 00000001 00000000 99cc0000 00000001 0100b790 00000000 00e=
40000
> =A00199cc00 00000000 00000001 e4000000 ffffffff ffffffff ccc85380 fff=
fffea
> Call Trace:
> =A0[<c123bcf1>] btrfs_ioctl+0x2e1/0x9d0
> =A0[<c123ba10>] ? btrfs_ioctl+0x0/0x9d0
> =A0[<c10c3f65>] do_vfs_ioctl+0x85/0x590
> =A0[<c10206db>] ? do_page_fault+0x17b/0x380
> =A0[<c10b554b>] ? do_sys_open+0xdb/0x110
> =A0[<c10c44f7>] sys_ioctl+0x87/0x90
> =A0[<c1753d0c>] syscall_call+0x7/0xb
> Code: 1b ff ff ff 89 f0 e8 cc 75 fb ff 8b 55 b4 8b 82 10 01 00 00 05 =
74 19 00 00 e8 09 dc 51 00 e9 70 fd ff ff 31 db eb dd 85 c0 74 9d <0f> =
0b 0f 0b 0f 0b 0f 0b 0f 0b 66 90 55 89 e5 56 53 83 ec 34 3e
> EIP: [<c1235264>] btrfs_balance+0x2d4/0x2e0 SS:ESP 0068:cc4e3e38
> ---[ end trace ebf8fd68179e0b7a ]---
>

I could not reproduce this. However, I think this is related to the
number of vecs the device can handle.
Could you try this patch?

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e993cf..b871eb0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1914,10 +1914,7 @@ static int submit_extent_page(int rw, struct
extent_io_tree *tree,
                        return 0;
                }
        }
-       if (this_compressed)
-               nr =3D BIO_MAX_PAGES;
-       else
-               nr =3D bio_get_nr_vecs(bdev);
+       nr =3D bio_get_nr_vecs(bdev);

        bio =3D btrfs_bio_alloc(bdev, sector, nr, GFP_NOFS | __GFP_HIGH=
);

--=20
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
