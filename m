From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: disabling compression, or specifying invalid mount options
Date: Tue, 06 Oct 2009 21:20:51 +0200
Message-ID: <4ACB9893.6010901@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to disable compression?

# mount -o remount,nocompress /mnt/btrfs
# 

Not sure if it worked, so let's do:

# mount -o remount,blah,foo,bar /mnt/btrfs/
# 

Hmm. Is it expected (long term)?


# mount
(...)
/dev/sdb4 on /mnt/btrfs type btrfs (rw,noatime,compress,nocompress,blah,foo,bar)


-- 
Tomasz Chmielewski
http://wpkg.org
