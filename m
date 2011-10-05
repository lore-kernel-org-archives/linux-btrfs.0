From: Jim <jim@webstarts.com>
Subject: too many files open
Date: Wed, 05 Oct 2011 11:24:27 -0400
Message-ID: <4E8C76AB.6080401@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good morning Btrfs list,
I have been loading a btrfs file system via a script rsyncing data files 
from an nfs mounted directory.  The script runs well but after several 
days (moving about 10TB) rsync reports that it is sending the file list 
but stops moving data because btrfs balks saying too many files open.  A 
simple umount/mount fixes the problem.  What am I flushing when I 
remount that would affect this, and is there a way to do this without a 
remount.  Once again thanks for any assistance.
Jim
