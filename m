Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FC776025
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 20:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782159626; cv=none; b=MSHo4wszYIfZMwEe6kPUP4MotPEDdrXaLTVnrKFbG66lN/0wBKH9SpUESRGzKvj7aIU/xeEurTn+37mNWzLMetMblmQYLeXsKnJPYS+513b8/9aTf8UOhfUigWRduUeKDaE4c9cCiJPWEyb+qaXRPZfpT22WadKhU5rCWAqH5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782159626; c=relaxed/simple;
	bh=FkE0tWnif62n89eSTIBmqvMveLZ9a3xSa4OoG7tgbnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gT1NBKN3tT84xNy32m9H/phYca/pd/bmYomX5KCs1t8RdsoZ+OfDhvvK+KgKYI1wqeMWEO+KrkJzXeppCZGhEmcQFsOmz5HgaitPqk28Sn4qJoyMyaq+iq+xCPtlUZjrgK7QE+CjNBbXV5S7m2fe7TCvYnmiYUFKt+JS3wX2j7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=UQSE2DWi; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="UQSE2DWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782159617; bh=O2sAVozDUi5Jl+qCSIvNFeRlX5Ra7+WyqmaiQPiFyfg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=UQSE2DWiIR+6tm0arqr/QONs4M/k1hygi23tCuqR5t97CghzmdxHbPEPEtgpZYFb1
	 TdveqimJkt1Lp6Eu77XT3BwfwVocV+Vx1plyAYCUUKRNlNOFGspS4brZgq1NVsKNia
	 8+So41L7CFvTz5XM930+cdHTliOz8Kw51qP+BC/I=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 50F9EC4E; Tue, 23 Jun 2026 04:20:15 +0800
X-QQ-mid: xmsmtpt1782159615tb2yzmgxx
Message-ID: <tencent_276F7EF21CF219623E5C48630C8A64190D06@qq.com>
X-QQ-XMAILINFO: MNcrZJ8uS2untrh1uHkufGqbYsT6RxgySYU6Sm9FMIdTgkFHDEkAYBKNlg84Mj
	 aiIzc1rMGLKm0/0f3KWRocfFc1FKS7rRyljp2NaedUyS+HL/ViHwi57zjbwTU2M1D6oEXwfh57h5
	 Fys9CXQpcSLMyZMaD2V5YD3qJz90WZAfhk2fT5z7OH1JjK1gDrSw3ymChDtQOOfKWuJ8VPFC5k7O
	 N3O26msiOW3eXuw+SK+3p+Y/nUBpC4fRJ+bwjHGtbX2P2TkZqTscN7WilBQYLwBnGmAG4zMmoYCY
	 yH+2UXgVjz0R32I26mhwQqS48fXuf8d8hhYY3nZGSktjJKPx2hIr6oBQ2qZRi/rnzzX3+sKz20ug
	 Rnv5kl0xx+7BA/Lci7Fk1Ccw0MCbDy1MT/WqP3BgKkfJ7kwUm7PEC7r2ObMIo2iZDrzN6U4Vs72C
	 Rk93NSy/Q91nUTbQSGAw6FMVARtVX6o3Q/7FkTQE0qvz1Z3oR0S50wsk9e47u2lX0rTeHanBDv/h
	 K9RpJeqeWUJqOgxvVpzPm0mfrXzKDoYrbk+Ywm1JJXWt6V4Cg1alZhH3igZW/PfdLFjFsTOhTUC1
	 rMiBLJMpT2PgbNL+2XmkqT1BjE56fHblqWmBc3KzQRVcQxATVbWCro7DDoxOad1c4LtbeP4HA6CM
	 0tmajOpDphwDyc0NpRPU5WAcC4ATP0Jr6RYMnCTNO1N1qK6GV+7pSVUDSihCFyEjU44kiV9iTcTb
	 GOJy7P4Sf9JD3eTR10PLW/EC+05eCd2gReHPvtxMW1RDELRJpHdchILdhjWt8UIi6UQNAq/wH8ma
	 vZWI785FdCtk2JLiNfBkOt/kNIg/mFVb7+uNUKHNq0DNvZOYMdHeh7KOfBfYPf7SnXlAdwKLnIHy
	 JNdLfXogyIckL404Hmxt7rZSwtoqwf0w1nrIduXsAdIAZf0f+xuPkwHydgidmwWuhaW3X+B9+BFL
	 2r1uTTnNmNDHIclrye3ZvPO350tZYI8HvVpduXtDMCibe42lsmdN8CJWPeHARUPdcRfuVB36YLpo
	 Jslj0QmDMzBSGsAvEXqDjVnyNUtGpVIsPuiaPDCg1WvsBfQAtsoOlegpSaX6CR2Xr81PTYhRkwSD
	 adMqjs
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <f7d504ad-b626-4952-90f5-2776799f2209@qq.com>
Date: Tue, 23 Jun 2026 04:20:15 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 08/15] btrfs: implement RAID stripe-tree RAID5 writes
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
References: <20260619090211.497100-1-johannes.thumshirn@wdc.com>
 <20260619090211.497100-9-johannes.thumshirn@wdc.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260619090211.497100-9-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Johannes,

