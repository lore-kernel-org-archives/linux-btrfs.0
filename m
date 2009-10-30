From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Hard link across subvolumes
Date: Fri, 30 Oct 2009 14:30:47 +0900
Message-ID: <4AEA7A07.4020006@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In Btrfs, a hard link across subvolumes should be prohibited,
but not prohibited yet. (It may be convenient if possible,
I think.) If we make a hard link like this, filesystem may
abort or after umount/mount, contents of file may be swapped to
contents of other file(with same i-node number in same tree as
'from' file).

About this, I found Christian Parpart's patch posted last year,
and this patch seems to work well.
  http://www.spinics.net/lists/linux-btrfs/msg00749.html

But this patch is not merged yet.
Some work(to check more, to change error code or to simply test)
shuould be done for this?

-- 
taruisi

