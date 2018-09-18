Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:45567 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeIRJPB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 05:15:01 -0400
Received: by mail-lj1-f180.google.com with SMTP id u83-v6so393320lje.12
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 20:44:24 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Sep 2018 21:44:22 -0600
Message-ID: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
Subject: GRUB writing to grubenv outside of kernel fs code
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php/FAQ#Does_grub_support_btrfs.3F

Does anyone know if this is still a problem on Btrfs if grubenv has
xattr +C set? In which case it should be possible to overwrite and
there's no csums that are invalidated.

I kinda wonder if in 2018 it's specious for, effectively out of tree
code, to be making modifications to the file system, outside of the
file system.


-- 
Chris Murphy
