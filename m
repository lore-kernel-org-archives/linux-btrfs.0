Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:53047 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbcCTQ6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 12:58:14 -0400
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com [209.85.213.53])
	(authenticated bits=0)
	by c.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id u2KGwBs8026785
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 09:58:12 -0700
Received: by mail-vk0-f53.google.com with SMTP id q138so100537786vkb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 09:58:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 20 Mar 2016 09:58:11 -0700
Message-ID: <CAPF83mscZt5SZMbweptCc_s5Fe6w9T=3Via0UZsoCiL-=ApbDg@mail.gmail.com>
Subject: WARNING: quotas may be inconsistent, rescan needed
From: Suman Chakravartula <suman@rockstor.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello my dear upstream heroes,

We are using progs v4.4.1 and kernel 4.4.5 in Rockstor and sometimes
this warning is displayed while assigning a qgroup. Here's a sample
output.

/sbin/btrfs qgroup assign 0/408 2015/6 /mnt2/<btrfs_pool>
WARNING: quotas may be inconsistent, rescan needed

2015/6 is the qgroup of a subvolume(/mnt2/<btrfs_name>/<subvol_name>)
created much earlier.

This started happening since progs v4.2. There are three scenarios I've tested.

1. Just ignore the warning and check if the qgroup assignment
succeeded with a "qgroup show" command. In most cases, the assignment
shows up immediately. But it could take a bit in some cases. Is there
any self/auto consistency check that is triggered by default? If so
can someone explain how that works?

2. Add a --rescan option to to the "qgroup assign" command above to
auto schedule a rescan as per the man page. Is this safe to do? What
are pros and cons?

3. Execute a "quata rescan" separately if the warning is displayed. Is
this any different from (2)?

Thanks for reading!

-- 
Suman Chakravartula
Founder @ Rockstor

http://rockstor.com
http://rockstor.com/blog
http://forum.rockstor.com
