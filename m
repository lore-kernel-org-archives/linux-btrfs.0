From: hurikhan77+btrfs@gmail.com
Subject: Re: system hangs after deleting bad file
Date: Sat, 22 Oct 2011 14:37:37 +0200
Message-ID: <i1qan8-m87.ln1@hurikhan.ath.cx>
References: <BwKod0ky1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Helmut!

I'm having the same observation currently: There are bad files in my $HOME 
and I can't delete them because it makes the kernel ooops. I tried Josef's 
repair program but it fails an assertion. What's your kernel backtrace? Did 
you try the repair program? Maybe we really got the same problem and could 
combine efforts? I filed an issue here:

https://github.com/josefbacik/btrfs-progs/issues/1

Helmut Hullen wrote:

> Hallo,
> 
> next problem (sorry):
> 
> my cluster of 3 2-TByte-disks has some damaged files. When I try to
> delete the directory entries with the "midnight commander" (via "putty",
> over the LAN) then "mc" hangs. Killing the putty session and opening
> (via "putty") a new "mc" window shows that the directory entry doesn't
> exist - looks good.
> 
> Mountpoint is "/mnt/btr".
> 
>         lsof /mnt/btr
> 
> still shows a "mc" entry which I can't remove with "killall -9 mc" or
> "kill -9 <mc-PID>".
> 
> And more bad:
> 
>         reboot
> 
> doesn't work,
> 
>         Ctrl Alt Delete
> 
> (on the machine, not over LAN) doesn't work too.
> 
> I have to restart the machine via main power switch - no good job.


