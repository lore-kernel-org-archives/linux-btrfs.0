Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D650C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 07:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B35C2070D
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 07:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="IgYl3gtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfDBHmH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 03:42:07 -0400
Received: from mout.gmx.net ([212.227.15.19]:45287 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbfDBHmG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 03:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554190918;
        bh=8hwxpfhjKorqYj9TqNfgVEXtaIDiMGikvfkOyC2TafA=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=IgYl3gtPJ2AELRuyoEZK8+w5r0K+G2XfPHPpbdX7ijB5i30T5e8YeWUhS9601DkBX
         LVidvEwxXebVPbj8uN0A0ef3FqzkiKozhPkmRydBesvknECaAnCEesaRkkAKlPRD8L
         nAAyQ51oez9/jvnaGeCiQdVlNRuxHQdczqCWk/rU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LoVOE-1giClj2ebK-00gaEt; Tue, 02
 Apr 2019 09:41:58 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        iovisor-dev@lists.iovisor.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Is it a good idea to export certain internal structure declaration to
 make bcc/ebpf happier?
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <28e33708-6f0d-ec65-5565-4c41e741a87e@gmx.com>
Date:   Tue, 2 Apr 2019 15:41:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ArZ6m4PjEdtLA3u8tEGKtuvTZmZE3DWyt"
X-Provags-ID: V03:K1:piKi2U1osGpIZGRGPCRsrBlGUPtZ66Nt50+n4hSJrupf2A01ucq
 7m4ywoa/FvGu3+PlM12HhSpD5pX1xnhEYOXBkQkpIwhRSwXjMXreHY+71lCwWYvswVzUaSR
 AN8QmZdEL0nyZ/zI3cFHpsMKni7hUdGPerffB/fnkW7YIM3nR1qjYGPc6kEpfuYH8lrkG6p
 awN+MRII+awWukMDbvHuw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hpT4B3KcmV4=:zKe7m/mpG5yyMMUwvTBSo5
 WEPwcdCWx7bkR4RtGPxz2l5r2f3hzgoW4O0YNUrL94X+PgiVw8+/uCVu1NyHqi4bu8PsnPbLL
 LrGJvDHtVw65GLkUTvP9WccsiGEisAaXvHFZxo7erfmmKisrzW9INKLrA+9cGo3W/Dlxu+QqW
 vX1VWoXz2sKAnJyRdqIKLc5pi8TBbkqKOh/LWXUzu5kXJTrMt+7xwauDxUc7CZ54wG2S1ezyp
 II8Oy4qBSMawECBHXz6QuYERbPDElmKOmHwsQOaW9KMGF2UTnatu5cbm8HZA4XKjDE9Es1ZBW
 sIYvfpvPODy02kV2/rEeqnQ+mPWXbwWjFiMYYcxPaCR1bc+N0RhES0CtyrybjGMzigyeKs+G4
 N2E5QciqG2JnAQT1sX6S/fL2yNwFy+IHIUCCuykh9XHAmEUGOZBC7+8iGDE85EGTH/oOeK6Gf
 MLPml7EXlY8Yq3hwY336F3YjMxPyf06pzCbCMlpdnOdDUonVmhoN+wVStNKFEQlAG046YnMnX
 1FP7F8lzNSPesOWV4guKM5mW/6EWoHhYqcyr0Q7wK77K33WyOfB7Tnh23A9/6Bwx6wukItKpp
 fkndLuCSQ6nyiMJlCRXkkgwK5zy4sRl/NwwPaWZTP8Ep807C8r8AQLqw/csLF2DF5THDy6hIm
 8ETtwujZDruvr8fBBCCK8Xf840wVBZqAAy9drIuQmQTHY/rwNEFmleWsX3dVIyMoaR89YPodb
 mjpHOyxD3asgJ1nThcP7D3PixDCBxKwPpcbvswS28RdGpIol+ykzJgyU39abOKbaqrglmHfO/
 Fy8qYUWh1ICTXssgF1JSZysFlZRREH6RFybFQn3Vcpl97P/fErpyLcbusL312jlBsP+QLkdyc
 eLatNmbadO+e9epnt4t+k4a7JP52JYIPGe5hbWhLPO2HR2rWf7Ji+0MTMfNh6x
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ArZ6m4PjEdtLA3u8tEGKtuvTZmZE3DWyt
Content-Type: multipart/mixed; boundary="UZ4z1kebDaDWd9Q5ryGut7jxUijRdbLnH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 iovisor-dev@lists.iovisor.org
Message-ID: <28e33708-6f0d-ec65-5565-4c41e741a87e@gmx.com>
Subject: Is it a good idea to export certain internal structure declaration to
 make bcc/ebpf happier?

--UZ4z1kebDaDWd9Q5ryGut7jxUijRdbLnH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I'm recently working on crafting a small bcc based script to show how
btrfs tree block concurrency.

The prototype is here:
https://gist.github.com/adam900710/63db6cdc7d26c4744a53dfc7755fafda

However it has some problems, and cannot be used directly on latest kerne=
l.

- No way to pass btrfs headers into eBPF code.
  This is because the declaration of extent_buffer is in
  `fs/btrfs/extent_io.h`.
  No in the common kernel headers search path.

- eBPF program can't access btrfs_header_owner() helper.
  Even we make eBPF code understand the headers, we can't
  access a lot of kernel functions, like btrfs_header_owner().

So I'm wondering is it possible for us to export extent_buffer
declaration just for possible eBPF usage.

Or is bcc suit strong enough to handle such case?

The diff would be something like this to make above bcc script work:

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a3e3e95c632e..ba7628434ac9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/btrfs.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "ctree.h"
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c4ec104ac157..5bc0df2c1c64 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -146,48 +146,6 @@ struct extent_state {
 #endif
 };

-#define INLINE_EXTENT_BUFFER_PAGES 16
-#define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES *
PAGE_SIZE)
-struct extent_buffer {
-       u64 start;
-       unsigned long len;
-       unsigned long bflags;
-       struct btrfs_fs_info *fs_info;
-       spinlock_t refs_lock;
-       atomic_t refs;
-       atomic_t io_pages;
-       int read_mirror;
-       struct rcu_head rcu_head;
-       pid_t lock_owner;
-
-       atomic_t blocking_writers;
-       atomic_t blocking_readers;
-       bool lock_nested;
-       /* >=3D 0 if eb belongs to a log tree, -1 otherwise */
-       short log_index;
-
-       /* protects write locks */
-       rwlock_t lock;
-
-       /* readers use lock_wq while they wait for the write
-        * lock holders to unlock
-        */
-       wait_queue_head_t write_lock_wq;
-
-       /* writers use read_lock_wq while they wait for readers
-        * to unlock
-        */
-       wait_queue_head_t read_lock_wq;
-       struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
-#ifdef CONFIG_BTRFS_DEBUG
-       atomic_t spinning_writers;
-       atomic_t spinning_readers;
-       atomic_t read_locks;
-       atomic_t write_locks;
-       struct list_head leak_list;
-#endif
-};
-
 /*
  * Structure to record how many bytes and which ranges are set/cleared
  */
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 6df03ba36026..5cf075d02b1b 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -174,6 +174,8 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
                BUG_ON(eb->lock_nested);
                eb->lock_nested =3D true;
                read_unlock(&eb->lock);
