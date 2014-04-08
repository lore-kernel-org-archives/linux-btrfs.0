Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:33331 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaDHLqi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 07:46:38 -0400
Received: by mail-vc0-f172.google.com with SMTP id la4so653397vcb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 04:46:37 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 13:46:37 +0200
Message-ID: <CAFvQSYSSt_FneFeFUXYK65toiS6MSVGy_pmXd3RUuy=vam-Xsg@mail.gmail.com>
Subject: Is there any way to determine fragmentation for compressed btrfs volumes?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running btrfs on my SSD powered laptop for about a year and
a half  (with force-compress=lzo and autodefrag) and it seems the
volume has degraded quite a lot although I am not using snapshot
functionality.
No matter what I do (scrub, defrag ob the whole volume), files seem to
stay highly fragmented - at least that is my guess.
When e.g. starting up X11+XFCE the hdd led is lid for about 10s (the
Samsung 830 can do up to 80k/iops random read), also starting
google-chrome results in an active SSD for ~5s (although the chrome
binary + libs is for sure < 200mb, so should be loaded in 500ms).

What I wonder is how can I diagnose whats happening and why the FS is
rather slow?
The only target value I know is the extend count,  which doesn't seem
to be meaningful when using fragmentation.

Thank you in advance, Clemens Eisserer
