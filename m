Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35725 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932938AbdC2V1c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 17:27:32 -0400
Received: by mail-vk0-f47.google.com with SMTP id r69so33565681vke.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 14:27:31 -0700 (PDT)
MIME-Version: 1.0
From: Tim Cuthbertson <ratcheer@gmail.com>
Date: Wed, 29 Mar 2017 16:27:30 -0500
Message-ID: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
Subject: Confusion about snapshots containers
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have recently switched from multiple partitions with multiple
btrfs's to a flat layout. I will try to keep my question concise.

I am confused as to whether a snapshots container should be a normal
directory or a mountable subvolume. I do not understand how it can be
a normal directory while being at the same level as, for example, a
rootfs subvolume. This is with the understanding that the rootfs is
NOT at the btrfs top level.

Which should it be, a normal directory or a mountable subvolume
directly under btrfs top level? If either way can work, what are the
pros and cons of each?

Thank you

Tim Cuthbertson