+               if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
+                       eb->owner =3D btrfs_header_owner(eb);
                return;
        }
        if (atomic_read(&eb->blocking_writers)) {
@@ -184,6 +186,8 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
        }
        btrfs_assert_tree_read_locks_get(eb);
        btrfs_assert_spinning_readers_get(eb);
+       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
+               eb->owner =3D btrfs_header_owner(eb);
 }

 /*
@@ -312,6 +316,8 @@ void btrfs_tree_lock(struct extent_buffer *eb)
        btrfs_assert_spinning_writers_get(eb);
        btrfs_assert_tree_write_locks_get(eb);
        eb->lock_owner =3D current->pid;
+       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
+               eb->owner =3D btrfs_header_owner(eb);
 }

 /*
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c195896d478f..3aeaffdadabb 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -944,4 +944,47 @@ enum btrfs_err_code {
 #define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
                                struct btrfs_ioctl_ino_lookup_user_args)

+#define INLINE_EXTENT_BUFFER_PAGES 16
+#define MAX_INLINE_EXTENT_BUFFER_SIZE (INLINE_EXTENT_BUFFER_PAGES *
PAGE_SIZE)
+struct extent_buffer {
+       u64 start;
+       unsigned long len;
+       unsigned long bflags;
+       struct btrfs_fs_info *fs_info;
+       spinlock_t refs_lock;
+       atomic_t refs;
+       atomic_t io_pages;
+       int read_mirror;
+       struct rcu_head rcu_head;
+       pid_t lock_owner;
+
+       atomic_t blocking_writers;
+       atomic_t blocking_readers;
+       bool lock_nested;
+       /* >=3D 0 if eb belongs to a log tree, -1 otherwise */
+       short log_index;
+
+       /* protects write locks */
+       rwlock_t lock;
+
+       /* readers use lock_wq while they wait for the write
+        * lock holders to unlock
+        */
+       wait_queue_head_t write_lock_wq;
+
+       /* writers use read_lock_wq while they wait for readers
+        * to unlock
+        */
+       wait_queue_head_t read_lock_wq;
+       struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+#ifdef CONFIG_BTRFS_DEBUG
+       atomic_t spinning_writers;
+       atomic_t spinning_readers;
+       atomic_t read_locks;
+       atomic_t write_locks;
+       u64 owner;
+       struct list_head leak_list;
+#endif
+};
+
 #endif /* _UAPI_LINUX_BTRFS_H */

Thanks,
Qu


--UZ4z1kebDaDWd9Q5ryGut7jxUijRdbLnH--

--ArZ6m4PjEdtLA3u8tEGKtuvTZmZE3DWyt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyjEkAACgkQwj2R86El
/qglpwgAppT2JeAd+0384auluE7zLPvD58QEesyBgBXJJGnXHntoLR5Bb0ErWNDf
SqOhXleD7MrehEOXdAbg9dEq/f3tQmIHfuMPe5TiT3WKBJNGIFv6AbhQQiHw0cNk
s9ZJ2VDha5DTVnhBhxtGY/v4BgVS5MuYZZPVeU4A7QEWiy85zgTUk+IoPSPJxRrN
ZVsZ9omkRXFu1w+sksTbuC6a7qWbKzxG7ENi2dqi6zG05Lmo13jB3iWWdsuzsfrj
vpsKFqUqefEN4pFZeQiJ89sudGlHJs9f0VeqKBA7AUZ/x613qFV0dIUltlNfikQe
SiTWueFd6LPhBGAsHEooKGTilO1CZg==
=0DiP
-----END PGP SIGNATURE-----

--ArZ6m4PjEdtLA3u8tEGKtuvTZmZE3DWyt--
