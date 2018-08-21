Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58102 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726818AbeHUWrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 18:47:19 -0400
To: linux-api@vger.kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>
From: Nikolay Borisov <nborisov@suse.com>
Subject: exporting uuid_t from uapi/linux/uuid.h
Message-ID: <ffc387b8-09f5-537a-c5a9-08ec28e088e0@suse.com>
Date: Tue, 21 Aug 2018 22:25:50 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm doing some refactoring on btrfs and would like to convert some of
the "naked" definition of UUID in on-disk object to uuid_t. Since those
structs are defined in include/uapi/linux/btrfs_tree.h I naturally would
need to expose the kernel uuid_t to the uapi header via
include/uapi/linux/uuid.h. The uuid was originally unexported in
60927bc31436 ("uuid: remove uuid_be defintions from the uapi header")
 but at that time it was called uuid_be. The thing is that btrfs-progs
for example uses both btrfs_tree.h uapi header as well as libuuid. THe
latter also defines uuid_t. Both the kernel one and libuuid are binary
compatible.

So what's the correct way (if any) to expose a kernel type that might
have also been defined by a userspace library?

Regards,
Nikolay
