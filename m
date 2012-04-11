From: Robert <robweir@telus.net>
Subject: btrfs-tools error
Date: Wed, 11 Apr 2012 08:55:23 -0700
Message-ID: <4F85A96B.7080001@telus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
   I have been using 'btrfs' on F16 for several months.  I have used 
Gparted to change the size of the main partition where the OS resides 
(which is btrfs).  It has worked flawlessly on many different machines 
and I love the performance and concepts of this new Filesystem.
   Recently I was installing a system, on an Acer Laptop, and when I 
tried to take my basic originally created 28 gig partition and upsize it 
to the full 500 gigs on the Laptop, I received the error that follows.
   I contacted the Gparted devs and they suggested I report my problem 
to you directly, as they feel that it has something to do with 
'btrfs-tools'; which they have packaged in their Live CD.  The specific 
version that is in the Live CD I am using is 'btrfs-tools   
  0.19+20111105-2'.  The gparted version is 'gparted-live-0.11.0-7.iso'.
  The specific error message I obtained, on the failed attempt at 
resizing my btrfs partition follows:

    --->
root@debian:/home/user# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
udev on /dev type devtmpfs 
(rw,relatime,size=1348320k,nr_inodes=217903,mode=755)
devpts on /dev/pts type devpts 
(rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,noexec,relatime,size=270728k,mode=755)
/dev/sr0 on /live/image type iso9660 (ro,noatime)
tmpfs on /live/cow type tmpfs (rw,noatime,mode=755)
aufs on / type aufs (rw,relatime,si=31d9bc42)
tmpfs on /live type tmpfs (rw,relatime)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=5120k)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,relatime,size=541452k)
tmpfs on /run/shm type tmpfs (rw,nosuid,nodev,relatime,size=541452k)
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
root@debian:/home/user# btrfsck /dev/sda4
parent transid verify failed on 20975616 wanted 5017 found 2049
parent transid verify failed on 20975616 wanted 5017 found 2049
parent transid verify failed on 7972139008 wanted 3900 found 2261
parent transid verify failed on 7972139008 wanted 3900 found 2261
parent transid verify failed on 7972139008 wanted 3900 found 2261
parent transid verify failed on 7972139008 wanted 3900 found 2261
Ignoring transid failure
parent transid verify failed on 7951544320 wanted 2158 found 2233
parent transid verify failed on 7951544320 wanted 2158 found 2233
parent transid verify failed on 7951544320 wanted 2158 found 2233
parent transid verify failed on 7951544320 wanted 2158 found 2233
Ignoring transid failure
parent transid verify failed on 496713728 wanted 2129 found 2044
parent transid verify failed on 496713728 wanted 2129 found 2044
Check tree block failed, want=496713728, have=2003865692256319780
Check tree block failed, want=496713728, have=2003865692256319780
Check tree block failed, want=496713728, have=2003865692256319780
read block failed check_tree_block
parent transid verify failed on 7961153536 wanted 2768 found 918
parent transid verify failed on 7961153536 wanted 2768 found 918
leaf parent key incorrect 4635942912
bad block 4635942912
leaf parent key incorrect 4635987968
bad block 4635987968
leaf parent key incorrect 4640800768
bad block 4640800768
leaf parent key incorrect 7971569664
bad block 7971569664
leaf parent key incorrect 7973752832
bad block 7973752832
leaf parent key incorrect 7973883904
bad block 7973883904
leaf parent key incorrect 7981031424
bad block 7981031424
Check tree block failed, want=10229932032, have=18442222813175541743
Check tree block failed, want=10229932032, have=18442222813175541743
leaf parent key incorrect 4331397120
bad block 4331397120
leaf parent key incorrect 4331986944
bad block 4331986944
parent transid verify failed on 7965302784 wanted 2786 found 2255
parent transid verify failed on 7965302784 wanted 2786 found 2255
parent transid verify failed on 7965302784 wanted 2786 found 2255
parent transid verify failed on 7965302784 wanted 2786 found 2255
Ignoring transid failure
leaf 461414400 items 24 free space 2171 generation 2050 owner 2
fs uuid e6107ed8-05ff-4542-8a90-7f57231365f0
chunk uuid b909530c-a109-4201-9424-33d552339ce4
     item 0 key (256708608 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48146 6c 0) level 0
         tree block backref root 5
     item 1 key (256712704 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 2 key (256716800 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
         extent refs 1 gen 2038 flags 2
         tree block key (74539 60 283) level 0
         tree block backref root 5
     item 3 key (256720896 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 4 key (256733184 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
         extent refs 1 gen 44 flags 2
         tree block key (74403 18 3817753667) level 0
         tree block backref root 5
     item 5 key (256737280 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48150 1 0) level 0
         tree block backref root 5
     item 6 key (256741376 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48156 54 2399323466) level 0
         tree block backref root 5
     item 7 key (256753664 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 8 key (256757760 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 9 key (256761856 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 10 key (256765952 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
         extent refs 1 gen 2038 flags 2
         tree block key (292725 18 3817753667) level 0
         tree block backref root 5
     item 11 key (256770048 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
         extent refs 1 gen 2038 flags 2
         tree block key (298720 18 3817753667) level 0
         tree block backref root 5
     item 12 key (256774144 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48185 6c 0) level 0
         tree block backref root 5
     item 13 key (256778240 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (18446744073709551611 30 228569) level 0
         tree block backref root 5
     item 14 key (256782336 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48196 1 0) level 0
         tree block backref root 5
     item 15 key (256786432 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (38439 60 186) level 0
         tree block backref root 5
     item 16 key (256790528 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
         extent refs 1 gen 2036 flags 2
         tree block key (48202 6c 0) level 0
         tree block backref root 5
     item 17 key (256794624 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
         extent refs 1 gen 2039 flags 2
         tree block key (305577 1 0) level 0
         tree block backref root 5
     item 18 key (256798720 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
         extent refs 1 gen 2039 flags 2
         tree block key (305578 1 0) level 0
         tree block backref root 5
     item 19 key (256806912 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
         extent refs 1 gen 2039 flags 2
         tree block key (305579 1 0) level 0
         tree block backref root 5
     item 20 key (256811008 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
         extent refs 1 gen 2039 flags 2
         tree block key (305580 1 0) level 0
         tree block backref root 5
     item 21 key (256815104 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
         extent refs 1 gen 2039 flags 2
         tree block key (305581 1 0) level 0
         tree block backref root 5
     item 22 key (256823296 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
         extent refs 1 gen 2038 flags 2
         tree block key (292730 c 292729) level 0
         tree block backref root 5
     item 23 key (256827392 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
         extent refs 1 gen 2038 flags 2
         tree block key (292770 1 0) level 0
         tree block backref root 5
failed to find block number 4348379136
Aborted
root@debian:
<---

   Can anyone help me understand what this error really means?  Any help 
would be appreciated.  Cheers...
Robert
