Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F066DC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 10:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8CFA20672
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 10:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8CFA20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbeLFKHk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 05:07:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:35018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbeLFKHk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 05:07:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAD3EAF92
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 10:07:36 +0000 (UTC)
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
From:   Johannes Thumshirn <jthumshirn@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=jthumshirn@suse.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <522e5e66-9d37-1f0d-95cc-eabcf19f8fc8@suse.de>
Date:   Thu, 6 Dec 2018 11:07:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 05/12/2018 13:28, Goldwyn Rodrigues wrote:
> This is a support for DAX in btrfs. I understand there have been
> previous attempts at it. However, I wanted to make sure copy-on-write
> (COW) works on dax as well.
> 
> Before I present this to the FS folks I wanted to run this through the
> btrfs. Even though I wish, I cannot get it correct the first time
> around :/.. Here are some questions for which I need suggestions:

Hi Goldwyn,

I've thrown your patches (from your git tree) onto one of my pmem test
machines with this pmem config:

mayhem:~/:[0]# ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"fsdax",
    "map":"dev",
    "size":792721358848,
    "uuid":"3fd4ab18-5145-4675-85a0-e05e6f9bcee4",
    "raw_uuid":"49264743-2351-41c5-9db9-38534813df61",
    "sector_size":512,
    "blockdev":"pmem1",
    "numa_node":1
  },
  {
    "dev":"namespace0.0",
    "mode":"fsdax",
    "map":"dev",
    "size":792721358848,
    "uuid":"dd0aec3c-7721-4621-8898-e50684a371b5",
    "raw_uuid":"84ff5463-f76e-4ddf-a248-85122541e909",
    "sector_size":4096,
    "blockdev":"pmem0",
    "numa_node":0
  }
]

