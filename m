Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49274 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaCWRl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 13:41:57 -0400
Received: by mail-qg0-f43.google.com with SMTP id f51so13805321qge.2
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 10:41:57 -0700 (PDT)
MIME-Version: 1.0
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Sun, 23 Mar 2014 21:36:19 +0400
Message-ID: <CACaajQt4CttMXrRuWsZSkiq4Eg5766XGKnYSHPUE8Dd84WFW3Q@mail.gmail.com>
Subject: for Chris Mason ( iowatcher graphs)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. Sorry for writing to btrfs mailing list, but personal mail
reject my message.
Saying "
<chris.mason@fusionio.com>: host 10.101.1.19[10.101.1.19] said: 554 5.4.6 Hop
    count exceeded - possible mail loop (in reply to end of DATA command)

Final-Recipient: rfc822; chris.mason@fusionio.com
Action: failed
Status: 5.0.0
Diagnostic-Code: X-Spam-&-Virus-Firewall; host 10.101.1.19[10.101.1.19] said:
    554 5.4.6 Hop count exceeded - possible mail loop (in reply to end of DATA
    command)
"
My question is:
I'm try to see what happening when virtual machine write to
disk and run blktrace from dom0 like this  blktrace -w 60 -d
/dev/disk/vbd/21-920 -o - > test.trace

/dev/disk/vbd/21-920 is the software raid contains 2 lv volumes , each
lv volume created in big srp attached disk

Inside vm i try to do some work via fio:
[global]
rw=randread
size=128m
directory=/tmp
ioengine=libaio
iodepth=4
invalidate=1
direct=1

[bgwriter]
rw=randwrite
iodepth=32

[queryA]
iodepth=1
ioengine=mmap
direct=0
thinktime=3

[queryB]
iodepth=1
ioengine=mmap
direct=0
thinktime=5

[bgupdater]
rw=randrw
iodepth=16
thinktime=40
size=128m

After that i try to get graph like iowatcher -t test.trace -o trace.svg
But svg contains unreadable images. What i doing wrong and how can i fix that?
svg looks like http://62.76.182.4/trace.svg

Thank you for good tools !

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