I came across the Sashiko AI review [1] of this patch and was able to
reproduce a null pointer dereference during mount on a RAID5 filesystem
with the raid-stripe-tree feature enabled.  I wanted to share the
concrete evidence since it crashes deterministically with KASAN.

 > +    set->stripe_units[i].pstripe = pstripe;

The Sashik identified that btrfs_stripe_set_alloc() stores a
direct pointer into bioc->stripes[] without taking a reference on the
bioc.  When the data bios complete first, the bioc can be freed before
the async parity workqueue dereferences pstripe.  The review also noted
several other issues in the same patch:

- raid56_write_end_io_work() completes the data ordered extent before
   the parity bio finishes — an fsync could return success while data
   remains without parity protection on disk.

- btrfs_submit_raid56_write() overwrites bio->bi_end_io and may leak
   the base bioc allocation reference on every chunk write.

- btrfs_rst_raid56_write() folds the full unsplit bio size into the
   parity buffer, which could cause double-folding on the remainder
   when the caller loops after btrfs_split_bio().

- bio_set_dev(bio, pstripe->dev->bdev) followed by submit_bio()
   will panic on a degraded array where the missing device's bdev
   is NULL.

[Reproduction]

The PoC creates three loopback devices, makes a RAID5 btrfs, then
manually flips the raid-stripe-tree incompat flag in each superblock
(recalculating CRC32C) before mounting.  The null pointer dereference
occurs deterministically during mount in btrfs_read_block_groups().

