Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:56074 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754081AbaIPQJ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 12:09:26 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id s8GG0QNR000189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 18:00:28 +0200 (CEST)
Message-ID: <54185D48.5060701@bordeaux.inra.fr>
Date: Tue, 16 Sep 2014 17:54:48 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Problem with a filesystem
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I have a server running debian 7.5 and meet issues for mounting a btrfs
filesystem. This fs had worked for almost one year now but crashed last
sunday. I'm unable to mount the fs and each btrfs-* commands ends with
something like :
Ignoring transid failure
btrfsck: ctree.c:1550: leaf_space_used: Assertion `!(data_len < 0)' failed.
Aborted

Ignoring transid failure
btrfs-zero-log: ctree.c:1550: leaf_space_used: Assertion `!(data_len <
0)' failed.
Aborted


Ignoring transid failure
btrfs: ctree.c:1550: leaf_space_used: Assertion `!(data_len < 0)' failed.
Aborted

So, I can't fsck, restore, repair ou erase logs on it.
I have followed what is told here [1] or there [2] but now, I'm out of
ideas.
Any help is appreciated.
Thanks in advance


[1]http://ram.kossboss.com/btrfs-transid-issue-explained-fix/
[2]https://btrfs.wiki.kernel.org/index.php/Restore
