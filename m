From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: bug fixes
Date: Fri, 02 Oct 2009 14:35:20 +0900
Message-ID: <4AC59118.6030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have tested btrfsck in some error case, such as item missing
case or CRC error case or so. In this test session I found some
bugs in btrfsck.c and disk-io.c in btrfs-progs.
  1. The last pair of ptrs and items are not checked at 2 place
     of check_node/leaf.
  2. Csum printed CRC error message is not correct.
  3. In CRC error, btrfsck fails in segmentation fault.

I'll post three tiny patches to fix these bugs.

-- 
taruisi

