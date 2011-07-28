From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: [PATCH v8 0/8] Btrfs scrub: print path to corrupted files and trigger nodatasum fixup
Date: Thu, 28 Jul 2011 14:44:40 +0000 (UTC)
Message-ID: <loom.20110728T163725-25@post.gmane.org>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <loom.20110727T183833-109@post.gmane.org> <loom.20110728T003246-429@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schubert <Jan.Schubert <at> GMX.li> writes:
> OK, Patch 1 to 3 did apply and run successfully on 3.0-git8. I've sent 
> Jan some more details about the output of the affected files (which is
> actually just one quite large one).

Hooray:

scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
   scrub started at Thu Jul 28 15:00:54 2011 and finished after 656 seconds
   total bytes scrubbed: 143.40GB with 0 errors

Clean filesystem after deleting the (last) affected file, thx a lot!

Next issue: I have an other filesystem which is also reportet as error free
by scrub:

scrub status for 62bab779-3a5e-4ad0-8f67-9d727813e7ea
   scrub started at Thu Jul 28 16:16:26 2011 and finished after 131 seconds
   total bytes scrubbed: 28.91GB with 0 errors

Doing a btrfsck on the same filesystem I get:

root 5 inode 5067 errors 400
root 5 inode 5098 errors 400
root 5 inode 5123 errors 400
root 5 inode 5125 errors 400
root 5 inode 6082 errors 400
found 30889312256 bytes used err is 1
total csum bytes: 30113200
total tree bytes: 51560448
total fs tree bytes: 8212480
btree space waste bytes: 11638215
file data blocks allocated: 30991843328
 referenced 31323025408
Btrfs v0.19-100-g4964d65

Is this something I should be concerned about (regarding the errors)?

Thx,
Jan

