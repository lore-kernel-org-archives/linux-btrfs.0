Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793575695;
	b=Zr1t47MJhX90AO2yiaZL4l56jAgoqpnHbrKXkamVcn9C9Diy5NQxIZSKGbYyj3b4pped
	 uLwqLHOixyCSkVVL9/7Yu57eLOQdMDsIz82bnMyvALeI3zWInzFeqoATavXQ1bkRGRw3+
	 A2zMzBa75s3PdMlahAxcFGZKpVM7t7pszXeC334nvyQmhDyYFyuti0tnZTM6kWjVnKAyB
	 2JVMwEepVtq+kmOwTl5CEAqntju61B2m9QDSvqca6nAcgnx8R1DkU890BXlCpdRBYICZo
	 LXPy0pD4Tsq/rBAJ6HngoW+Iyvdnn6UaCxZH/KsuYzf2UNCg0hPvE80NlAHIS0fNQbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793575695;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=ZdRU5PK2BI+TXEGKC+siQKApzCSgmzmTFFnge90aTgM=;
	b=dk2nHBzUxYsGl2l0BG2wJ9s52vbmVZxqmQQnHI/sqXTE2BdQnZZtzWyWgQu+z5ofQl3A
	 92aUS4EPZI9Ia056MreG4PNrnI35VcT3bkjxji8gZ8k8mvR/Aix3PqowWDhRgsyV7hzBo
	 T+qLABTRzjmu5cBPucJioRd0hQBwBNmYK2s+iYR1xHRNon5nlbV0FBT0WE/iXiz8EaLb2
	 PpbuJHDDc1cMQO6xP0oSKM/MYSu85CdyvKmsxA80EoPa1a8UwS/kpIEoGZfmhdEQAW5Bm
	 E5lEaWxYhaqqFaXIEQHYSxKh/hibL8AdYMoJ3G9+6LlGFa1YozHXyNnhJIF+nS8hsKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x94nLSJY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA46606A33E
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 23:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAA46606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x94nLSJY
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so386255566b.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 15:28:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793575693; cv=none;
        d=google.com; s=arc-20260327;
        b=l90dc5mb3uYbdcUuaBv1aXGtlyywwubTnHon4TK1ajwrg7KuSe709PP1/Nd7jeI1yU
         vZmQZQJU7U6RpZrV+yjuwUx1UcPmR14YD0kNemXQDH+8UAoL2flVc1m5E4N35ELrP1sj
         Nb6AiBrkOUEQym1/4uaDisilcNtw6K+GlfI1VULYPd1KYVEz5taSloOE+rY7OIncSXrF
         zAztV19oqq9jEBxPpfqcFTyWFFx9SMX7+czVh+CcsQNNxgs6ZeLRuDLPt8qDd1uN/cgw
         I5FYVotIm5ImZgizU6erzOYwq5N0mqYPLtegN699mLxvr76dv7zj8skxqOZRAQzbiVzu
         3ihQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZdRU5PK2BI+TXEGKC+siQKApzCSgmzmTFFnge90aTgM=;
        fh=k+4T1j4iJUKtyOQR0/0mQ24KF4z47QOxaqQu9sD1N/Q=;
        b=akCP2q282oxX1c7YO78JutGdALB+sy08As0IBbAqIGa39MhhmTUT6lDnpwqt0xjmI7
         XJ6cZc6M8gq8zUZCYv0ZFQC9Y2FE2NV4TPmmtAfVGgaWRZ+Kh++yJb00T0nxr/M1fT11
         vashK3DA9c6dbkGsVVZLAMechDx571ve8JL216Y5hkkkptTed7NCGjk9cOJrhrEoKLHe
         s6K10bfR0ibqYvNOXrtnDYyOS4V2ZE6yf+TvXOU/sYVun1Cc8FfCDsoO06/lZwGkp8l+
         /yZN8JRpGU6fXMc8oXu25J+Ohh0uOw1xMZMNBv0OLmU/g/r+I7uA2MaBLZ8hCAuDpMIu
         WvBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793575693; x=1794180493; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZdRU5PK2BI+TXEGKC+siQKApzCSgmzmTFFnge90aTgM=;
        b=x94nLSJYJkLNjnms3c6tQStH4YK8vJMNObQ0qtTjnZP6EH9pZu97PWBf9SBxT4wpNR
         aB6kBLrmGti1v15sDejoCpRqImRHKCG3iaQI+D4H4/D+1lTK/0AJz8BtczmzzmhIHFqx
         lbvT086zLmg6oLuD9nXR1+4h/JaONIOLKhV/X8wpxlEpfNk0UIvgqXAVYrMiw3qjQcoE
         orMzU5D7GoD8OMR1ua3rA+FhOykClgDHjpLpAWw2zNDgBeI0J6qJMQStc8aiSyY94VMc
         y9b9SY6KIu9kX71UNTZyWkYkUQyzDgbzRg7YdsEXzhqYrsJncL+qumlv+fq/id3lnVww
         BQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793575693; x=1794180493;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZdRU5PK2BI+TXEGKC+siQKApzCSgmzmTFFnge90aTgM=;
        b=Y22iS5jgsqoGofPvlbppAKhH49PN5925/HRY3CIucNnxL3xw+yZZQfWFFgZbZi9IHF
         3gXesVJzRPMZW1aDVl7eWHeDvriOjDyvHQnenZbLmfbDRFylFW0O3gAdWrKSFctlbHf/
         uVhGV1xj370v7TsopoCWFBpwhzZpnitE9G6ojr9Et7JeG3eV9dPCqCRg7WQFN8EA0fLy
         BC2mLtUOPV7ieyzh3qWLDDghTI/2RPSFDVB3/u0gLSINj0pTWg7sYI2WGpZqshHhTCEc
         kOsN/sAfga+wJ0sgyyu5CZahN0rYAn/F0w4uUpyRZhLLLs8a+v+cNkO7HhwAS5LYEW4C
         f9wA==
