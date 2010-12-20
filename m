From: Xavier Nicollet <nicollet@jeru.org>
Subject: mini bug report
Date: Mon, 20 Dec 2010 16:58:01 +0100
Message-ID: <20101220155801.GF24127@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use btrfs on my laptop, 2.6.37-rc2 from kernel.org, under dm-crypt, as
/. I use space_cache and compression (not forced).

Today, my computer froze. At reboot, the kernel could not mount.
The dmesg output, which I haven't saved was speaking of a null
dereference.

After that I rebooted on 2.6.34, which was not very happy: mount errors
(space cache ?).

Now I am on 2.6.37-rc2 again, which seems to work.
So I guess it might come from space_cache.

I would note on a paper if this comes back. However if anybody has any
clue on what specific part of the dmesg should be reported, it would be
very helpfull !

Cheers,

-- 
Xavier Nicollet
