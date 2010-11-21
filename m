From: Alexander Kolesen <kolesen.a@gmail.com>
Subject: [JFS] Kernel oops when tried to access mounted but unplugged storage
Date: Sun, 21 Nov 2010 14:24:25 +0200
Message-ID: <20101121122423.GF4024@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jfs-discussion@lists.sourceforge.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello.
I've built a kernel from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
(Date: Fri Nov 19 19:46:45 2010 -0800)
and got a kernel oops when tried to access to unplugged,
but mounted external usb storage formatted with JFS.
 
Steps to reproduce:
  mkfs.jfs /dev/sdb1 (unpluggable USB hard drive)
  mount /dev/sdb1 /mnt/drive
  cd /mnt/drive
  touch test
  sync
  ..unplug a drive
  ls
  
   
Result:
  BUG: unable to handle kernel NULL pointer dereference at
  0000000000000020
  IP: __mark_inode_dirty
    
Then I got a kernel coredump. Here is a stack trace:
     
  (gdb) bt
  #0 __mark_inode_dirty (inode=0xffff880078fc1490, flags=<value
  optimized out>) at fs/fs-writeback.c:990
  #1 0xffffffff810e4990 in mark_inode_dirty_sync
  (mnt=0xffff88007862fd00, dentry=<value optimized out>) at
  include/linux/fs.h:1687
  #2 touch_atime (mnt=0xffff88007862fd00, dentry=<value optimized
  out>) at fs/inode.c:1505
  #3 0xffffffff810dfeb4 in file_accessed (file=0xffff88006afed600,
  filler=0xffffffff810dfcf8 <filldir>, buf=0xffff88007762bf38) at
  include/linux/fs.h:1763
  #4 vfs_readdir (file=0xffff88006afed600, filler=0xffffffff810dfcf8
  <filldir>, buf=0xffff88007762bf38) at fs/readdir.c:41
  #5 0xffffffff810e001a in sys_getdents (fd=<value optimized out>,
  dirent=0x1f61468, count=32768) at fs/readdir.c:214
  #6 0xffffffff810279ab in ?? () at arch/x86/kernel/entry_64.S:479
  #7 0x00007f8b23d1a4c5 in ?? ()
  #8 0x00000000000002bb in ?? ()
  #9 0x0000000000000000 in ?? ()
      
  (gdb) p bdi
  $1 = (struct backing_dev_info *) 0x0
       
  (gdb) p inode->i_mapping->backing_dev_info
  $15 = (struct backing_dev_info *) 0xffff880078878d48
        
  (gdb) p inode->i_sb->s_bdi
  $16 = (struct backing_dev_info *) 0x0
	 
	  
I can't do git bisect because on n'th step my system became
unbootable. But 2.6.35 doesn't fall.
