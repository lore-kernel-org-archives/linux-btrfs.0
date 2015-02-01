Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54871 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbbBAMNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Feb 2015 07:13:42 -0500
Received: from pitr.home.jan ([85.212.50.104]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MAloF-1YOFKB1DfH-00BwoR for
 <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 13:13:40 +0100
Date: Sun, 1 Feb 2015 13:13:36 +0100
From: Jan Andres <jandres@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: security.capability xattr missing after btrfs send/receive
Message-ID: <20150201121335.GA4599@pitr.home.jan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found that the security.capability xattr gets lost when cloning a
subvolume via btrfs send | btrfs receive. This is easy to reproduce
(currently on 3.19.0-rc6, x86_64, with btrfs-progs 3.18.1):

Have two btrfs file systems, "/fs1" and "/fs2".

# btrfs sub create /fs1/test
# touch /fs1/test/foo
# setcap cap_net_admin+ep /fs1/test/foo
# getcap /fs1/test/foo
/fs1/test/foo = cap_net_admin+ep
# btrfs prop set /fs1/test ro true
# btrfs send /fs1/test | btrfs receive /fs2
# getcap /fs2/test/foo
[reports nothing]


The cause of the problem seems to be that BTRFS_SEND_C_SET_XATTR comes
before BTRFS_SEND_C_CHMOD in the send stream, so that the receiving end
will first correctly restore all the xattrs of the file, and after that,
perform an lchown() which will cause the kernel to reset the
file's capabilities.

I don't know how to fix this correctly (especially in the case of
incremental sends), so I don't have a patch, but figured it might be
useful to share what I found.

Regards,
Jan

-- 
Jan Andres <jandres@gmx.net>
