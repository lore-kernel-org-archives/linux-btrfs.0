Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4740C43334
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Jun 2022 20:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiFAUp5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiFAUpj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2022 16:45:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAA51D106A;
        Wed,  1 Jun 2022 13:34:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h5so3904263wrb.0;
        Wed, 01 Jun 2022 13:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfsG9LUOEPEKQ9LxxRuVY9iWrZQoJ7F8ml1zzQN1q0o=;
        b=TV/JmovXx25zTSTxidCJIrIjB3J+6yovker1IPrJ45jkhZb0ZPkm/US+DsSNJ9OLQ1
         x9L8kANnTgqmES1a/+y8c49aceJjSpf1T9prbrqFPMJlTUFuXUwDqMs92xFUAt4FrVD+
         9hgDSm9pt07EkY8X3V+0TC+8MhEs0SQWTKG6PRjJAR+FQ+Q1k0ex0nEYGl4Z+flyzzAR
         fG2wOLBo96n4dJdULvBRi3nzPk/HFjNfGIwMSGRrC1vdl/HKdin9jvMq+WCJpZkYD9oI
         7UmQ3hh1HniIvM1moToPZwbhaEH9cZYx8rvVEIC7b5TmCRQ3Zqe12CpmtbL0Fyx0lVqy
         9h5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfsG9LUOEPEKQ9LxxRuVY9iWrZQoJ7F8ml1zzQN1q0o=;
        b=p8fJEno81WfyZ0/2a1JMCWfwtiJO8eCt4tR9NVt++hC4Fr6guFEUsxDihSTey4xoPO
         /rlAkeBg/8pLKn2WcMd3xW8rNfr+TcU9MB3QEQ6ydhl6/P4Yk+zooq26wWh13/pOfDLT
         fmnLIXWAWvzHSUkgG4QbEUGtaXWGt9ePGZz6EY/FRQn4aUD8pVI+cFMh25waRmqsA0fM
         Gh+uB2YfwbXL2S0BXIkedAeI+QiaAb+NrE75+1bYli1BvdUBUHFJJ7phY8dEx9JaCq39
         /ujQNlOC5hL4H/xdcoFh5LBq/fba00u3ygt214ziwUVzETVNT0u8S3/33tMLvRJdpdjQ
         dtuA==
X-Gm-Message-State: AOAM530CvT04qwpDuWEFy+vvgHJPvEZsWiSA232SEemfEBC69VA3fvdy
        lZerfdRjiwjKpjCaqoZ0B2PXD+qROE8=
X-Google-Smtp-Source: ABdhPJx8MtWjiK3wPxQOfSWBDFZSlPWAUYVHkks7Qq/MkfVuM0OyvqCuGvG//AVEkW+7IRAj5J57ig==
X-Received: by 2002:a17:907:9809:b0:6f5:1be8:5b13 with SMTP id ji9-20020a170907980900b006f51be85b13mr1069498ejc.412.1654113452261;
        Wed, 01 Jun 2022 12:57:32 -0700 (PDT)
Received: from opensuse.localnet (host-79-55-12-155.retail.telecomitalia.it. [79.55.12.155])
        by smtp.gmail.com with ESMTPSA id rl7-20020a170907216700b006f3ef214e27sm1042428ejb.141.2022.06.01.12.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 12:57:31 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH 3/3] btrfs: Replace kmap() with kmap_local_page() in zlib.c
Date:   Wed, 01 Jun 2022 21:57:28 +0200
Message-ID: <3146770.aV6nBDHxoP@opensuse>
In-Reply-To: <202206010437.EX5Nj7cu-lkp@intel.com>
References: <20220531145335.13954-4-fmdefrancesco@gmail.com> <202206010437.EX5Nj7cu-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On marted=C3=AC 31 maggio 2022 22:35:30 CEST kernel test robot wrote:
> Hi "Fabio,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20

[snip]

> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> fs/btrfs/zlib.c:125:6: warning: variable 'data_in' is used=20
uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (out_page =3D=3D NULL) {
>                ^~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:270:6: note: uninitialized use occurs here
>            if (data_in) {
>                ^~~~~~~
>    fs/btrfs/zlib.c:125:2: note: remove the 'if' if its condition is=20
always false
>            if (out_page =3D=3D NULL) {
>            ^~~~~~~~~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:115:6: warning: variable 'data_in' is used=20
uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (Z_OK !=3D zlib_deflateInit(&workspace->strm, workspace-
>level)) {
>               =20
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/zlib.h:148:25: note: expanded from macro 'Z_OK'
>    #define Z_OK            0
>                            ^
>    fs/btrfs/zlib.c:270:6: note: uninitialized use occurs here
>            if (data_in) {
>                ^~~~~~~
>    fs/btrfs/zlib.c:115:2: note: remove the 'if' if its condition is=20
always false
>            if (Z_OK !=3D zlib_deflateInit(&workspace->strm, workspace-
>level)) {
>           =20
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:100:15: note: initialize the variable 'data_in' to=20
silence this warning
>            char *data_in;
>                         ^
>                          =3D NULL
> >> fs/btrfs/zlib.c:125:6: warning: variable 'cpage_out' is used=20
uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (out_page =3D=3D NULL) {
>                ^~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:267:6: note: uninitialized use occurs here
>            if (cpage_out)
>                ^~~~~~~~~
>    fs/btrfs/zlib.c:125:2: note: remove the 'if' if its condition is=20
always false
>            if (out_page =3D=3D NULL) {
>            ^~~~~~~~~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:115:6: warning: variable 'cpage_out' is used=20
uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (Z_OK !=3D zlib_deflateInit(&workspace->strm, workspace-
>level)) {
>               =20
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/zlib.h:148:25: note: expanded from macro 'Z_OK'
>    #define Z_OK            0
>                            ^
>    fs/btrfs/zlib.c:267:6: note: uninitialized use occurs here
>            if (cpage_out)
>                ^~~~~~~~~
>    fs/btrfs/zlib.c:115:2: note: remove the 'if' if its condition is=20
always false
>            if (Z_OK !=3D zlib_deflateInit(&workspace->strm, workspace-
>level)) {
>           =20
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    fs/btrfs/zlib.c:101:17: note: initialize the variable 'cpage_out' to=20
silence this warning
>            char *cpage_out;
>                           ^
>                            =3D NULL
>    4 warnings generated.

I'll initialize these variables in v2.

Thanks,

=46abio


