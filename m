From: David Nicol <davidnicol@gmail.com>
Subject: survey of command line interfaces for working with snapshots
Date: Wed, 25 Nov 2009 09:13:20 -0600
Message-ID: <934f64a20911250713i591badd7i516576624fa5bea6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2009 at 12:27 PM, Goffredo Baroncelli <kreijack@libero.it>

> Yes, I can remount the sub-volume with the mount command anywhere and with an arbitrary name. In fact the thing that seems strange to me is that when I create a snapshot, immediately it is mounted: it is not a real problem, it is only a strange behaviour. The "standard" behaviour is to create the file-system and then mount it: two separate actions.

GB is correct: Tru64's ADVfs snapshots, which were (are?) essentially
the same as btrfs snapshots, were (are?) not mounted on creation

http://www.tru64unix.compaq.com/docs/base_doc/DOCUMENTATION/V51B_HTML/MAN/MAN4/0124____.HTM

indicates that these things were (are?) called "clones"

and http://www.tru64unix.compaq.com/docs/base_doc/DOCUMENTATION/V51B_HTML/MAN/MAN8/0048____.HTM

 Here's the example code for creating and mounting a clone with tru64
ADVfs, from clonefset(8):

  The following example creates a read-only copy of the credit_fs fileset
  that resides in the accounts_dmn domain.  The clone fileset name in this
  example is credit_clone1.  This example also performs an online backup and
  removes the clone fileset after the backup is complete:

       # mkdir /mnt/credit_clone1
       # clonefset accounts_dmn credit_fs credit_clone1
       # mount -t advfs account_dmn#credit_clone1 /mnt/credit_clone1
       # vdump /mnt/credit_clone1
       # umount /mnt/credit_clone1
       # rmfset account_dmn credit_clone1