X-Gm-Message-State: AFq9FYIVI0bwztfdj9evjqCJgqSWfxnJMS24TXIF+OO9D9Fn9Dba9/8/
	R42SSQHQHu8egQGeaXCNL2StkvkaZq6kMmGHjX92/mk+Akg16XGvD7k3U/7hBfIzcFiklfd/VzH
	vb1Qu6OQN2bk+xomapIh1iXmGGrNcfPYSmdd2
X-Gm-Gg: AYBFou2Op8EpvGdpIqUAHFd8Ehscz84LCUrLON96Gxy7TledFx2bWNQ80DzWcmBi0FC
	iyxSqwvObGVLJDCiu9po4wERjf2K9vQ8ZuCtwIdRJLCOlUeJY5Js6Cc4BB43KnVai40tPlC3NUr
	2GRxUtPUM+y8Hx0PmZUK8wMjomHTsIs4vgEaAqWffw2ret8PZiu83UPdYMMkmTHdaKcx/sVOtRh
	x2aNHkkNMdJ9ZcU42hP+SET2RqVi4H6ua+fvQCh7QuEKtWUirD1Dsw44uaDXxwiuDc2D8AkOjun
	YKJ0i50pySjlEVevPF9qGVJSqx6Ed1mQMflv2RRkFyIhd+yFrMtB8plGwxJqHeM/+DRWJVzSYCn
	xvBDyP52Y7/IukDqHTtHyU/vxvkG8FgIMZ43WDS97JLeXX0SSdRjVKTZTheuf0zVtB0/jsOqlaE
	p6Tij5KBUOOi5AabjSltxw04UTzwS94Idqx7lw4unhmhpMPJipuvif6h2tqimjKXEloU/zX8DX4
	UjLAg82pM1fI5kb3dveXxkwdGQWuFkx7Y88PA==
