From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Mon, 05 Jan 2009 15:44:10 +0100
Message-ID: <49621CBA.2080802@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> This has been bothering me for some time. Why does btrfs need to have a 
> disk greater then 256M? I could see a much smaller limit, say 16M but 
> why so much? The file system itself does not need that much space for 
> its own use.

In other words, 256M limit rather disqualifies btrfs as a filesystem 
i.e. for /boot, doesn't it?


-- 
Tomasz Chmielewski
http://wpkg.org

