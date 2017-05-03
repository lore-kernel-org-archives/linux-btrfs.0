Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35909 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdECLlG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 07:41:06 -0400
Received: by mail-oi0-f45.google.com with SMTP id h4so22881518oib.3
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 04:41:05 -0700 (PDT)
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 3 May 2017 17:11:04 +0530
Message-ID: <CANT5p=prE-Vm7mGLhQNDwWiJ3k8bRbj-M-rtwk-k6j+_Ad1pBQ@mail.gmail.com>
Subject: Ded
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This email is actually several questions clubbed as one...

I have a btrfs filesystem mounted at /btrfs_vol/
Every N minutes, I run bedup for deduplication of data in /btrfs_vol
Inside /btrfs_vol, I have several subvolumes (consider this as home
directories of several users)
I have set individual qgroup limits for each of these subvolumes.
Additionally, I'm using btrfs-send/receive to backup each subvolume to
an identical btrfs filesystem on a remote server.

I hope I've explained the setup clearly. Now, here are my questions:
1. I understand that bedup does deduplication on whole-file basis. I
also read that duperemove works at extent level.
How do the two compare in terms of performance?
How stable is duperemove? I read a few posts suggesting bugs related
to extent-same.
duperemove seems ideal for my workload. However, have stayed away from
it, fearing instability.

2. Is it possible to have nested subvolumes (like in my tree
structure), and run btrfs-send and expect the data whole filesystem
(including all subvolumes) to be sent?
My problem is that, since I send btrfs subvolumes, if there is any
dedplicated data between these subvolumes, it needs to send 2 copies
of the same data to the remote host.
You might ask why not have just a single subvolume and backup the whole thing.
But there are many cool features, like quotas and btrfs send/receive
based backup for selected user home directories, which works only at
the subvolume level.

Please help me with your customized solutions to my problem.
Thanks in advance for your help.

-- 
-Shyam
