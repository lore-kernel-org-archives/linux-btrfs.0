Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:34394 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdKUEJH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:09:07 -0500
Received: by mail-ot0-f170.google.com with SMTP id o23so9481614otd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:09:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com> <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 21:09:05 -0700
Message-ID: <CAJCQCtQ8M_Opfq9T4+v0M4kvc1fXKbv26hgJYUR3jUShhX-qrw@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do I need btrfs debug stuff enabled for this patch to work?

$ grep -i btrfs /home/chris/linux/.config
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
$
