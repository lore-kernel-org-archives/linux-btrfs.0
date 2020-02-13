Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67B6C352A3
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 06:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB58121734
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 06:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="FxizgpOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBMGIW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 01:08:22 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38093 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgBMGIW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 01:08:22 -0500
Received: by mail-wr1-f53.google.com with SMTP id y17so5152599wrh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2020 22:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=9jAGRWuAPEF7xNh8bH+UUEoffnOd9/rfyHE3f73I5is=;
        b=FxizgpOA+buds6OmspcqUL8dKlprTRhRnbfGXzEnpzBPDc9V+d1EiBE/AMxWb+TqZ9
         +sRvD1TklKBsdOYq5S/nC5UdWJfqRX/rIIkASpUREjFDg/WRQtWQ0y2EeJa9BQTFarLH
         kumJYJGmMmz/pfCG/tTkE1ebo+6NqTvg+GXXZuEp+swdSkzuEqFA10Nl8zoR5LUuCdVs
         qxZboH0ALk26EOZHSO+tC6CbQWr22E64FBRH1e/yvDNtrbIb5jUkoJKp6nJ3KSgT4tdL
         CNKz4lMopGnJmliXXCSHBfDaAaMqfWC+PWleJJJCS+Whop28FBsdX9cINwiu3mLmMY5e
         k7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9jAGRWuAPEF7xNh8bH+UUEoffnOd9/rfyHE3f73I5is=;
        b=Uss02UySau00o1DDSjt3NnN2xXuzNx/MPMSmi/UKKMjzhwehmikt/kwTvO6O0qBb21
         o1IHnEcbsccS5pbPfZeUcn0Xz1zu8rwa2NF8ZUZL/rEUxXTT2Xwv3xcj8gmV+ZOohBik
         0RhG2XbZolj7zyhzzjTvotvzrBu8QtPpO/e+XU2AplTfeJnwnSD5/JSAKu3ppON3sfVK
         ne88PvCvjfKWMJJWBIshMxfKm7Td9maLIWDIJA+mZyBXWM9fyFIBpy4kEORTFbCn0Ssu
         umZLAEseHnPwuNU6lPJQ0YGN5/+43g7jTVgd2XcQ8/yn7wGBj2Byrc954GfA4nMktmaM
         dqfw==
X-Gm-Message-State: APjAAAUBd+Y/GRzKpSOdfEQMw5GDaLzXoJ3nMRgDlhDqIBGye70a8cg8
        mHnLaDBSQi6SexM06e5HwqYOV1QhYzH8uTCUwBvz6TKxsCU=
X-Google-Smtp-Source: APXvYqxE2C7bAAaaLsefL1/FncsSwq8K4+a4SfkCd5rkwCH33NKgdntEldskWqI/nZ4oJbfs1xQwOPArfV/0ldeqTl4=
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr19121988wrp.236.1581574099533;
 Wed, 12 Feb 2020 22:08:19 -0800 (PST)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 12 Feb 2020 23:08:03 -0700
Message-ID: <CAJCQCtS9Te9gRAGwin_Wjqv_3cJXVXthNa1g53zF4PbZW+k0Qg@mail.gmail.com>
Subject: 5.6-rc1, fstrim reports different value 1 minute later
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Host: kernel 5.5.3, qemu-kvm, Btrfs, backing file is raw with +C  5.6.
Guest: kernel 5.6.0-rc1, / is Btrfs

Boot and login, and immediately run these commands:

[root@localhost ~]# df -h
/dev/vda4        96G  4.4G   91G   5% /
# fstrim -v /
/: 91 GiB (97633062912 bytes) trimmed

1 minute later

[root@localhost ~]# fstrim -v /
/: 3.5 GiB (3747549184 bytes) trimmed
[root@localhost ~]#

There's no activity happening in this one minute period. Reboot, and
it's reproducible again. 91G trimmed the first time then 3.5G the
second. Seems like new and unusual behavior. No kernel messages at all
in either host or guest.

-- 
Chris Murphy
