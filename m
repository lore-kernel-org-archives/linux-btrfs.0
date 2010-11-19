From: Xavier Nicollet <nicollet@jeru.org>
Subject: possible bug with space_cache 2.6.37-rc2
Date: Fri, 19 Nov 2010 12:40:10 +0100
Message-ID: <20101119114010.GA28568@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, today I accidentally shut my laptop down (batteries were empty). It is a 
/ btrfs partition, on ubuntu 10.10, kernel 2.6.37-rc2 from kernel.org. 
It is mounted with: rw,relatime,compress,space_cache

Init could not be found on reboot (repeated twice). I rebooted to
2.6.36, which made the partition mounted read-only, and then on
2.6.37-rc2, and everything seems to work pretty well.

Please tell me if you need anything about this.

-- 
Xavier Nicollet
