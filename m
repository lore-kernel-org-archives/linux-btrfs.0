From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: curious writes on mounted, not used btrfs filesystem
Date: Sun, 22 May 2011 10:34:03 +0100
Message-ID: <20110522093352.GA22491@yahoo.fr>
References: <4DD7B6ED.5040403@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD7B6ED.5040403@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-21 14:58:21 +0200, Tomasz Chmielewski:
> I have a btrfs filesystem (2.6.39) which is mounted, but otherwise, not used:
> 
> # lsof -n|grep /mnt/btrfs

processes with open fds are one thing. You could also have loop
devices setup on it for instance.

> #
> 
> 
> I noticed that whenever I do "sync", btrfs will write for around 6.5s and write 13 MB (see below).
[...]

You could try and play with /proc/sys/vm/block_dump to see what
is being written (remember to disable logging of kernel messages
by syslog).

-- 
Stephane
