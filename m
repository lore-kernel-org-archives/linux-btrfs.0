Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964984AbeEIP4r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 11:56:47 -0400
To: fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] hoist btrfs' label set/get ioctls to vfs, and document
Message-ID: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
Date: Wed, 9 May 2018 10:56:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm planning to add online label set/get support to xfs, and to do so
I plan to re-use the existing btrfs ioctls, BTRFS_IOC_[SG]ET_FSLABEL

We're still working out minor details on the xfs side, but I'd like to
start the conversation regarding the new more generic interface ASAP,
so here goes - patches to move the ioctls to the vfs and document them.

(Other filesystems may wish to use this interface in the future as well)

Thanks,
-Eric
