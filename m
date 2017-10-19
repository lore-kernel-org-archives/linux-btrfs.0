Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45887 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751005AbdJSIyC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 04:54:02 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6883520B36
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 04:54:01 -0400 (EDT)
Received: from [192.168.0.111] (unknown [183.89.33.77])
        by mail.messagingengine.com (Postfix) with ESMTPA id A986F247D9
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 04:54:00 -0400 (EDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Tom Hale <tom@hale.ee>
Subject: check: "warning line 4144"
Message-ID: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
Date: Thu, 19 Oct 2017 15:53:57 +0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In running btrfs check, I got the following message:

    warning line 4144

Could this be a little more descriptive?

* Does it mean I should rebuild my FS from scratch?
* Is there anything I can do to remove this warning?

Complete output below:

==========================================================
$ sudo btrfs check --repair -p /dev/mapper/fix-backup
enabling repair mode
Checking filesystem on /dev/mapper/fix-backup
UUID: 0f5b7713-929d-41e7-b214-32500b5c77fc
ref mismatch on [195215851520 16384] extent item 0, found 1
Backref 195215851520 parent 1463 root 1463 not found in extent tree
backpointer mismatch on [195215851520 16384]
owner ref check failed [195215851520 16384]
repair deleting extent record: key 195215851520 169 1
adding new tree backref on start 195215851520 len 16384 parent 0 root 1463
Repaired extent references for 195215851520

Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
warning line 4144 [o]

checking csums
checking root refs
found 294913892352 bytes used, no error found
total csum bytes: 282955440
total tree bytes: 5166727168
total fs tree bytes: 4489232384
total extent tree bytes: 353075200
btree space waste bytes: 886405127
file data blocks allocated: 7930446508032
 referenced 1126675288064
==========================================================

-- 
Tom Hale
