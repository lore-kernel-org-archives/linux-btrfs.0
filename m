From: Massimiliano Adamo <maxadamo@gmail.com>
Subject: support of "chattr +c" flag
Date: Sun, 14 Feb 2010 22:36:39 +0100
Message-ID: <4B786CE7.9000709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

After trying the filesystem I noticed the following:
as you know the "chattr" have a "c" flag to provide transparent 
compression on directories/files.
Of course, to use this flag the filesystem must have the transparent 
compression feature, and must be aware of the flag itself.
In the case of ext4, the flag is properly set (and lsattr shows the "c" 
flag) but it won't work, because ext4 doesn't support transparent 
compression.
In the case of "btrfs" I cannot set the flag and I get the following error:
Operation not supported while setting flags on xxxx
Are you planning to support the use of this flag within btrfs?

cheers
Massimiliano
