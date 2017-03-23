Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:50410 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbdCWJRb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 05:17:31 -0400
Date: Wed, 22 Mar 2017 22:37:23 -0700
From: Sean Greenslade <sean@seangreenslade.com>
To: linux-btrfs@vger.kernel.org
Subject: Cross-subvolume rename behavior
Message-ID: <20170323053723.GA32087@coach>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, all. I'm currently tracking down the source of some strange
behavior in my setup. I recognize that this isn't strictly a btrfs
issue, but I figured I'd start at the bottom of the stack and work my
way up.

I have a server with a btrfs filesystem on it that I remotely access on
several systems via an sshfs mount. For the most part this works
perfectly, but I just discovered that moving files between subvolumes on
that mount fails with a confusing "Operation not permitted" error.

After doing some digging, it turns out it's not actually a permissions
error. If I do the same operation locally on the server, it succeeds,
but an strace of the mv reveals that the rename() syscall returns EXDEV.
The mv util takes this as a sign to fall back on the copy-and-delete
routine, so the move succeeds. Unfortunately, it seems that somewhere in
sshfs, sftp, or fuse, the EXDEV is getting turned into a generic
failure, which mv apparently interprets as "permission denied".

So my question for the btrfs devs: is rename()-ing across subvolumes
not feasible, or is this simply a case of no one has implemented that
yet? 

Thanks for any insights,

--Sean

