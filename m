Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51109 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3LaCbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 21:31:55 -0500
Received: by mail-ie0-f180.google.com with SMTP id tp5so12696452ieb.11
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 18:31:55 -0800 (PST)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Tue, 31 Dec 2013 03:24:24 +0100
Message-ID: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
Subject: question regarding caching
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have some questions regarding caching in BTRFS. When a file system
is unmounted and mounted again, would all the previously cached
content be removed from the cache after flushing to disk? After
remounting, would the initial requests always be fetched from the
disk?

Rather than a local disk, I have a remote device to which my IO
requests are sent and from which the data is fetched. I need certain
data to be fetched from the remote device after a remount. But somehow
I do not see any request appearing at the device. I even tried to do
drop_caches after remounting the file system, but that does not seem
to help.

I guess my problem is not related to BTRFS, but since I am working
with BTRFS, I wanted to ask here for help. Could any one tell me how I
can ensure that requests are fetched from the (remote) device,
especially after file system remount, without having to use
drop_caches?

Please let me know if I described the problem too vaguely and should
give some more details.

Wishing everyone a happy new year.

Thanks and regards,
Aastha.

-- 
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org
