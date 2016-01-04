Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.142]:53762 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbcADIwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 03:52:38 -0500
Received: from [88.246.62.12] (helo=[192.168.1.253])
	by smtp07.mailcore.me with esmtpa (Exim 4.80.1)
	(envelope-from <mark@markandruth.co.uk>)
	id 1aG0cE-0001y7-76
	for linux-btrfs@vger.kernel.org; Mon, 04 Jan 2016 08:35:46 +0000
To: linux-btrfs@vger.kernel.org
From: Mark Zealey <mark@markandruth.co.uk>
Subject: Filesystem hang on kernel 4.2.0 with copy reflink
Message-ID: <568A2EDF.6090909@markandruth.co.uk>
Date: Mon, 4 Jan 2016 10:35:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there, I've run into a very strange hang with btrfs. I was trying to 
restore a directory (postgres database) from a readonly snapshot. To do 
this i used the command `cp -ar --reflink=always`. This worked fine for 
100s of files, however when it got to a particular file 16 kworker 
threads (I have 8 processors in this system) got marked as being in D 
state (with 0 cpu usage or disk usage) and I could not access the btrfs 
file system any more. I can't see any kernel message or OOPS. Can you 
please let me know what additional debug information I can provide to 
help track this issue down in the kernel?

System is latest ubuntu 14.04 LTS with a backported wily kernel (package 
linux-image-4.2.0-22-generic):

4.2.0-22-generic #27~14.04.1-Ubuntu SMP Fri Dec 18 10:57:53 UTC 2015 
x86_64 x86_64 x86_64 GNU/Linux

Thanks

Mark
