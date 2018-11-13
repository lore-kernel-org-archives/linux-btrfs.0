Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAEDC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 13:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30EC22419
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 13:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQo8rRDp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C30EC22419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733232AbeKMX2U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:28:20 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38598 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbeKMX2T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 18:28:19 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so4330006oii.5
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 05:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+09exR/IN5DVLc1TpadMZry0j1nv608AhvYD5Q73RYA=;
        b=PQo8rRDpesIR4NvyUMbAuvNPSDYBeIJK5CbUl4P5ri2WFfVee/3fPau9qP3L/AI9ra
         j1kJIXA5VF5/5TnTdeCuWHwKSCgl8V/voLSkekoo5qvoJjRAGNvf/KeMFqd9lDP7MhCd
         qGIeyRonOb3hoLAzxuR6zbfaqYbSBbnJaZKb7xQZDaNRKuByCdULdcAxXH3hda+/y+mx
         XnFqYeIlGqJXHuiKxrj+DhJKbE+W8o7VTFSd3lCBysAj9Q123UlJaTJ8+VNct0Fe3rAN
         Lj0aoKgSlbi5ul1H6YrCNLfQ/ByfKfPgclmq4I4R0ZHx7SaTKwm1gcNTSyrrxJ5JyoGN
         F+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+09exR/IN5DVLc1TpadMZry0j1nv608AhvYD5Q73RYA=;
        b=qYKosDCt5uuDcEvr52jBIJvgj11Tecmicjx4E/QwfwBTFgPYTBQg+kfAxiWBV+7BK3
         C7cY7OKasOZcEaBGuIqUgd67Rok6uk3TlIyCI7zXh7WuOT08TNqWUOA/B5Eoc5MrkyH8
         3M4f2qajXu85Hx1615GGzy2g5DfxNG6dHMqVPsQ6Ijjlk6De1+jgI0a+Kqs+JodpC7Ky
         n6UYCog4ViYHrKeA9Lq3lLbHUdSJ9ldQ2VQ0Rnsw88uaMxOYrJGjY6puGayxOVuJMyu6
         V4TlLNcsVvWQFiSKpSDDxdhB595yGtMPgF4stRErNFpdJg94Ub1fQeLapAeuLoeyuGs5
         7Jvg==
X-Gm-Message-State: AGRZ1gJoq7CPOuUqzSPifARq4qqTEMMfV7ynKmwN+J6OiOt2cw3adRUi
        iW3/ORzjJPuc2bt86KWG6Uzh/lVDYQG+d2SkB2rup8PJKMM=
X-Google-Smtp-Source: AJdET5dmIpIOOGwv7+TYfkp+TzZ0l5aD8FqnsheSbpiZkTidG2gXtN+eom7BPacrUSOMqx9feg/8s39lJAGdXoxOvE4=
X-Received: by 2002:aca:dcd7:: with SMTP id t206-v6mr3102239oig.59.1542115809873;
 Tue, 13 Nov 2018 05:30:09 -0800 (PST)
MIME-Version: 1.0
References: <20181031181108.289340-1-terrelln@fb.com> <20181113003332.GV24115@twin.jikos.cz>
 <2E6AE257-ED1B-4C21-847C-AB6CB49B9244@fb.com>
In-Reply-To: <2E6AE257-ED1B-4C21-847C-AB6CB49B9244@fb.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Tue, 13 Nov 2018 16:29:33 +0300
Message-ID: <CAGqmi77AX+3i3jghFVRsMheMANyhP2qU-UsyxEhu1CJsBsG_6Q@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: add zstd compression level support
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, Kernel-team@fb.com, osandov@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jenniferliu620@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

