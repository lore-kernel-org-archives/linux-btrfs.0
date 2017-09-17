Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpoutz26.laposte.net ([194.117.213.101]:32863 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751332AbdIQPKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 11:10:25 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id 3E27A121DBC
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:47:37 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout014 (Postfix) with ESMTP id 31BC3121F3B
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:47:37 +0200 (CEST)
Received: from lpn-prd-vrin004 (lpn-prd-vrin004.laposte [10.128.63.5])
        by lpn-prd-vrout014 (Postfix) with ESMTP id 24794121DBC
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:47:37 +0200 (CEST)
Received: from lpn-prd-vrin004 (localhost [127.0.0.1])
        by lpn-prd-vrin004 (Postfix) with ESMTP id 16E17713FB3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:47:37 +0200 (CEST)
Received: from antoine-laptop.lan (bon31-1-82-66-78-7.fbx.proxad.net [82.66.78.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by lpn-prd-vrin004 (Postfix) with ESMTPSA id C39DD71402E
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:47:36 +0200 (CEST)
From: Antoine Belvire <antoine.belvire@laposte.net>
Subject: cp --reflink and qgroup limit
To: linux-btrfs@vger.kernel.org
Message-ID: <d424bbbb-3c11-e874-9b12-4bae12e3d07e@laposte.net>
Date: Sun, 17 Sep 2017 16:45:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The behavior of 'cp --reflink' puzzles me from the quota point of view.

It looks like it's possible to easily exceeds a qgroup's max_rfer limit 
like this:

~# # Create '/test' and '/test/a' subvolumes
~# btrfs subvolume create /test
~# btrfs subvolume create /test/a
~#
~# # Set limits
~# btrfs qgroup limit 10m (qgroupid) /
~# btrfs qgroup limit -e 5m (qgroupid) /
~#
~# # Limits are set
~# btrfs qgroup show -erF /test/a/
qgroupid         rfer         excl     max_rfer     max_excl
--------         ----         ----     --------     --------
(the id)     16.00KiB     16.00KiB     10.00MiB      5.00MiB
~#
~# # Write a big file in '/test'
~# dd if=/dev/urandom of=/test/bigfile bs=1M count=50
~#
~# # Copy it to '/test/a' using cp --reflink
~# cp --reflink /test/bigfile /test/a
~#
~# # No EDQUOT error, quota limit is exceeded
~# btrfs qgroup show --sync -erF /test/a/
qgroupid         rfer         excl     max_rfer     max_excl
--------         ----         ----     --------     --------
(the id)     50.02MiB     16.00KiB     10.00MiB      5.00MiB
~#

However, now the limit is exceeded, EDQUOT is raised upon a new 'cp 
--reflink':

~# touch /test/nothing
~# cp --reflink /test/nothing /test/a
cp: cannot create regular file 'a/nothing': Disk quota exceeded
~#

As far as I understand the code, btrfs_clone doesn't try to reserve data 
it clones. It only reserves metadata through btrfs_start_transaction.

Is it an expected behavior?

Regards,

--
Antoine