[Crash log — kernel 7.1.0-g3b216e369cba, CONFIG_KASAN=y, SMP]

   BTRFS info (device loop0): first mount of filesystem df5f7a81-...
   BTRFS info (device loop0): using crc32c checksum algorithm

   Oops: general protection fault, probably for non-canonical address
   0xdffffc0000000020: 0000 [#1] SMP KASAN NOPTI
   KASAN: null-ptr-deref in range [0x0000000000000100-0x0000000000000107]

   RIP: 0010:btrfs_update_global_block_rsv+0x452/0x960
   RAX: 0000000000000020 RBX: 0000000000000000 RCX: 0000000000000000
   RDX: dffffc0000000000 RBP: 0000000000000000

   Call Trace:
    <TASK>
    btrfs_update_global_block_rsv+0x452/0x960
    btrfs_read_block_groups+0x16ee/0x2e20
    open_ctree+0x4804/0x8370
    btrfs_get_tree+0x1346/0x2740
    vfs_get_tree+0x93/0x340
    path_mount+0x7c4/0x2390
    __x64_sys_mount+0x298/0x310
    do_syscall_64+0x129/0x850
    entry_SYSCALL_64_after_hwframe+0x77/0x7f
    </TASK>

   Kernel panic - not syncing: Fatal exception

The PoC is attached below.  It compiles with:

   gcc -o poc poc.c -static

[1] 
https://sashiko.dev/#/patchset/20260619090211.497100-1-johannes.thumshirn%40wdc.com
     (Sashiko AI code review — "Use-After-Free", Severity: High)

Thanks,
XIAOWU

/*
  * PoC: btrfs RAID stripe-tree RAID5 write Use-After-Free
  *
  * Bug: In btrfs_stripe_set_alloc(), raw pointer into bioc->stripes[] is
  * stored as pstripe without incrementing bioc refcount.
  */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mount.h>
#include <sys/wait.h>

#define MOUNT_POINT "/mnt"

int main(void)
{
     char cmd[1024];

     setbuf(stdout, NULL);

     system("losetup -D 2>/dev/null; umount /mnt 2>/dev/null");

     printf("[*] Creating backing files...\n");
     for (int i = 0; i < 3; i++) {
         snprintf(cmd, sizeof(cmd),
             "dd if=/dev/zero of=/tmp/disk%d.img bs=1M count=512 
2>/dev/null", i);
         system(cmd);
     }

     printf("[*] Setting up loop devices...\n");
     for (int i = 0; i < 3; i++) {
         snprintf(cmd, sizeof(cmd), "losetup /dev/loop%d /tmp/disk%d.img 
2>&1", i, i);
         system(cmd);
     }

     printf("[*] Creating RAID5 btrfs...\n");
     system("mkfs.btrfs -f -d raid5 -m raid5 /dev/loop0 /dev/loop1 
/dev/loop2 2>&1");
     system("sync");

     /*
      * Write Python script for superblock update to a file first
      * to avoid quoting issues.
      */
     printf("[*] Writing and running Python fix script...\n");
     system("cat > /tmp/fix_sb.py << 'SCRIPT'\n"
         "#!/usr/bin/env python3\n"
         "import struct, os, sys\n"
         "\n"
         "# CRC32C using polynomial 0x1EDC6F41 (reflected: 0x82F63B78)\n"
         "table = [0] * 256\n"
         "for i in range(256):\n"
         "    crc = i\n"
         "    for _ in range(8):\n"
         "        if crc & 1:\n"
         "            crc = (crc >> 1) ^ 0x82F63B78\n"
         "        else:\n"
         "            crc >>= 1\n"
         "    table[i] = crc\n"
         "\n"
         "def crc32c_calc(data):\n"
         "    crc = 0xFFFFFFFF\n"
         "    for byte in data:\n"
         "        crc = (crc >> 8) ^ table[(crc ^ byte) & 0xFF]\n"
         "    return crc ^ 0xFFFFFFFF\n"
         "\n"
         "# Verify with known test vector\n"
         "test_csum = crc32c_calc(b'\\x00' * 4064)  # 4096-32=4064\n"
         "print(f'Test CRC32C of 4064 zero bytes: {test_csum:08x}')\n"
         "\n"
         "for dev in ['/dev/loop0', '/dev/loop1', '/dev/loop2']:\n"
         "    for sb_base in [65536, 67108864]:\n"
         "        try:\n"
         "            with open(dev, 'r+b') as f:\n"
         "                f.seek(sb_base)\n"
         "                sb = bytearray(f.read(4096))\n"
         "                \n"
         "                # incompat_flags at offset 0xBC (188)\n"
         "                val = struct.unpack('<Q', sb[188:196])[0]\n"
         "                new_val = val | (1 << 14)\n"
         "                print(f'{dev}@{sb_base}: 0x{val:x} -> 
0x{new_val:x}')\n"
         "                struct.pack_into('<Q', sb, 188, new_val)\n"
         "                \n"
         "                # Compute CRC32C over bytes 32..4095\n"
         "                csum = crc32c_calc(bytes(sb[32:4096]))\n"
         "                struct.pack_into('<I', sb, 0, csum)\n"
         "                \n"
         "                f.seek(sb_base)\n"
         "                f.write(bytes(sb))\n"
         "        except Exception as e:\n"
         "            print(f'Error: {e}', file=sys.stderr)\n"
         "os.sync()\n"
         "print('Done!')\n"
         "SCRIPT\n");

     system("python3 /tmp/fix_sb.py 2>&1");

     printf("[*] Attempting mount ro,rescue=ignorebadroots...\n");
     if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_RDONLY,
           "rescue=ignorebadroots,rescue=usebackuproot") != 0) {
         perror("mount with rescue");
         /* Try without usebackuproot */
         if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_RDONLY,
               "rescue=ignorebadroots") != 0) {
             perror("mount simple rescue");
             system("dmesg | tail -5");
             goto cleanup;
         }
     }
     printf("[+] Mounted ro!\n");

     /* Try to remount rw */
     if (mount("/dev/loop0", MOUNT_POINT, "btrfs", MS_REMOUNT, NULL) == 0) {
         printf("[+] Remounted rw!\n");
         unsigned char *buf = malloc(262144);
         if (buf) {
             memset(buf, 0xA5, 262144);
             int fd = open(MOUNT_POINT "/test", O_CREAT | O_RDWR, 0644);
             if (fd >= 0) {
                 for (int i = 0; i < 50; i++) {
                     write(fd, buf, 262144);
                     fsync(fd);
                 }
                 close(fd);
             }
             free(buf);
         }
         sync();
         usleep(500000);
     }
     umount(MOUNT_POINT);

cleanup:
     system("losetup -D 2>/dev/null");
     for (int i = 0; i < 3; i++) {
         snprintf(cmd, sizeof(cmd), "rm -f /tmp/disk%d.img", i);
         system(cmd);
     }
     return 0;
}

