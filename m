From: Josef Bacik <jbacik@redhat.com>
Subject: Hang running fs_mark
Date: Thu, 25 Sep 2008 13:56:44 -0400
Message-ID: <20080925175643.GA14205@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Reporting this on behalf of ric.  He was running the following fs_mark command

./fs_mark -d /mnt/test -s 20480 -D 64 -t 8 -F

Seems it hung and wasn't making any progress.  He managed to get some sysrq-t,
which is at http://people.redhat.com/jwhiter/fs-mark-hang.txt towards the bottom
of the document.  He could ctrl+c and unmount the fs so its not a hard hang.
Looks like we've just locked up behind a page lock somewhere.  I have to run off
to class so I can't look into it too deeply so throwing this out there hoping
somebody else figures it out :).  Thanks,

Josef
