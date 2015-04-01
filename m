Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38521 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbDAPmh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 11:42:37 -0400
Received: by wibgn9 with SMTP id gn9so71792286wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 08:42:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
 <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com> <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 11:42:16 -0400
Message-ID: <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, list,

thanks for your debugging ideas so far. Now this gets interesting. I
booted off a LiveUSB disk, and it just mounted sysroot. WTH?

See below. Perhaps the newer kernel (in latest F21) has regressed in
handling some kinds of errors during mount, or the dracut/systemd
mounting process is less resilient than mounting under a fully booted
system?


[root@localhost liveuser]# uname -a
Linux localhost 3.17.4-301.fc21.x86_64 #1 SMP Thu Nov 27 19:09:10 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

## Before booting into liveUSB, I made a copy of
## rdsosreport.txt in the /home partition
## which is a separate btrfs fs, and seems
## to not be affected by the problem at all
[root@localhost liveuser]# mkdir /myhome
[root@localhost liveuser]# mkdir /mysysroot
[root@localhost liveuser]# mount /dev/sda2 /myhome
[root@localhost liveuser]# ls /myhome
home  rdsosreport.txt

[root@localhost liveuser]# fpaste < /myhome/rdsosreport.txt
Uploading (93.4KiB)...
http://ur1.ca/k2zue -> http://paste.fedoraproject.org/205971/01928142

#### Strange, on first book from live USB F21 image, it just mounts
## (I tried about half a dozen cold boots earlier -- all resulting in
##  the same initramfs/dracut/systemd emergency shell...)
[root@localhost liveuser]# mount /dev/sda6 /mysysroot

Apr 01 11:26:51 localhost kernel: BTRFS info (device sda6): disk space
caching is enabled
Apr 01 11:26:56 localhost kernel: BTRFS: checking UUID tree
Apr 01 11:26:56 localhost kernel: SELinux: initialized (dev sda6, type
btrfs), uses xattr

[root@localhost liveuser]# ls /mysysroot
root
[root@localhost liveuser]# ls /mysysroot/root
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root
run  sbin  srv  sys  sysroot  tmp  usr  var

[root@localhost liveuser]# umount /dev/sda6
[root@localhost liveuser]# btrfs check /dev/sda6
Checking filesystem on /dev/sda6
UUID: 94637b35-a294-4be2-aa47-82c52d6d53ef
checking extents
checking free space cache
checking fs roots
root 256 inode 39841 errors 400, nbytes wrong
found 7747100703 bytes used err is 1
total csum bytes: 11912932
total tree bytes: 476725248
total fs tree bytes: 434733056
total extent tree bytes: 22986752
btree space waste bytes: 83962424
file data blocks allocated: 30820143104
 referenced 11997040640
Btrfs v3.17

[root@localhost liveuser]# btrfs check --repair /dev/sda6
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/sda6
UUID: 94637b35-a294-4be2-aa47-82c52d6d53ef
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 256 inode 39841 errors 400, nbytes wrong
found 7747100703 bytes used err is 1
total csum bytes: 11912932
total tree bytes: 476725248
total fs tree bytes: 434733056
total extent tree bytes: 22986752
btree space waste bytes: 83962424
file data blocks allocated: 30820143104
 referenced 11997040640
Btrfs v3.17



EOM

cheers,



martin
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
