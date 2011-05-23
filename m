From: liubo <liubo2009@cn.fujitsu.com>
Subject: Backref walking utilities
Date: Mon, 23 May 2011 05:53:43 -0400
Message-ID: <4DDA2EA7.9080305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As one of my plans, I'm going to take this project over unless someone has been working on it.

>From wiki, quote:
    Backref walking utilities

    Given a block number on a disk, the Btrfs metadata can find all the files and directories
    that use or care about that block.  Some utilities to walk these back refs and print the
    results would help debug corruptions.

    Given an inode, the Btrfs metadata can find all the directories that point to the inode.
    We should have utils to walk these back refs as well. 
end quote.

And I have some thoughts to share with you:

    - Clearly, this is going to be another command.  Just like the command "btrfs-debug-tree",
      btrfs-walk-backref also needs to be able to track btrfs's metadata in
          a) the offline situation (at a umount state), or
          b) the corrupted situation.

    - For block number, the main goal is to find relative extent backrefs.  When it comes to
      those shared blocks, maybe things will be more complex.

    - For inode, the main goal is to find relative inode refs.  And we should be cautious about
      a) an inode with hard links, b) snapshot.

Did I miss or misunderstand something?  Any comments are welcomed. :)

thanks,
liubo