X-Received: by 2002:a17:906:ee81:b0:c26:19de:9126 with SMTP id
 a640c23a62f3a-c4ca7a4f360mr676270266b.25.1793575692910; Sun, 01 Nov 2026
 15:28:12 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAhqjAK5mOJrgZqG-ZrgKt12Dm4AFJeapiFbBNpRv+qUns_d-A@mail.gmail.com>
 <CAAhqjALj6mq=wx43sshav-uOxei2nXeMu4nfmQmu_az7Nbig=g@mail.gmail.com> <2179facd-fe1e-42eb-8416-38d534e8b0dc@redhat.com>
In-Reply-To: <2179facd-fe1e-42eb-8416-38d534e8b0dc@redhat.com>
From: Aaron Bohenick <bohenick@gmail.com>
Date: Sun, 1 Nov 2026 18:27:36 -0500
X-Gm-Features: AclHuK_rf3UBwoGU5b8fD-kuU54cr35Pw70LQZF8N1H0qByDjqQyfQyKYCARoyc
Message-ID: <CAAhqjA+Lat+JZ3N58x19VD2U9BpzPuzaZ=0TMwQygwg=DVocow@mail.gmail.com>
Subject: Re: Parent transid failures in extent/dev/free-space trees after lost
 writes; open_ctree -5, restore works - advice before repair?
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: linux-btrfs@vger.kernel.org, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zdenek,

Thank you very much for taking the time to write such a detailed and
careful reply. It changed how I read my own data, and the correction on
the selection effect is well taken. Below is everything you asked for,
in your order. All of it was collected read-only: the origin LV and the
cache SSD are still blockdev --setro, the cache PV is still invisible to
LVM (its md/GPT labels are erased), and the cache target has not been
activated. Times are EST/EDT as shown.

The headline results:
- The cmeta clean-shutdown flag is NOT set (superblock flags =3D 0x0).
  So, as you said, "0 dirty" means nothing here.
- The LV was created writethrough and stayed writethrough; the LVM
  archive shows no writeback period.
- The stale blocks are spread over all four RAID6 members and many
  stripes, not one member or region.
- No kernel log from before the failure survives.

1. Kernel logs
--------------
journalctl --list-boots shows only the current boot; the persistent
journal starts 2026-10-30 15:07:50 EDT. /var/log is a tmpfs on this NAS,
and /sys/fs/pstore and /var/lib/systemd/pstore are empty. So the logs
before the reinstall/failed boots are gone, and nothing from the run in
which the stale writes happened survives.

The ring buffer of the current boot (starts 2026-10-29 22:19:39 EDT)
does show one thing that may matter:
  22:19:49 md/raid1:md0: active with 1 out of 1 mirrors
  22:19:49 md0: detected capacity change from 0 to 1953259520
  22:20:06 md0: detected capacity change from 1953259520 to 0
  22:20:06 md: md0 stopped.
  22:20:06 md/raid:md0: not clean -- starting background reconstruction
  22:20:06 md/raid:md0: raid level 6 active with 4 out of 4 devices,
           algorithm 2
  Oct 30 22:14:07 md: md0: resync done.
The first md0 (RAID1, 1953259520 sectors =3D 931.4 GiB) is the cache
SSD's array; it was assembled at this boot and then stopped so the RAID6
could take the md0 name. That boot began about 48 minutes after the
forced uncache (21:31:53), so the cache SSD was visible again by then.
The RAID6 came up "not clean" (unclean shutdown) and resynced. No
I/O errors, faulty/removed/re-added members or dm-cache messages appear
in this boot.

2. md facts
-----------
md0: RAID6, 4/4 devices, layout left-symmetric (algorithm 2), chunk
512K, state clean, events 50001, updated 2026-10-30 22:14:10.
All four members (mdadm --examine): data offset 262144 sectors, events
50001, update time 2026-10-30 22:14:10, array state AAAA, bad-block log ena=
bled
(mdadm --examine-badblocks: list is empty on all four).
Slots / serials (WD140EDGZ 14 TB):
  0 sdb4 PMG5YHRP 1 sdc4 T1G9NKRN 2 sdd4 PMG5SB9P 3 sda4 PMG5P5XP
