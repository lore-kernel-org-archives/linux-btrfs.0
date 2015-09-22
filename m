Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lost.in.psyced.org ([188.40.42.221]:52630 "EHLO lo.psyced.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879AbbIVTvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 15:51:07 -0400
Received: from lo.psyced.org (localhost [127.0.0.1])
	by lo.psyced.org (8.14.3/8.14.3/Debian-9.4) with ESMTP id t8MJqJBH027237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 21:52:20 +0200
Received: (from lynx@localhost)
	by lo.psyced.org (8.14.3/8.14.3/Submit) id t8MJqJlp027236
	for linux-btrfs@vger.kernel.org; Tue, 22 Sep 2015 21:52:19 +0200
Date: Tue, 22 Sep 2015 21:52:19 +0200
From: carlo von lynX <lynX@time.to.get.psyced.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive bigger than original snapshot?
Message-ID: <20150922195219.GA23903@lo.psyced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, it's me again. This time I searched the web to make sure
I'm not making another beginner's mistake. I'm still not on the
list, so please keep me in cc: on replies.

I have optimized a btrfs subvolume with a script* that reflinks
all files with identical contents, then I did a read-only snap
and fed it to send/receive. The bad news: on the receiving
side the same snapshot grew from 5.5G to 7.1G.

I assume send/receive does not support one of the coolest
btrfs features ever.. reflinks. Didn't find any mention on this
on https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
or other pages. Is there any documentation that would explain
to me why this has to be or is it just a missing feature that
someone someday may find the time to add?

Generally I find it odd that btrfs receive would not recreate
an identical clone of the original snapshot, that would also
allow me to continue working on a backup hard disk, then merge
the changes back to the main disk. Instead I have to decide
which device contains the master copy for all times and never
make rw snapshots elsewhere. What if the master disk dies?
Then I can turn a backup into the new master but I will have
to re-bootstrap all other backups as they will not accept the
non-identical parent snapshot.

Apparently I'm not the only one that thought this to be a
defect rather than a design choice:
    http://www.spinics.net/lists/linux-btrfs/msg45175.html

This actually confused me (in particular the absence of responses
to that mail), that's why I have btrfs-progs 4.0 installed...
but in the meantime I figured out that I expected send/receive
to be bidirectional. So my question in this case.. is there a
higher reasoning for the inexactness of send/receive transfers?

And another classic: since the output size of the snapshot copy
is unpredictable, running out of disk space can be frequent.
Wouldn't it be cool if receive could resume rather than restarting
from scratch?

But maybe I still got it all wrong in my head. If these things
are FAQs, please add them to the FAQ document. In particular some
criteria to decide when rsync is actually a more suitable tool
over send/receive, which apparently under some circumstances is
the case. In some other cases, git can be the better suited tool.

Still I am very glad that you created a new alternative for data
organization between the extremes of reckless rsync and overly
accurate git. It's just a steep learning mountain.


*) I used fdupes' output ran through a perl script that calls
  "cp --reflink" for each match. Would "bedup" or "duperemove"
 do a better job? bedup looks like a better long-term solution.


-- 
  E-mail is public! Talk to me in private using encryption:
         http://loupsycedyglgamf.onion/LynX/
          irc://loupsycedyglgamf.onion:67/lynX
         https://psyced.org:34443/LynX/
