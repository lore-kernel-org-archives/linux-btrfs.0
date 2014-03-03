Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63981 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaCCPug (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 10:50:36 -0500
Received: by mail-ve0-f178.google.com with SMTP id jw12so1028716veb.23
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 07:50:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 3 Mar 2014 16:50:35 +0100
Message-ID: <CAFvQSYQ0YvG=kJER-C7fkqyfrM0gVOQortC-=VRe680KyXqkEA@mail.gmail.com>
Subject: Filesystem extremly fragmented after scrub
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using btrfs on a single device with crompress-force=lzo and after
I scrubbed the device once (kernel-3.12), the filesystem is extremly
fragmented - running defrag on all file didn't improve the situation
unfourtunately.
Because I have a fast SSD this is barely noticeable when booting the
system natively, however when working through VirtualBox (using direct
disk access) where each access has far higher latency, the system
responds really slow for file-system intensive tasks (VirtualBox
"hdd-led" is constantly lid in this case).
When booting fsck reports the filesystem is 26% non-continous.

Is there anything I can try to get the FS into a healthier state?

Thank you in advance, Clemens
