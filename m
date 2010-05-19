From: Mathijs Kwik <bluescreen303@gmail.com>
Subject: the flushoncommit mount option
Date: Wed, 19 May 2010 09:04:35 +0200
Message-ID: <AANLkTimZ9JkeR-N-eCeeq3Ju-lhzzo8zkx_8im-qfjrD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Over the past few months, I've been trying out btrfs on separate mountpoints.
I like it very much so I would like to try it on my home or root
volumes and see if I can do something fun with the snapshots.
As btrfs still isn't production-ready, I made sure everything is
backed-up to an external ext4 disk.

Now when I first moved to try out ext4, there were some issues with
the way it handled commits(I think) compared to ext3, which made some
desktop-applications act weird.
This was fixed later, but I don't remember if it was ext4 to blame or
the apps changing their behavior to not depend on ext2/3 semantics.

Now, looking at btrfs's mount options, the flushoncommit description
sounded vaguely familiar regarding these ext4 oddities.
However, I couldn't find a good description of what the
(dis)advantages of flushoncommit would be.
On the volume I used upto now (music/video storage), I didn't notice
any differences, but maybe using it for home (dotfiles) or root will
be a bit different.

Does anyone remember the ext4 oddities I'm talking about?
Are they related to this flushoncommit mount option or am a totally
missing the point here?
And in case it is related... should I use the option for root or home
or is it safe to leave out?

Thanks for any information about this.
Mathijs

FYI: I'm using xubuntu 10.04 64bit, with (backported) 2.6.34 and the
latest btrfs-progs from git.
