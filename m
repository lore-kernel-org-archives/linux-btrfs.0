From: Chris Mason <chris.mason@oracle.com>
Subject: New btrfs command pushed into the btrfs-progs subvol branch -
 commands
Date: Thu, 11 Mar 2010 13:54:21 -0500
Message-ID: <20100311185421.GM6509@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pushed Goffredo's new btrfs utility into the subvol branch of the
btrfs-progs repo.  I'm using it as my starting point for the subvol
listing utility as well as my fancy new defrag range ioctl.

Goffredo, the new defrag ioctl takes a bunch of arguments, and I used
getopt inside the command to do it.  The tricky part is that getopt
expects argv[0] to be the command name, so I had to hack things a bit.

Could you please send a patch that changes the commands to include the
command name in argv[0]?  That'll make it easier to be flexible.

-chris