SMART on all four: PASSED; Reallocated_Sector_Ct 0, Current_Pending 0,
Offline_Uncorrectable 0, UDMA_CRC_Error_Count 0. No member has a lower
event count. (Event counts reflect the post-resync state, not the period
of the lost writes.)

3. /etc/lvm/archive and /etc/lvm/backup
---------------------------------------
Both survive (the system disk was not recreated). vg0 history, with the
cache segment's settings where present:
  00009 seq12 2026-01-07 08:41 before 'vgreduce vg0 /dev/md1 --force'
  00010 seq13 2026-01-08 10:34 before 'vgextend vg0 /dev/md1'
  00011 seq14 2026-01-08 10:34 before 'lvcreate --type cache-pool -l
100%FREE ...'
  00012 seq17 2026-01-08 10:34 before 'lvconvert --type cache --cachepool v=
g...'
  00013 seq18 2026-01-08 10:34:43 before 'lvchange --cachemode
writethrough vg0/lv0'
        -> cache_mode =3D "writethrough", policy "smq"
  00014 seq19 2026-06-25 04:20 before 'pvresize -y /dev/md0' -> writethroug=
h
  00015 seq20 2026-08-13 00:46 before 'pvresize -y /dev/md0' -> writethroug=
h
  00016 seq21 2026-10-29 21:31:53 before 'lvconvert --uncache -y
--force vg0/lv0'
        -> writethrough, metadata_format 2, chunk_size 2048, smq
  00017 seq22 2026-10-29 21:31:55 before 'vgreduce vg0 --removemissing'
  00018 seq23 2026-10-30 22:14:10 before 'pvresize -y /dev/md0'
  backup/vg0: seq 24
The cache LV already shows writethrough in the archive taken right
before the explicit lvchange, and every later archive is writethrough,
so as far as LVM metadata goes the table was never writeback.
(Archive 00009 also shows an older cache PV, /dev/md1, removed with
vgreduce --force on 2026-01-07 before this cache was recreated on
2026-01-08.)

4. pvck on the cache PV
-----------------------
Run on a read-only loop of my image copy (PV label at image offset 0):
cache PV: mda_header_1 at 4096, size 1044480; "metadata text at 22016
  crc 0x9b973d59 # vgname vg0 seqno 21".
origin PV (md0): "metadata text at 55808 crc 0x4f41351f # vgname vg0
  seqno 24".
So LVM last wrote the cache PV at seqno 21, i.e. before the forced
uncache (seq 21 -> 22 happened without the cache PV present).

5. cache_check / cache_dump / clean-shutdown flag
-------------------------------------------------
cmeta superblock (from the image): flags =3D 0x0 (CLEAN_SHUTDOWN not set,
NEEDS_CHECK not set), magic 1623043 (06142003 octal) OK.
cache_check: superblock, mapping array, hint array and discard bitset
all pass. cache_dump: block_size 2048, nr_cache_blocks 953640, policy
smq, hint_width 4, 953634 mappings, 0 dirty in the bitset.
So by your reading the kernel would have treated all 953634 blocks as
dirty on the next load, and an offline cache_writeback should write the
whole cache back.

6. Kernel
---------
uname -a: Linux skarbnik 6.12.63+ #15 SMP PREEMPT_DYNAMIC Tue Mar 31
12:21:36 CST 2026 x86_64 GNU/Linux
/proc/version: Linux version 6.12.63+ (root@5368ac87aaad)
(x86_64-tnas-linux-gnu-gcc.br_real (Buildroot 2023.08.1) 13.2.0, ...)
#15 SMP PREEMPT_DYNAMIC Tue Mar 31 12:21:36 CST 2026
This is TerraMaster's Buildroot vendor build; I do not have their patch
set. TerraMaster support is involved and I will ask them for it.