=D0=B2=D1=82, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 04:52, Nick =
Terrell <terrelln@fb.com>:
>
>
>
> > On Nov 12, 2018, at 4:33 PM, David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Oct 31, 2018 at 11:11:08AM -0700, Nick Terrell wrote:
> >> From: Jennifer Liu <jenniferliu620@fb.com>
> >>
> >> Adds zstd compression level support to btrfs. Zstd requires
> >> different amounts of memory for each level, so the design had
> >> to be modified to allow set_level() to allocate memory. We
> >> preallocate one workspace of the maximum size to guarantee
> >> forward progress. This feature is expected to be useful for
> >> read-mostly filesystems, or when creating images.
> >>
> >> Benchmarks run in qemu on Intel x86 with a single core.
> >> The benchmark measures the time to copy the Silesia corpus [0] to
> >> a btrfs filesystem 10 times, then read it back.
> >>
> >> The two important things to note are:
> >> - The decompression speed and memory remains constant.
> >>  The memory required to decompress is the same as level 1.
> >> - The compression speed and ratio will vary based on the source.
> >>
> >> Level        Ratio   Compression     Decompression   Compression Memor=
y
> >> 1            2.59    153 MB/s        112 MB/s        0.8 MB
> >> 2            2.67    136 MB/s        113 MB/s        1.0 MB
> >> 3            2.72    106 MB/s        115 MB/s        1.3 MB
> >> 4            2.78    86  MB/s        109 MB/s        0.9 MB
> >> 5            2.83    69  MB/s        109 MB/s        1.4 MB
> >> 6            2.89    53  MB/s        110 MB/s        1.5 MB
> >> 7            2.91    40  MB/s        112 MB/s        1.4 MB
> >> 8            2.92    34  MB/s        110 MB/s        1.8 MB
> >> 9            2.93    27  MB/s        109 MB/s        1.8 MB
> >> 10           2.94    22  MB/s        109 MB/s        1.8 MB
> >> 11           2.95    17  MB/s        114 MB/s        1.8 MB
> >> 12           2.95    13  MB/s        113 MB/s        1.8 MB
> >> 13           2.95    10  MB/s        111 MB/s        2.3 MB
> >> 14           2.99    7   MB/s        110 MB/s        2.6 MB
> >> 15           3.03    6   MB/s        110 MB/s        2.6 MB
> >>
> >> [0] https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__sun.aei.pols=
l.pl_-7Esdeor_index.php-3Fpage-3Dsilesia&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3=
MUw&r=3DHQM5IQdWOB8WaMoii2dYTw&m=3D5LQRTUqZnx_a8dGSa5bGsd0Fm4ejQQOcH50wi7nR=
ewY&s=3DgFUm-SA3aeQI7PBe3zmxUuxk4AEEZegB0cRsbjWUToo&e=3D
> >>
> >> Signed-off-by: Jennifer Liu <jenniferliu620@fb.com>
> >> Signed-off-by: Nick Terrell <terrelln@fb.com>
> >> Reviewed-by: Omar Sandoval <osandov@fb.com>
> >> ---
> >> v1 -> v2:
> >> - Don't reflow the unchanged line.
> >>
> >> fs/btrfs/compression.c | 169 +++++++++++++++++++++++++----------------
> >> fs/btrfs/compression.h |  18 +++--
> >> fs/btrfs/lzo.c         |   5 +-
> >> fs/btrfs/super.c       |   7 +-
> >> fs/btrfs/zlib.c        |  33 ++++----
> >> fs/btrfs/zstd.c        |  74 +++++++++++++-----
> >> 6 files changed, 202 insertions(+), 104 deletions(-)
> >>
> >> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> >> index 2955a4ea2fa8..b46652cb653e 100644
> >> --- a/fs/btrfs/compression.c
> >> +++ b/fs/btrfs/compression.c
> >> @@ -822,9 +822,12 @@ void __init btrfs_init_compress(void)
> >>
> >>              /*
> >>               * Preallocate one workspace for each compression type so
> >> -             * we can guarantee forward progress in the worst case
> >> +             * we can guarantee forward progress in the worst case.
> >> +             * Provide the maximum compression level to guarantee lar=
ge
> >> +             * enough workspace.
> >>               */
> >> -            workspace =3D btrfs_compress_op[i]->alloc_workspace();
> >> +            workspace =3D btrfs_compress_op[i]->alloc_workspace(
> >> +                            btrfs_compress_op[i]->max_level);
>
> We provide the max level here, so we have at least one workspace per
> compression type that is large enough.
>
> >>              if (IS_ERR(workspace)) {
> >>                      pr_warn("BTRFS: cannot preallocate compression wo=
rkspace, will try later\n");
> >>              } else {
> >> @@ -835,23 +838,78 @@ void __init btrfs_init_compress(void)
> >>      }
> >> }
> >>
> >> +/*
> >> + * put a workspace struct back on the list or free it if we have enou=
gh
> >> + * idle ones sitting around
> >> + */
> >> +static void __free_workspace(int type, struct list_head *workspace,
> >> +                         bool heuristic)
> >> +{
> >> +    int idx =3D type - 1;
> >> +    struct list_head *idle_ws;
> >> +    spinlock_t *ws_lock;
> >> +    atomic_t *total_ws;
> >> +    wait_queue_head_t *ws_wait;
> >> +    int *free_ws;
> >> +
> >> +    if (heuristic) {
> >> +            idle_ws  =3D &btrfs_heuristic_ws.idle_ws;
> >> +            ws_lock  =3D &btrfs_heuristic_ws.ws_lock;
> >> +            total_ws =3D &btrfs_heuristic_ws.total_ws;
> >> +            ws_wait  =3D &btrfs_heuristic_ws.ws_wait;
> >> +            free_ws  =3D &btrfs_heuristic_ws.free_ws;
> >> +    } else {
> >> +            idle_ws  =3D &btrfs_comp_ws[idx].idle_ws;
> >> +            ws_lock  =3D &btrfs_comp_ws[idx].ws_lock;
> >> +            total_ws =3D &btrfs_comp_ws[idx].total_ws;
> >> +            ws_wait  =3D &btrfs_comp_ws[idx].ws_wait;
> >> +            free_ws  =3D &btrfs_comp_ws[idx].free_ws;
> >> +    }
> >> +
> >> +    spin_lock(ws_lock);
> >> +    if (*free_ws <=3D num_online_cpus()) {
> >> +            list_add(workspace, idle_ws);
> >> +            (*free_ws)++;
> >> +            spin_unlock(ws_lock);
> >> +            goto wake;
> >> +    }
> >> +    spin_unlock(ws_lock);
> >> +
> >> +    if (heuristic)
> >> +            free_heuristic_ws(workspace);
> >> +    else
> >> +            btrfs_compress_op[idx]->free_workspace(workspace);
> >> +    atomic_dec(total_ws);
> >> +wake:
> >> +    cond_wake_up(ws_wait);
> >> +}
> >> +
> >> +static void free_workspace(int type, struct list_head *ws)
> >> +{
> >> +    return __free_workspace(type, ws, false);
> >> +}
> >> +
> >> /*
> >>  * This finds an available workspace or allocates a new one.
> >>  * If it's not possible to allocate a new one, waits until there's one=
.
> >>  * Preallocation makes a forward progress guarantees and we do not ret=
urn
> >>  * errors.
> >>  */
> >> -static struct list_head *__find_workspace(int type, bool heuristic)
> >> +static struct list_head *__find_workspace(unsigned int type_level,
> >> +                                      bool heuristic)
> >> {
> >>      struct list_head *workspace;
> >>      int cpus =3D num_online_cpus();
> >> +    int type =3D type_level & 0xF;
> >>      int idx =3D type - 1;
> >> -    unsigned nofs_flag;
> >> +    unsigned int level =3D (type_level & 0xF0) >> 4;
> >> +    unsigned int nofs_flag;
> >>      struct list_head *idle_ws;
> >>      spinlock_t *ws_lock;
> >>      atomic_t *total_ws;
> >>      wait_queue_head_t *ws_wait;
> >>      int *free_ws;
> >> +    int ret;
> >>
> >>      if (heuristic) {
> >>              idle_ws  =3D &btrfs_heuristic_ws.idle_ws;
> >> @@ -874,8 +932,17 @@ static struct list_head *__find_workspace(int typ=
e, bool heuristic)
> >>              list_del(workspace);
> >>              (*free_ws)--;
> >>              spin_unlock(ws_lock);
> >> +            if (!heuristic) {
> >> +                    nofs_flag =3D memalloc_nofs_save();
> >> +                    ret =3D btrfs_compress_op[idx]->set_level(workspa=
ce,
> >> +                                                            level);
> >> +                    memalloc_nofs_restore(nofs_flag);
> >> +                    if (!ret) {
> >> +                            free_workspace(type, workspace);
> >> +                            goto again;
> >> +                    }
> >> +            }
> >>              return workspace;
> >> -
> >>      }
> >>      if (atomic_read(total_ws) > cpus) {
> >>              DEFINE_WAIT(wait);
> >> @@ -899,7 +966,8 @@ static struct list_head *__find_workspace(int type=
, bool heuristic)
> >>      if (heuristic)
> >>              workspace =3D alloc_heuristic_ws();
> >>      else
> >> -            workspace =3D btrfs_compress_op[idx]->alloc_workspace();
> >> +            workspace =3D btrfs_compress_op[idx]->alloc_workspace(lev=
el);
> >> +
> >>      memalloc_nofs_restore(nofs_flag);
> >>
> >>      if (IS_ERR(workspace)) {
> >> @@ -930,60 +998,22 @@ static struct list_head *__find_workspace(int ty=
pe, bool heuristic)
> >>      return workspace;
> >> }
> >>
> >> -static struct list_head *find_workspace(int type)
> >> +static struct list_head *find_workspace(unsigned int type_level)
> >> {
> >> -    return __find_workspace(type, false);
> >> +    return __find_workspace(type_level, false);
> >> }
> >>
> >> -/*
> >> - * put a workspace struct back on the list or free it if we have enou=
gh
> >> - * idle ones sitting around
> >> - */
> >> -static void __free_workspace(int type, struct list_head *workspace,
> >> -                         bool heuristic)
> >> +static struct list_head *find_decompression_workspace(unsigned int ty=
pe)
> >> {
> >> -    int idx =3D type - 1;
> >> -    struct list_head *idle_ws;
> >> -    spinlock_t *ws_lock;
> >> -    atomic_t *total_ws;
> >> -    wait_queue_head_t *ws_wait;
> >> -    int *free_ws;
> >> +    /*
> >> +     * Use the lowest level for decompression, since we don't need to
> >> +     * compress. This can help us save memory when using levels lower=
 than
> >> +     * the default level.
> >> +     */
> >> +    const unsigned int level =3D 1;
> >> +    const unsigned int type_level =3D (level << 4) | (type & 0xF);
> >>
> >> -    if (heuristic) {
> >> -            idle_ws  =3D &btrfs_heuristic_ws.idle_ws;
> >> -            ws_lock  =3D &btrfs_heuristic_ws.ws_lock;
> >> -            total_ws =3D &btrfs_heuristic_ws.total_ws;
> >> -            ws_wait  =3D &btrfs_heuristic_ws.ws_wait;
> >> -            free_ws  =3D &btrfs_heuristic_ws.free_ws;
> >> -    } else {
> >> -            idle_ws  =3D &btrfs_comp_ws[idx].idle_ws;
> >> -            ws_lock  =3D &btrfs_comp_ws[idx].ws_lock;
> >> -            total_ws =3D &btrfs_comp_ws[idx].total_ws;
> >> -            ws_wait  =3D &btrfs_comp_ws[idx].ws_wait;
> >> -            free_ws  =3D &btrfs_comp_ws[idx].free_ws;
> >> -    }
> >> -
> >> -    spin_lock(ws_lock);
> >> -    if (*free_ws <=3D num_online_cpus()) {
> >> -            list_add(workspace, idle_ws);
> >> -            (*free_ws)++;
> >> -            spin_unlock(ws_lock);
> >> -            goto wake;
> >> -    }
> >> -    spin_unlock(ws_lock);
> >> -
> >> -    if (heuristic)
> >> -            free_heuristic_ws(workspace);
> >> -    else
> >> -            btrfs_compress_op[idx]->free_workspace(workspace);
> >> -    atomic_dec(total_ws);
> >> -wake:
> >> -    cond_wake_up(ws_wait);
> >> -}
> >> -
> >> -static void free_workspace(int type, struct list_head *ws)
> >> -{
> >> -    return __free_workspace(type, ws, false);
> >> +    return find_workspace(type_level);
> >> }
> >>
> >> /*
> >> @@ -1044,9 +1074,7 @@ int btrfs_compress_pages(unsigned int type_level=
, struct address_space *mapping,
> >>      int ret;
> >>      int type =3D type_level & 0xF;
> >>
> >> -    workspace =3D find_workspace(type);
> >> -
> >> -    btrfs_compress_op[type - 1]->set_level(workspace, type_level);
> >> +    workspace =3D find_workspace(type_level);
> >>      ret =3D btrfs_compress_op[type-1]->compress_pages(workspace, mapp=
ing,
> >>                                                    start, pages,
> >>                                                    out_pages,
> >> @@ -1075,7 +1103,7 @@ static int btrfs_decompress_bio(struct compresse=
d_bio *cb)
> >>      int ret;
> >>      int type =3D cb->compress_type;
> >>
> >> -    workspace =3D find_workspace(type);
> >> +    workspace =3D find_decompression_workspace(type);
> >>      ret =3D btrfs_compress_op[type - 1]->decompress_bio(workspace, cb=
);
> >>      free_workspace(type, workspace);
> >>
> >> @@ -1093,7 +1121,7 @@ int btrfs_decompress(int type, unsigned char *da=
ta_in, struct page *dest_page,
> >>      struct list_head *workspace;
> >>      int ret;
> >>
> >> -    workspace =3D find_workspace(type);
> >> +    workspace =3D find_decompression_workspace(type);
> >>
> >>      ret =3D btrfs_compress_op[type-1]->decompress(workspace, data_in,
> >>                                                dest_page, start_byte,
> >> @@ -1591,12 +1619,23 @@ int btrfs_compress_heuristic(struct inode *ino=
de, u64 start, u64 end)
> >>
> >> unsigned int btrfs_compress_str2level(const char *str)
> >> {
> >> -    if (strncmp(str, "zlib", 4) !=3D 0)
> >> +    int ret;
> >> +    int type;
> >> +    unsigned int level;
> >> +
> >> +    if (strncmp(str, "zlib", 4) =3D=3D 0)
> >> +            type =3D BTRFS_COMPRESS_ZLIB;
> >> +    else if (strncmp(str, "zstd", 4) =3D=3D 0)
> >> +            type =3D BTRFS_COMPRESS_ZSTD;
> >> +    else
> >>              return 0;
> >>
> >> -    /* Accepted form: zlib:1 up to zlib:9 and nothing left after the =
number */
> >> -    if (str[4] =3D=3D ':' && '1' <=3D str[5] && str[5] <=3D '9' && st=
r[6] =3D=3D 0)
> >> -            return str[5] - '0';
> >> +    if (str[4] =3D=3D ':') {
> >> +            ret =3D kstrtouint(str + 5, 10, &level);
> >> +            if (ret =3D=3D 0 && 0 < level &&
> >> +                level <=3D btrfs_compress_op[type-1]->max_level)
> >> +                    return level;
> >> +    }
> >>
> >> -    return BTRFS_ZLIB_DEFAULT_LEVEL;
> >> +    return btrfs_compress_op[type-1]->default_level;
> >> }
> >> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> >> index ddda9b80bf20..a582a4483077 100644
> >> --- a/fs/btrfs/compression.h
> >> +++ b/fs/btrfs/compression.h
> >> @@ -23,8 +23,6 @@
> >> /* Maximum size of data before compression */
> >> #define BTRFS_MAX_UNCOMPRESSED               (SZ_128K)
> >>
> >> -#define     BTRFS_ZLIB_DEFAULT_LEVEL                3
> >> -
> >> struct compressed_bio {
> >>      /* number of bios pending for this compressed extent */
> >>      refcount_t pending_bios;
> >> @@ -87,7 +85,7 @@ blk_status_t btrfs_submit_compressed_write(struct in=
ode *inode, u64 start,
> >> blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct =
bio *bio,
> >>                               int mirror_num, unsigned long bio_flags)=
;
> >>
> >> -unsigned btrfs_compress_str2level(const char *str);
> >> +unsigned int btrfs_compress_str2level(const char *str);
> >>
> >> enum btrfs_compression_type {
> >>      BTRFS_COMPRESS_NONE  =3D 0,
> >> @@ -98,7 +96,7 @@ enum btrfs_compression_type {
> >> };
> >>
> >> struct btrfs_compress_op {
> >> -    struct list_head *(*alloc_workspace)(void);
> >> +    struct list_head *(*alloc_workspace)(unsigned int level);
> >>
> >>      void (*free_workspace)(struct list_head *workspace);
> >>
> >> @@ -119,7 +117,17 @@ struct btrfs_compress_op {
> >>                        unsigned long start_byte,
> >>                        size_t srclen, size_t destlen);
> >>
> >> -    void (*set_level)(struct list_head *ws, unsigned int type);
> >> +    /*
> >> +     * Check if memory allocated in workspace is greater than
> >> +     * or equal to memory needed to compress with given level.
> >> +     * If not, try to reallocate memory for the compression level.
> >> +     * Returns true on success.
> >> +     */
> >> +    bool (*set_level)(struct list_head *ws, unsigned int level);
> >> +
> >> +    unsigned int max_level;
> >> +
> >> +    unsigned int default_level;
> >> };
> >>
> >> extern const struct btrfs_compress_op btrfs_zlib_compress;
> >> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> >> index b6a4cc178bee..ed9f0da8ceda 100644
> >> --- a/fs/btrfs/lzo.c
> >> +++ b/fs/btrfs/lzo.c
> >> @@ -71,7 +71,7 @@ static void lzo_free_workspace(struct list_head *ws)
> >>      kfree(workspace);
> >> }
> >>
> >> -static struct list_head *lzo_alloc_workspace(void)
> >> +static struct list_head *lzo_alloc_workspace(unsigned int level)
> >> {
> >>      struct workspace *workspace;
> >>
> >> @@ -485,8 +485,9 @@ static int lzo_decompress(struct list_head *ws, un=
signed char *data_in,
> >>      return ret;
> >> }
> >>
> >> -static void lzo_set_level(struct list_head *ws, unsigned int type)
> >> +static bool lzo_set_level(struct list_head *ws, unsigned int level)
> >> {
> >> +    return true;
> >> }
> >>
> >> const struct btrfs_compress_op btrfs_lzo_compress =3D {
> >> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> >> index b362b45dd757..77ebd69371f1 100644
> >> --- a/fs/btrfs/super.c
> >> +++ b/fs/btrfs/super.c
> >> @@ -520,7 +520,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info=
, char *options,
> >>                              compress_type =3D "zlib";
> >>
> >>                              info->compress_type =3D BTRFS_COMPRESS_ZL=
IB;
> >> -                            info->compress_level =3D BTRFS_ZLIB_DEFAU=
LT_LEVEL;
> >> +                            info->compress_level =3D
> >> +                                    btrfs_zlib_compress.default_level=
;
> >>                              /*
> >>                               * args[0] contains uninitialized data si=
nce
> >>                               * for these tokens we don't expect any
> >> @@ -542,9 +543,11 @@ int btrfs_parse_options(struct btrfs_fs_info *inf=
o, char *options,
> >>                              btrfs_clear_opt(info->mount_opt, NODATASU=
M);
> >>                              btrfs_set_fs_incompat(info, COMPRESS_LZO)=
;
> >>                              no_compress =3D 0;
> >> -                    } else if (strcmp(args[0].from, "zstd") =3D=3D 0)=
 {
> >> +                    } else if (strncmp(args[0].from, "zstd", 4) =3D=
=3D 0) {
> >>                              compress_type =3D "zstd";
> >>                              info->compress_type =3D BTRFS_COMPRESS_ZS=
TD;
> >> +                            info->compress_level =3D
> >> +                                    btrfs_compress_str2level(args[0].=
from);
> >>                              btrfs_set_opt(info->mount_opt, COMPRESS);
> >>                              btrfs_clear_opt(info->mount_opt, NODATACO=
W);
> >>                              btrfs_clear_opt(info->mount_opt, NODATASU=
M);
> >> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> >> index 970ff3e35bb3..4c30a99b80f6 100644
> >> --- a/fs/btrfs/zlib.c
> >> +++ b/fs/btrfs/zlib.c
> >> @@ -20,6 +20,9 @@
> >> #include <linux/refcount.h>
> >> #include "compression.h"
> >>
> >> +#define BTRFS_ZLIB_DEFAULT_LEVEL 3
> >> +#define BTRFS_ZLIB_MAX_LEVEL 9
> >> +
> >> struct workspace {
> >>      z_stream strm;
> >>      char *buf;
> >> @@ -36,7 +39,19 @@ static void zlib_free_workspace(struct list_head *w=
s)
> >>      kfree(workspace);
> >> }
> >>
> >> -static struct list_head *zlib_alloc_workspace(void)
> >> +static bool zlib_set_level(struct list_head *ws, unsigned int level)
> >> +{
> >> +    struct workspace *workspace =3D list_entry(ws, struct workspace, =
list);
> >> +
> >> +    if (level > BTRFS_ZLIB_MAX_LEVEL)
> >> +            level =3D BTRFS_ZLIB_MAX_LEVEL;
> >> +
> >> +    workspace->level =3D level > 0 ? level : BTRFS_ZLIB_DEFAULT_LEVEL=
;
> >> +
> >> +    return true;
> >> +}
> >> +
> >> +static struct list_head *zlib_alloc_workspace(unsigned int level)
> >> {
> >>      struct workspace *workspace;
> >>      int workspacesize;
> >> @@ -53,6 +68,7 @@ static struct list_head *zlib_alloc_workspace(void)
> >>              goto fail;
> >>
> >>      INIT_LIST_HEAD(&workspace->list);
> >> +    zlib_set_level(&workspace->list, level);
> >>
> >>      return &workspace->list;
> >> fail:
> >> @@ -390,22 +406,13 @@ static int zlib_decompress(struct list_head *ws,=
 unsigned char *data_in,
> >>      return ret;
> >> }
> >>
> >> -static void zlib_set_level(struct list_head *ws, unsigned int type)
> >> -{
> >> -    struct workspace *workspace =3D list_entry(ws, struct workspace, =
list);
> >> -    unsigned level =3D (type & 0xF0) >> 4;
> >> -
> >> -    if (level > 9)
> >> -            level =3D 9;
> >> -
> >> -    workspace->level =3D level > 0 ? level : 3;
> >> -}
> >> -
> >> const struct btrfs_compress_op btrfs_zlib_compress =3D {
> >>      .alloc_workspace        =3D zlib_alloc_workspace,
> >>      .free_workspace         =3D zlib_free_workspace,
> >>      .compress_pages         =3D zlib_compress_pages,
> >>      .decompress_bio         =3D zlib_decompress_bio,
> >>      .decompress             =3D zlib_decompress,
> >> -    .set_level              =3D zlib_set_level,
> >> +    .set_level              =3D zlib_set_level,
> >> +    .max_level              =3D BTRFS_ZLIB_MAX_LEVEL,
> >> +    .default_level          =3D BTRFS_ZLIB_DEFAULT_LEVEL,
> >> };
> >> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> >> index af6ec59972f5..e5d7c2eae65c 100644
> >> --- a/fs/btrfs/zstd.c
> >> +++ b/fs/btrfs/zstd.c
> >> @@ -19,12 +19,13 @@
> >>
> >> #define ZSTD_BTRFS_MAX_WINDOWLOG 17
> >> #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
> >> -#define ZSTD_BTRFS_DEFAULT_LEVEL 3
> >> +#define BTRFS_ZSTD_DEFAULT_LEVEL 3
> >> +#define BTRFS_ZSTD_MAX_LEVEL 15
> >>
> >> -static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len)
> >> +static ZSTD_parameters zstd_get_btrfs_parameters(size_t src_len,
> >> +                                             unsigned int level)
> >> {
> >> -    ZSTD_parameters params =3D ZSTD_getParams(ZSTD_BTRFS_DEFAULT_LEVE=
L,
> >> -                                            src_len, 0);
> >> +    ZSTD_parameters params =3D ZSTD_getParams(level, src_len, 0);
> >>
> >>      if (params.cParams.windowLog > ZSTD_BTRFS_MAX_WINDOWLOG)
> >>              params.cParams.windowLog =3D ZSTD_BTRFS_MAX_WINDOWLOG;
> >> @@ -37,10 +38,25 @@ struct workspace {
> >>      size_t size;
> >>      char *buf;
> >>      struct list_head list;
> >> +    unsigned int level;
> >>      ZSTD_inBuffer in_buf;
> >>      ZSTD_outBuffer out_buf;
> >> };
> >>
> >> +static bool zstd_reallocate_mem(struct workspace *workspace, int size=
)
> >> +{
> >> +    void *new_mem;
> >> +
> >> +    new_mem =3D kvmalloc(size, GFP_KERNEL);
> >> +    if (new_mem) {
> >> +            kvfree(workspace->mem);
> >> +            workspace->mem =3D new_mem;
> >> +            workspace->size =3D size;
> >> +            return true;
> >> +    }
> >> +    return false;
> >> +}
> >> +
> >> static void zstd_free_workspace(struct list_head *ws)
> >> {
> >>      struct workspace *workspace =3D list_entry(ws, struct workspace, =
list);
> >> @@ -50,10 +66,34 @@ static void zstd_free_workspace(struct list_head *=
ws)
> >>      kfree(workspace);
> >> }
> >>
> >> -static struct list_head *zstd_alloc_workspace(void)
> >> +static bool zstd_set_level(struct list_head *ws, unsigned int level)
> >> +{
> >> +    struct workspace *workspace =3D list_entry(ws, struct workspace, =
list);
> >> +    ZSTD_parameters params;
> >> +    int size;
> >> +
> >> +    if (level > BTRFS_ZSTD_MAX_LEVEL)
> >> +            level =3D BTRFS_ZSTD_MAX_LEVEL;
> >> +
> >> +    if (level =3D=3D 0)
> >> +            level =3D BTRFS_ZSTD_DEFAULT_LEVEL;
> >> +
> >> +    params =3D ZSTD_getParams(level, ZSTD_BTRFS_MAX_INPUT, 0);
> >> +    size =3D max_t(size_t,
> >> +                    ZSTD_CStreamWorkspaceBound(params.cParams),
> >> +                    ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT))=
;
> >> +    if (size > workspace->size) {
> >> +            if (!zstd_reallocate_mem(workspace, size))
> >
> > This can allocate memory and this can appen on the writeout path, ie.
> > one of the reasons for that might be that system needs more memory.
> >
> > By the table above, the size can be up to 2.6MiB, which is a lot in
> > terms of kernel memory as there must be either contiguous unmapped
> > memory, the virtual mappings must be created. Both are scarce resource
> > or should be treated as such.
> >
> > Given that there's no logic that would try to minimize the usage for
> > workspaces, this can allocate many workspaces of that size.
> >
> > Currently the workspace allocations have been moved to the early module
> > loading phase so that they don't happen later and we don't have to
> > allocate memory nor handle the failures. Your patch brings that back.
>
> Before this patch, the compression module initialization preloads one
> workspace per algorithm. We added the compression level as a parameter
> to the allocation, and the initialization uses the maximum level, 15. Thi=
s
> guarantees forward progress, since each algorithm will have at least one
> workspace that will work for every compression level.
>
> The only new failure condition is when the compression level changes,
> we have to reallocate the workspaces next time we use them. If we run
> into memory pressure, we might free every workspace but one, reducing
> throughput, but maintaining correctness. This is basically the same scena=
rio
> as before, but now it can occur when writing after changing compression
> levels, not just changing compression algorithm.
>
> I'm not too worried about increased memory usage. We only preallocate
> one of the maximum level (1 MB wasted if not used). Then we only up-size
> the workspaces when needed. I don't expect that high compression levels
> will be a common use case.
>
> The one potential problem with this solution is if the user rarely mounts
> with level 15 (say once a day), but commonly uses level 3. Then their
> workspaces will be sized at 15 forever. However, this is the same
> problem as if the user commonly uses no compression, but occasionally
> uses zstd. The zstd contexts will stick around forever. Ideally we would
> delete workspaces that go unused for a certain amount of time (leaving
> the single preallocated workspace). I think this belongs in a separate pa=
tch.
> I'll plan on looking into it as a follow up.
>
> > The solution I'm currently thinking about can make the levels work but
> > would be limited in throughput as a trade-off for the memory
> > consumption.
> >
> > - preallocate one workspace for level 15 per mounted filesystem, using
> >  get_free_pages_exact or kvmalloc
> >
> > - preallocate workspaces for the default level, the number same as for
> >  lzo/zlib
> >
> > - add logic to select the zstd:15 workspace last for other compressors,
> >  ie. make it almost exclusive for zstd levels > default
> >
> > Further refinement could allocate the workspaces on-demand and free if
> > not used. Allocation failures would still be handled gracefully at the
> > cost of waiting for the remainig worspaces, at least one would be alway=
s
> > available.
>
> Nick

May be i will say some crazy things,
but i think simpler solution, will be fallback to low compression levels
on memory starvation.

i.e. any memory size what used in kernel and can't be handled by kmalloc,
is a huge amount of memory (IMHO).

And if user get situation where we not have enough free memory, to handle
high compression ratio, may be that better to not try handle that
compression level.
And just fallback to level, with available preallocated memory areas.

Thanks!

--=20
Have a nice day,
Timofey.
