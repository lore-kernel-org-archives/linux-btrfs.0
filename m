From: Arie Peterson <ariep@xs4all.nl>
Subject: Bug report: parent transid failed after heavy load
Date: Fri, 07 Jan 2011 11:59:31 +0100
Message-ID: <169b07a128b787f7e18550d2d3884374@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Dear all,


 During a move of some 60GB of data from an ext4 partition to a btrfs 
 partition, both on the same disk, the following happened:

 - my window manager froze;
 - the move suspended, i.e., no more data was written to the destination 
 or deleted from the source;
 - part of top output: (sorry for possible wrapping; sending this from 
 webmail)

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+ COMMAND
 
 13610 root      20   0     0    0    0 D   26  0.0 299:45.87 
 btrfs-cache-279
  1566 root      20   0     0    0    0 S   22  0.0 218:30.86 
 btrfs-endio-met

 (there were also a firefox instance and an npviewer.bin process still 
 consuming CPU time, but I guess this was some flash movie happily 
 playing along during the freeze);

 - those two btrfs processes could not be terminated, not even by kill 
 -9;
 - "lsof 1566" output (similar for the other process):

 COMMAND    PID USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
 btrfs-end 1566 root  cwd       DIR    8,6     4096    2 /
 btrfs-end 1566 root  rtd       DIR    8,6     4096    2 /
 btrfs-end 1566 root  txt   unknown                      /proc/1566/exe

 After a reboot, I am able to mount the btrfs filesystem, and read data 
 from it, but as soon as I try any write operation (even a simple touch), 
 that command hangs, and there are two btrfs processes hanging around, 
 just as above; dmesg gives lots of "parent transid failed" messages.

 My kernel is 2.6.36 (with gentoo patches).

 So, the questions:

 1) Is this a known problem? If so, is it fixed in a newer version?

 In the archive of this list, I read about others with "parent transid 
 failed" errors, and a recovery operation (suggested by Chris Mason), 
 using btrfs-select-super 
 <http://www.spinics.net/lists/linux-btrfs/msg07572.html>.

 2) Should I try this procedure to fix my filesystem? Is there any debug 
 information I should collect first? (I can recreate the two "spinning" 
 processes by rebooting and writing to the filesystem.)


 I am saddened by this failure, as this data move was actually part of 
 an operation to switch over to btrfs completely, after using it without 
 problems for quite a while.


 Thanks for any help. Keep up the good work.


 Regards,

 Arie Peterson