7. Physical-offset test
-----------------------
PV pe_start 2048 sectors, lv0 starts at extent 0, RAID6 left-symmetric,
4 members, 512 KiB chunk, data offset 262144 sectors. Mapping the 20
stale 64 KiB block copies (10 blocks x DUP) to members:
  sdb4 PMG5YHRP: 6 sdc4 T1G9NKRN: 6 sdd4 PMG5SB9P: 2 sda4 PMG5P5XP: 6
They fall on stripes from 26 to 15,990,449, i.e. spread across the whole
array and every member, not one member or one contiguous region. Per
your test, that points away from md and back toward the layer above it.

Summary of where I stand
------------------------
Writethrough throughout, unclean cache metadata, stale blocks spread
across all members, and the cache holding the current copies. I am
considering applying
your Q2 procedure, but I want to have all my ducks in a row before I
touch anything. As I understand it, the plan would be: offline
cache_writeback from a copy of cmeta (needs-check cleared on the copy
only), cdata read-only, onto a dm-snapshot of the origin with about
1 TiB of COW, no LVM and no cache target; then a read-only Btrfs mount
and check on the snapshot; and then, per your Q3 answer, copy everything
off and recreate rather than trust the repaired filesystem in place. I
am also coordinating with TerraMaster support, who have offered a remote
session, so nothing will be run until I am confident in the plan. If you
see a flaw in it, a step I have missed, or anything above that changes
your view, I would be grateful to hear it.

All raw output (dmesg, mdadm, LVM archive/backup, pvck dumps, cmeta
flags, offset script and results) is bundled and available on request.

Thank you again for your time and help.

Best regards,
Aaron

On Sun, Nov 1, 2026 at 2:10=E2=80=AFPM Zdenek Kabelac <zkabelac@redhat.com>=
 wrote:
