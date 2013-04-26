Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab3DZQIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 12:08:47 -0400
Message-ID: <517AA68B.9060600@redhat.com>
Date: Fri, 26 Apr 2013 11:08:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Question on btrfs filesystem defragment args
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo created test 284 for xfstests to exercise btrfs defragmentation.

One test sends an argument including "-s -1" meaning "start at negative one"

That's failing today, because parse_size now rejects negative numbers.
(that might be something to fix on its own, since length = (u64)-1
might imply the whole file, per kernel comments).

But has "start at -1" ever had an expected meaning?  That doesn't make
sense to me, but the test does it:

+echo "a single file | start < 0 && 0 < len < file size | off"
+_rundefrag 1 2 1

...

+_btrfs_online_defrag()
+{
+       str=""
+       if [ "$2" = "2" ];then
+               str="$str -s -1 -l $((filesize / 2)) "

and expects a silent result:

...
+a single file | default |  on
+a single file | start < 0 && 0 < len < file size | off
+a single file | start > file size && 0 < len < file size | off
...

What was this test intended to do when it was written?

Thanks,
-Eric
