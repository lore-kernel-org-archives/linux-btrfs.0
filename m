Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:52995 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966493AbbDWRa6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:30:58 -0400
Received: from oxbaltgw03.schlund.de ([172.19.246.9]) by
 mrelayeu.kundenserver.de (mreue001) with ESMTPSA (Nemesis) id
 0MHfTA-1YkDyG3Pyu-003PKJ for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015
 19:30:56 +0200
Date: Thu, 23 Apr 2015 19:30:56 +0200 (CEST)
From: - - <fdp@fkoop.de>
Reply-To: - - <fdp@fkoop.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <935962336.145772.1429810256346.JavaMail.open-xchange@oxbaltgw03.schlund.de>
Subject: Help needed when btrfs raid5 crashed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a 3 disk raid5 system with btrfs installed. Unfortunately one of the disks
crashed. Now I cannot mount the system any more, not even with the degraded
option. I suspect the failed disk to have a hw failure. I Think part of the
problem might be that I configured the system to not only have the data and
metadata, but also the system data in raid config. Is there any chance that I
might get my data back from the file system?

Currently the system does not boot any more. It was a debian testing system with
btrfs version 3.17. The kernel was originally 3.16.0-4-amd64, but now I also
have 3.19.0-trunk-amd64 installed.

When I run btrfs fi show, I get an error message:
Check tree block failed, want=<big number>, have=<another big number>
read block failed check_tree_block
Couldn' t read chunk root
warning, device 2 is missing

Sorry, I cannot copy/paste as the machine does not boot anymore.

Can anyone give me some help or can explain to me what other kind of info you
need? Thanks.

---
Kind regards

Felix
