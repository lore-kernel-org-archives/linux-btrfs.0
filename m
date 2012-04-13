From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: btrfs mount flags
Date: Fri, 13 Apr 2012 17:50:45 +0200
Message-ID: <jjul59-m49.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Is there any documentation about btrfs mount flags wrt:

1. which flags are one-time options and are permanent,
2. which flags are global per btrfs partition,
3. which flags are local per subvolume mount?

I'm asking because while googling I found very confusing info about 
autodefrag. Some say it is a global flag, others say to get autodefrag one 
has to supply it for each subvolume mount to have autodefrag for that 
subvolume.

Then there's space_cache which is a one-time option and does not need to be 
given on successive mounts. Otoh there's inode_cache which I would expect to 
be handled the same but it doesn't look like it's implemented that way.

Then maybe there are flags which are obsolete meanwhile because they are 
default features with later kernel versions.

Thanks,
Kai