>
> Dne 01. 11. 26 v 18:50 Aaron Bohenick napsal(a):
> > Hi,
> >
> > Follow-up to my report below, with new findings that change the
> > question. Cc'ing dm-devel because this now looks like a dm-cache
> > (lvmcache) issue underneath Btrfs. Everything below was read-only; the
> > origin LV and the cache SSD are both blockdev --setro and nothing has
> > been written to either. The NAS vendor's (TerraMaster) support is also
> > involved.
> >
> > Short version: the detached cache SSD holds the current, checksum-valid
> > copy of every Btrfs metadata block that is stale on the origin, but the
> > cache metadata marks every cached block clean (0 dirty), so a forced
> > uncache dropped them.
> >
> > How the cache was detached
> > --------------------------
> > LVM metadata history on the origin PV (vg0 on md RAID6), times EDT:
> > - seqno 23, 2026-10-29 21:31:53: "lvconvert --uncache -y --force vg0/lv=
0"
> > - seqno 24, 2026-10-29 21:31:55: "vgreduce vg0 --removemissing"
> > The cache PV (an md RAID1 on one NVMe) was not assembled after a vendor
> > OS update/restart, and the vendor OS forced the uncache. Cache mode in
> > the LVM metadata: writethrough.
> >
> > Cache metadata (cache_check passes on an image of the cmeta LV)
> > ---------------------------------------------------------------
> > block_size=3D2048 sectors (1 MiB), nr_cache_blocks=3D953640, policy=3Ds=
mq,
> > hint_width=3D4; 953634 mappings, 0 dirty.
> >
> > Damaged Btrfs blocks: origin copy vs cached copy
> > ------------------------------------------------
> > 64 KiB nodes read from the origin LV and from the cdata area on the SSD
> > (cache block N at cdata + N MiB). crc32c and bytenr checked for every
> > copy. Format gen/owner; both DUP copies agree unless noted.
> >
> > logical wanted origin cached
> > 26935296 917953 910413/3 (copy0) 917953/3
> > 13608045117440 918517 879195/7 918517/8
> > 15797806039040 917945 917909/2 917945/4 (dev tree)
> > 12777307766784 918507 610497/258 918507/2 (extent tree)
> > 12777308094464 918507 608008/258 918507/2 (extent tree)
> > 12777309929472 918507 917901/7 lvl 1 918507/2 lvl 0
> > 13607943929856 918513 604537/260 918513/258
> > 13608042430464 918517 610816/258 918517/260 lvl 2 (subvol root)
> >
> > Every cached copy has a valid checksum and exactly the generation Btrfs
> > expects. The origin copies are valid but much older blocks from other
> > trees. All 20 damaged copies (10 blocks x DUP) are inside cached origin
> > blocks, while overall only 51.4% of metadata blocks (23181/45056) and
> > 5.8% of data blocks were cached. The cache also holds blocks from the
> > final transaction (918517), so it was in use until the end.
> >
> > So for some hot metadata blocks, writes stopped reaching the origin
> > (some since around generation 604537, weeks to months earlier) while
> > reads were served from the cache, and the cache never considered those
> > blocks dirty.
> >
> > Questions
> > ---------
> > 1. For dm-cache: is there a known way a writethrough cache can end up
> >     with cached blocks that are newer than the origin but marked clean?
> >     (Kernel 6.12.63+ on a TerraMaster F4-424 Pro, TOS 7.0.1341.)
> > 2. Safest recovery: re-create the cache mapping by hand (origin lv0,
> >     cmeta, cdata, block size 2048, smq) over dm-snapshot overlays and
> >     test a read-only Btrfs mount; or copy the cached metadata blocks on=
to
> >     the origin after testing on an overlay? Anything to watch for, e.g.
> >     policy hints, or LVM auto-cleaning the outdated cache PV's metadata
> >     if its md/GPT labels are restored (they are currently erased, so LV=
M
> >     cannot see it)?
> > 3. For Btrfs: if the cached versions are put back, is a full
> >     btrfs check --readonly plus scrub enough to trust the filesystem, o=
r
> >     should I still plan to copy everything off and recreate it?
> >
> > I can provide the cache_dump, the comparison script and output, the
> > LVM metadata text from both PVs and the 97 MiB cmeta/LVM image.
> >
>
>
> Hi Aaron,
>
> On Q1: I do not know of a kernel release that fixed this, because I canno=
t
> find a dm-cache writethrough bug with this shape. The only dm-cache
> coherency fixes after 6.12 are the passthrough-mode series from Ming-Hung
> Tsai (Feb 2026, v7.1, no Cc: stable, so not in 6.12.63), and they have th=
e
> opposite signature: passthrough maps writes to the origin and invalidates
> the cache entry, so those bugs make the cache return stale data while the
> origin stays correct. Your data has the cache correct and the origin
> stale.
>
> The writethrough path does not obviously allow your state either. A write
> that hits a clean block goes to origin and cache in parallel with
> bio_chain(), so the bio does not complete until both are done and an
> origin error propagates. A dirty block is cleared only after a successful
> copy to the origin. A write miss goes to the origin and is not cached. A
> clean mapped block should therefore always match the origin. That leaves
> two candidates: the origin lost an acknowledged write below dm, or the
> table was not actually writethrough while it ran. The second is easy to
> rule out from /etc/lvm/archive if the NAS still has it.
>
> Related, and important for reading your dump: the dirty bitset is written
> by sync_metadata(), and the clean-shutdown flag is only set if all the
> metadata writes in that pass succeeded. On load, if that flag is clear,
> the kernel ignores the bitset and marks every mapping dirty
> (__load_mapping(): "bool dirty =3D true; if (cmd->clean_when_opened) dirt=
y
> =3D ..."). So "0 dirty" means nothing unless the metadata was cleanly shu=
t
> down. If it was not, the kernel considered all 953634 blocks dirty.
>
> On Q2: use the offline tools; no dm-cache target and no LVM. Work only on
> a copy (you already have the 97 MiB cmeta image):
>
>    dd if=3D<cmeta> of=3Dcmeta.img bs=3D1M
>    cache_check cmeta.img
>    cache_check --clear-needs-check-flag cmeta.img     # copy only
>    cache_writeback --metadata-device cmeta.img \
>        --fast-device <cdata> --origin-device <origin snapshot> \
>        --no-metadata-update --list-failed-blocks
>
> cache_writeback writes only dirty blocks and cannot run on a live cache.
> If the metadata was not cleanly shut down it should treat every mapping a=
s
> dirty and write the whole cache back, about 930 GiB; that makes the origi=
n
> an exact copy of the cache state, and blocks that were already identical
> are a no-op. If it writes nothing, the metadata was clean; then select th=
e
> blocks yourself:
>
>    cache_dump cmeta.img > cache.xml
>    # <mapping cache_block=3D"N" origin_block=3D"M" dirty=3D"false"/>
>    # set dirty=3D"true" on the blocks you want, then:
>    cache_restore -i cache.xml -o cmeta-fixed.img
>    cache_writeback ... --metadata-device cmeta-fixed.img
>
> Write to a snapshot of the origin so the real one stays untouched, and
> size the COW for up to 930 GiB. cdata is only read, so it needs no copy.
> Do not re-activate the cache target: activation commits to cmeta and, on
> an unclean metadata, starts writing back on its own schedule.
>
> On Q3: no, btrfs check --readonly plus scrub is not sufficient. Your
> damage is "valid checksum, stale content", which checksums cannot detect:
> scrub compares data against metadata checksums, and those match the stale
> block. Only generation/transid and tree-structure checks catch it, and
> only for blocks that are visited. Plan to copy out and recreate, or keep =
a
> full pre-repair image and diff against it later.
>
> Also, "all 20 damaged copies are in cached blocks, while only 51.4% of
> metadata blocks were cached" is a selection effect: you found the damage
> by comparing origin against cdata, so only cached blocks can show it, and
> hot tree roots are exactly what a cache holds.
>
> What would settle it, in order of value:
>
> 1. Kernel log from the last healthy boot through the failed boots:
>     journalctl -k -b -1 and -b, /var/log/kern.log, /var/log/messages.
>     Look for "md/raid", "md0", "resync", "recovery", "faulty", "removed",
>     "re-added", "md: marking", "I/O error", "blk_update_request"; and for
>     "dm_cache" / "device-mapper: cache": "switching cache to read-only
>     mode", "switching cache to fail mode", "metadata operation ...
>     failed". md logs loudly, dm-cache is silent on the healthy path, so
>     absence of cache errors proves nothing.
>
> 2. md facts: mdadm --detail, mdadm --examine on every member (event
>     counts), chunk size, and which serial sits in which slot. If one
>     member has a lower event count or appears in a kick/re-add, stop ther=
e.
>
> 3. /etc/lvm/archive and /etc/lvm/backup from the NAS: the only reliable
>     way to see whether the cache mode was ever changed to writeback, and
>     when the cache PV last received a metadata update.
>
> 4. pvck --dump metadata on the cache PV: its VG seqno versus the origin
>     PV's seqno tells you when LVM last wrote that PV, independently of th=
e
>     metadata text you already have.
>
> 5. cache_dump and cache_check output, and whether the cmeta superblock
>     clean-shutdown flag is set.
>
> 6. uname -a, /proc/version, and the TOS kernel source or patch set. A
>     vendor 6.12.63 with out-of-tree patches is the one gap I cannot reaso=
n
>     about from upstream.
>
> 7. The physical-offset test, which needs only the images you already have=
:
>     compute the RAID6 chunk-to-member mapping (mdadm --detail gives the
>     chunk size and layout) for the 10 stale 64 KiB blocks. If they land o=
n
>     one member, or on one contiguous region of it, that is md, not
>     dm-cache.
>
> If the pre-reinstall logs are gone, say so early: then the md history is
> unrecoverable and the block-offset test plus the LVM archive are what is
> left.
>
> Keep the cache PV invisible to LVM throughout (device filter, do not
> import the VG): a stray pvcreate, vgreduce or lvconvert --repair can
> rewrite exactly the metadata you are depending on.
>
> Thanks,
>
> Zdenek
>
