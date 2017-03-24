Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:35148 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756416AbdCXJCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 05:02:23 -0400
Received: by mail-qt0-f180.google.com with SMTP id x35so5717311qtc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Mar 2017 02:02:22 -0700 (PDT)
MIME-Version: 1.0
From: Denis Kirjanov <dkirjanov@cloudlinux.com>
Date: Fri, 24 Mar 2017 12:02:21 +0300
Message-ID: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
Subject: __link_block_group uses GFP_KERNEL
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, chris.mason@fusionio.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

Looks like that current code does GFP_KERNEL allocation inside
__link_block_group.
the function invokes kobject_add and internally creates sysfs files
with the GFP_KERNEL flag set.
But since do_chunk_alloc executes insides the btrfs transaction it's
not allowed to sleep.

Thanks!
