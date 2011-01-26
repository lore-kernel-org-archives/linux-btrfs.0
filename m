From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH] Btrfs: Fix balance panic
Date: 26 Jan 2011 16:33:00 +0100
Message-ID: <BearyfWi1uB@helmut.hullen.de>
References: <4D3FF9B3.3030504@linux.intel.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3FF9B3.3030504@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Yan,,

Du meintest am 26.01.11:

> Mark the cloned backref_node as checked in clone_backref_node()

> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> -+-
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 045c9c2..bef9c22 100644
> -+- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1157,6 +1157,7 @@ static int clone_backref_node(struct
> btrfs_trans_handle *trans,  	new_node->bytenr = dest->node->start;
>  	new_node->level = node->level;
>  	new_node->lowest = node->lowest;
> +	new_node->checked = 1;
>  	new_node->root = dest;

>  	if (!node->lowest) {
> --

Sorry - didn't solve my problem:

-------------- last lines from "dmesg" ---------------

bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)

[...] more than 800 such lines

bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)
bio too big device sdc (256 > 240)
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:2097!
invalid opcode: 0000 [#1]
last sysfs file: /sys/devices/pci0000:00/0000:00:07.1/host1/target1:0:0/1:0:0:0/block/sdb/dev
Modules linked in: sg nf_nat_ftp nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat xt_DSCP xt_multiport xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp ipt_REJECT iptable_filter iptable_mangle ip_tables xt_iprange x_tables nfsd exportfs 8139too 8139cp savagefb fb_ddc i2c_algo_bit vgastate i2c_piix4 piix e100 mii intel_agp intel_gtt agpgart cmd64x video thermal_sys ac battery yenta_socket pcmcia_rsrc pcmcia pcmcia_core thinkpad_acpi hwmon rfkill nvram fuse

Pid: 5991, comm: btrfs Not tainted 2.6.38-rc2-OD1 #2 26478EG/26478EG
EIP: 0060:[<c1235264>] EFLAGS: 00010282 CPU: 0
EIP is at btrfs_balance+0x2d4/0x2e0
EAX: fffffffb EBX: cfa58000 ECX: d7ce6c18 EDX: d7ce6818
ESI: d0574000 EDI: cf958400 EBP: cc4e3e9c ESP: cc4e3e38
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process btrfs (pid: 5991, ti=cc4e2000 task=cce6c3c0 task.ti=cc4e2000)
Stack:
 99cc0000 00000001 000000e4 00100000 00000000 00000100 ccdcc000 cce8d058
 aea58000 00000001 00000000 99cc0000 00000001 0100b790 00000000 00e40000
 0199cc00 00000000 00000001 e4000000 ffffffff ffffffff ccc85380 ffffffea
Call Trace:
 [<c123bcf1>] btrfs_ioctl+0x2e1/0x9d0
 [<c123ba10>] ? btrfs_ioctl+0x0/0x9d0
 [<c10c3f65>] do_vfs_ioctl+0x85/0x590
 [<c10206db>] ? do_page_fault+0x17b/0x380
 [<c10b554b>] ? do_sys_open+0xdb/0x110
 [<c10c44f7>] sys_ioctl+0x87/0x90
 [<c1753d0c>] syscall_call+0x7/0xb
Code: 1b ff ff ff 89 f0 e8 cc 75 fb ff 8b 55 b4 8b 82 10 01 00 00 05 74 19 00 00 e8 09 dc 51 00 e9 70 fd ff ff 31 db eb dd 85 c0 74 9d <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 90 55 89 e5 56 53 83 ec 34 3e
EIP: [<c1235264>] btrfs_balance+0x2d4/0x2e0 SS:ESP 0068:cc4e3e38
---[ end trace ebf8fd68179e0b7a ]---

# ---------------- end "dmesg" ----------------------

Viele Gruesse!
Helmut
