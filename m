Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f66.google.com ([209.85.160.66]:59705 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3JZETR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 00:19:17 -0400
Received: by mail-pb0-f66.google.com with SMTP id mc8so1472746pbc.9
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 21:19:16 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Oct 2013 12:19:16 +0800
Message-ID: <CAC+R54CyxJXTZ=8va-30_0XDA9iNRr67mz=pT3MxysaCR+DFyw@mail.gmail.com>
Subject: btrfs raid0 unable to mount
From: lilofile <lilofile82@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when I use two disk to create raid0 in btrfs, after rebooting
system,one disk unable to mount ,
error is as follows:
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

in /var/log/kern.log

 kernel: [  480.962487] btrfs: failed to read the system array on md0
 kernel: [  480.988400] btrfs: open_ctree failed
