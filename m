Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:38411 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaFKVY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 17:24:59 -0400
Message-ID: <5398CA16.3030609@libero.it>
Date: Wed, 11 Jun 2014 23:28:54 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Slow startup of systemd-journal on BTRFS
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I would like to share a my experience about a slowness of systemd when used on BTRFS.

My boot time was very high (about ~50 seconds); most of time it was due to NetworkManager which took about 30-40 seconds to start (this data came from "systemd-analyze plot").

I make several attempts to address this issue. Also I noticed that sometime this problem disappeared; but I was never able to understand why.

However this link

	https://bugzilla.redhat.com/show_bug.cgi?id=1006386

suggested me that the problem could be due to a bad interaction between systemd and btrfs. NetworkManager was innocent. 
It seems that systemd-journal create a very hight fragmented files when it stores its log. And BTRFS it is know to behave slowly when a file is highly fragmented.
This had caused a slow startup of systemd-journal, which in turn had blocked the services which depend by the loggin system.

In fact after I de-fragmented the files under /var/log/journal [*], my boot time decreased of about 20second (from 50s to 30s).

Unfortunately I don't have any data to show. The next time I will try to collect more information. But I am quite sure that when the log are highly fragmented systemd-journal becomes very slow on BTRFS.

I don't know if the problem is more on the systemd side or btrfs side. What I know is that both the projects likely will be important in the near futures, and both must work well together.

I know that I can "chattr +C" to avoid COW for some files; but I don't want to lost also the checksum protection. 

If someone is able to suggest me how FRAGMENT the log file, I can try to collect more scientific data.


BR
G.Baroncelli

[*] 
# btrfs fi defrag /var/log/journal/*/*



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
