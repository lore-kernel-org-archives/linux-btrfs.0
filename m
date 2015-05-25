Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:59214 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbEYOlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 10:41:07 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: [PATCH] Btrfs: Log the error conditions to determine which caused the error in btrfs_init_inode_security
From: Anthony Plack <anthony@plack.net>
In-Reply-To: <20150525125740.GG23255@twin.jikos.cz>
Date: Mon, 25 May 2015 09:41:04 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8C081E15-B762-43C0-A65B-6D7D15983DC9@plack.net>
References: <B6FEFB35-F6C4-41B7-9750-EC400392C0B8@plack.net> <20150525125740.GG23255@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On May 25, 2015, at 7:57 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> On Sun, May 24, 2015 at 09:42:19PM -0500, Anthony Plack wrote:
>> Would I step on anyone’s toes if I started submitting some extra
>> patches to increase the verbosity of the BTRFS code in the kernel log?
>> 
>> I would probably start with most things as pr_debug just to keep it
>> quiet on non-debug kernels, but I just thought that it might add a
>> great deal of clarity to the code base and maybe help sysadmins figure
>> out what is a BTRFS issue and what is some other issue.
> 
> Starting with pr_debug should be safe. There may be different oppinions
> where to put the messages as this can easily fall into "too trivial"
> category. This probably needs some "taste" and past experience with
> debugging problems to find the good candidate spots in the code. Please
> send a sample and let's see.

Good point and to clarify…

I am only looking at existing decision points in the code, where there is an error check already.  The goal is not to have debug data for the sake of debug data.  More simply, when an error appears and pr_debug is enabled, we at least log the error and the data involved.  This should provide us a nice chain of error issues in the kernel log before any WARN or BUG events.

I am climbing the mountain of struct right now, trying to get short, but meaningful data elements in the message.  These two can be a matter of taste and I am sure the learning will continue on my end.

This is an early change, and I will really appreciate comments on these to get these right.
</comment>


Log the error conditions to determine which caused the error in btrfs_init_inode_security


Signed-off-by: Anthony Plack <anthony@plack.net>
—
fs/btrfs/inode.c | 4 ++++
1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c0bb45..c1a8884 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -117,6 +117,10 @@ static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
        err = btrfs_init_acl(trans, inode, dir);
        if (!err)
                err = btrfs_xattr_security_init(trans, inode, dir, qstr);
+               if (err)
+                       pr_debug("BTRFS: Unable to init xattr security. error=%d,transid=%d,inode=%d,dir=%d,qstr=%s", err, trans->transid, inode->i_uid, dir->i_uid, qstr->name);
+       else
+               pr_debug("BTRFS: Unable to init acl. error=%d,transid=%d,inode=%d,dir=%d,qstr=%s", err, trans->transid, inode->i_uid, dir->i_uid, qstr->name);
        return err;
 }

--
2.3.2