Unfortunately I hit a btrfs_panic() with btrfs/002.
export TEST_DEV=/dev/pmem0
export SCRATCH_DEV=/dev/pmem1
export MOUNT_OPTIONS="-o dax"
./check
[...]
[  178.173113] run fstests btrfs/002 at 2018-12-06 10:55:43
[  178.357044] BTRFS info (device pmem0): disk space caching is enabled
[  178.357047] BTRFS info (device pmem0): has skinny extents
[  178.360042] BTRFS info (device pmem0): enabling ssd optimizations
[  178.475918] BTRFS: device fsid ee888255-7f4a-4bf7-af65-e8a6a354aca8
devid 1 transid 3 /dev/pmem1
[  178.505717] BTRFS info (device pmem1): disk space caching is enabled
[  178.513593] BTRFS info (device pmem1): has skinny extents
[  178.520384] BTRFS info (device pmem1): flagging fs with big metadata
feature
[  178.530997] BTRFS info (device pmem1): enabling ssd optimizations
[  178.538331] BTRFS info (device pmem1): creating UUID tree
[  178.587200] BTRFS critical (device pmem1): panic in
ordered_data_tree_panic:57: Inconsistency in ordered tree at offset 0
(errno=-17 Object already exists)
[  178.603129] ------------[ cut here ]------------
[  178.608667] kernel BUG at fs/btrfs/ordered-data.c:57!
[  178.614333] invalid opcode: 0000 [#1] SMP PTI
[  178.619295] CPU: 87 PID: 8225 Comm: dd Kdump: loaded Tainted: G
      E     4.20.0-rc5-default-btrfs-dax #920
[  178.630090] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS
SE5C620.86B.0D.01.0010.072020182008 07/20/2018
[  178.640626] RIP: 0010:__btrfs_add_ordered_extent+0x325/0x410 [btrfs]
[  178.647404] Code: 28 4d 89 f1 49 c7 c0 90 9c 57 c0 b9 ef ff ff ff ba
39 00 00 00 48 c7 c6 10 fe 56 c0 48 8b b8 d8 03 00 00 31 c0 e8 e2 99 06
00 <0f> 0b 65 8b 05 d2 e4 b0 3f 89 c0 48 0f a3 05 78 5e cf c2 0f 92 c0
[  178.667019] RSP: 0018:ffffa3e3674c7ba8 EFLAGS: 00010096
[  178.672684] RAX: 000000000000008f RBX: ffff9770c2ac5748 RCX:
0000000000000000
[  178.680254] RDX: ffff97711f9dee80 RSI: ffff97711f9d6868 RDI:
ffff97711f9d6868
[  178.687831] RBP: ffff97711d523000 R08: 0000000000000000 R09:
000000000000065a
[  178.695411] R10: 00000000000003ff R11: 0000000000000001 R12:
ffff97710d66da70
[  178.702993] R13: ffff9770c2ac5600 R14: 0000000000000000 R15:
ffff97710d66d9c0
[  178.710573] FS:  00007fe11ef90700(0000) GS:ffff97711f9c0000(0000)
knlGS:0000000000000000
[  178.719122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  178.725380] CR2: 000000000156a000 CR3: 000000eb30dfc006 CR4:
00000000007606e0
[  178.732999] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  178.740574] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[  178.748147] PKRU: 55555554
[  178.751297] Call Trace:
[  178.754230]  btrfs_add_ordered_extent_dio+0x1d/0x30 [btrfs]
[  178.760269]  btrfs_create_dio_extent+0x79/0xe0 [btrfs]
[  178.765930]  btrfs_get_extent_map_write+0x1a9/0x2b0 [btrfs]
[  178.771959]  btrfs_file_dax_write+0x1f8/0x4f0 [btrfs]
[  178.777508]  ? current_time+0x3f/0x70
[  178.781672]  btrfs_file_write_iter+0x384/0x580 [btrfs]
[  178.787265]  ? pipe_read+0x243/0x2a0
[  178.791298]  __vfs_write+0xee/0x170
[  178.795241]  vfs_write+0xad/0x1a0
[  178.799008]  ? vfs_read+0x111/0x130
[  178.802949]  ksys_write+0x42/0x90
[  178.806712]  do_syscall_64+0x5b/0x180
[  178.810829]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  178.816334] RIP: 0033:0x7fe11eabb3d0
[  178.820364] Code: 73 01 c3 48 8b 0d b8 ea 2b 00 f7 d8 64 89 01 48 83
c8 ff c3 66 0f 1f 44 00 00 83 3d b9 43 2c 00 00 75 10 b8 01 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 2e 90 01 00 48 89 04 24
[  178.840052] RSP: 002b:00007ffec969d978 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  178.848100] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fe11eabb3d0
[  178.855715] RDX: 0000000000000400 RSI: 000000000156a000 RDI:
0000000000000001
[  178.863326] RBP: 0000000000000400 R08: 0000000000000003 R09:
00007fe11ed7a698
[  178.870928] R10: 0000000010a8b550 R11: 0000000000000246 R12:
000000000156a000
[  178.878529] R13: 0000000000000000 R14: 000000000156a000 R15:
00007ffec969e9f1
[  178.886177] Modules linked in: rpcsec_gss_krb5(E) auth_rpcgss(E)
nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) fscache(E) devlink(E)
ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E)
iptable_filter(E) ip_tables(E) x_tables(E) rpcrdma(E) sunrpc(E)
rdma_ucm(E) ib_uverbs(E) ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E)
intel_rapl(E) libiscsi(E) af_packet(E) scsi_transport_iscsi(E)
skx_edac(E) configfs(E) x86_pkg_temp_thermal(E) intel_powerclamp(E)
iscsi_ibft(E) coretemp(E) iscsi_boot_sysfs(E) ipmi_ssif(E) kvm(E) msr(E)
i40iw(E) ib_core(E) ext4(E) nls_iso8859_1(E) nls_cp437(E) crc16(E)
mbcache(E) vfat(E) irqbypass(E) crc32_pclmul(E) ghash_clmulni_intel(E)
jbd2(E) joydev(E) fat(E) i40e(E) aesni_intel(E) iTCO_wdt(E) ptp(E)
aes_x86_64(E) iTCO_vendor_support(E) mei_me(E) crypto_simd(E) ipmi_si(E)
pps_core(E) lpc_ich(E) ioatdma(E) dax_pmem(E) ipmi_devintf(E) nd_pmem(E)
cryptd(E) glue_helper(E) pcspkr(E) mfd_core(E) i2c_i801(E) device_dax(E)
ipmi_msghandler(E) mei(E) nd_btt(E) dca(E)
[  178.886201]  pcc_cpufreq(E) acpi_pad(E) btrfs(E) libcrc32c(E) xor(E)
zstd_decompress(E) zstd_compress(E) xxhash(E) raid6_pq(E) hid_generic(E)
usbhid(E) sd_mod(E) sr_mod(E) cdrom(E) ast(E) i2c_algo_bit(E)
drm_kms_helper(E) syscopyarea(E) ahci(E) sysfillrect(E) xhci_pci(E)
sysimgblt(E) fb_sys_fops(E) libahci(E) xhci_hcd(E) ttm(E)
crc32c_intel(E) drm(E) libata(E) usbcore(E) wmi(E) nfit(E) libnvdimm(E)
button(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E)
scsi_dh_alua(E) scsi_mod(E) efivarfs(E) autofs4(E)



-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
