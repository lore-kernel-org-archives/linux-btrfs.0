Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44524 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3FWSwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Jun 2013 14:52:16 -0400
Received: by mail-wg0-f52.google.com with SMTP id b12so7843216wgh.7
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Jun 2013 11:52:14 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 23 Jun 2013 21:52:14 +0300
Message-ID: <CAOcd+r1=aZ-jBcTxgmxU5BiFGCG_10c_vouK6OE=wmG6o8++3g@mail.gmail.com>
Subject: question about transaction-abort-related commits
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>, bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef, Liu,
I am reviewing commits in the mainline tree:

e4a2bcaca9643e7430207810653222fc5187f2be Btrfs: if we aren't
committing just end the transaction if we error out
(call end_transaction() instead of goto cleanup_transaction) - Josef

f094ac32aba3a51c00e970a2ea029339af2ca048 Btrfs: fix NULL pointer after
aborting a transaction
(wait until all writers detach, before setting running_transaction to
NULL) - Liu

66b6135b7cf741f6f44ba938b27583ea3b83bd12 Btrfs: avoid deadlock on
transaction waiting list
(check if transaction was already removed from the transactions list) - Liu

Josef, according to your fix, if the committer encounters a problem
early, it just doesn't commit. Instead it aborts the transaction
(possibly setting FS to read-only) and detaches from the transaction.
So if this was the only committer (e.g., the transaction_kthread),
then transaction commit will not happen at all. Is this what you
intended? So then the user will notice that FS went read-only, and she
will unmount the FS, and transaction will be cleaned up in
btrfs_error_commit_super()=>btrfs_cleanup_transaction(), and not in
cleanup_transaction() via btrfs_commit_transaction(). Is my
understanding correct?

Liu, it looks like after having Josef's fix, the above two commits of
yours are not strictly needed, right? Because Josef's fix ensures that
only the "real" committer will call cleanup_transaction(), so at this
point there is only one writer attached to the transaction, which is
the committer itself (your fixes doesn't hurt though). Is that
correct?

Thanks for helping,
Alex.
