From: "Helmut Hullen" <Hullen@t-online.de>
Subject: system hangs after deleting bad file
Date: 22 Oct 2011 11:52:00 +0200
Message-ID: <BwKod0ky1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

next problem (sorry):

my cluster of 3 2-TByte-disks has some damaged files. When I try to  
delete the directory entries with the "midnight commander" (via "putty",  
over the LAN) then "mc" hangs. Killing the putty session and opening  
(via "putty") a new "mc" window shows that the directory entry doesn't  
exist - looks good.

Mountpoint is "/mnt/btr".

        lsof /mnt/btr

still shows a "mc" entry which I can't remove with "killall -9 mc" or  
"kill -9 <mc-PID>".

And more bad:

        reboot

doesn't work,

        Ctrl Alt Delete

(on the machine, not over LAN) doesn't work too.

I have to restart the machine via main power switch - no good job.

Viele Gruesse!
Helmut
