Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34729 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbL3VpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 16:45:17 -0500
Received: by mail-pf0-f174.google.com with SMTP id e65so94266241pfe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 13:45:17 -0800 (PST)
MIME-Version: 1.0
From: "cheater00 ." <cheater00@gmail.com>
Date: Wed, 30 Dec 2015 22:44:57 +0100
Message-ID: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
Subject: 6TB partition, Data only 2TB - aka When you haven't hit the "usual" problem
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have a 6TB partition here, it filled up while still just under 2TB
were on it. btrfs fi df showed that Data is 1.92TB:

Data, single: total=1.92TiB, used=1.92TiB
System, DUP: total=8.00MiB, used=224.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=5.00GiB, used=3.32GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs fs resize max . did nothing, I also tried resize -1T and resize
+1T and that did nothing as well. On IRC I was directed to this:

https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29

"When you haven't hit the "usual" problem

If the conditions above aren't true (i.e. there's plenty of
unallocated space, or there's lots of unused metadata allocation),
then you may have hit a known but unresolved bug. If this is the case,
please report it to either the mailing list, or IRC. In some cases, it
has been possible to deal with the problem, but the approach is new,
and we would like more direct contact with people experiencing this
particular bug."

What do I do now? It's kind of important to me to get that free space.
I'm really jonesing for that free space.

Thanks.

(btw, so far I haven't been able to follow up on that unrelated thread
from a while back. But I hope to be able to do that sometime in
January.)
