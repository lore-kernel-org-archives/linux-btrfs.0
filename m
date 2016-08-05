Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35007 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbcHELmQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 07:42:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id D716925FA7
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Aug 2016 13:42:12 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0C1r5y4NG-Qy for <linux-btrfs@vger.kernel.org>;
	Fri,  5 Aug 2016 13:42:12 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Aug 2016 13:42:12 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 05 Aug 2016 20:42:12 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Input/output error, nothing appended in dmesg
Message-ID: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting occasional (every few weeks) input/output errors on a btrfs 
filesystem with compress-force=zlib, running on Amazon EC2, with 4.5.2 
kernel:

# cat 2016-08-02/serverX/syslog.log
cat: 2016-08-02/serverX/syslog.log: Input/output error


Strangely, nothing gets appended in dmesg:

# dmesg -c
#


The filesystem stores mostly remote syslog files (so, all text files, 
appended to).

Expected?



# btrfs fi show /var/log/remote/
Label: none  uuid: 5cec93a8-7894-41f6-94a4-9d9b58216dd4
         Total devices 1 FS bytes used 146.55GiB
         devid    1 size 200.00GiB used 153.01GiB path /dev/xvdb


# btrfs fi df /var/log/remote/
Data, single: total=149.00GiB, used=144.50GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=4.01GiB, used=2.05GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



Tomasz Chmielewski
https://lxadm.com

