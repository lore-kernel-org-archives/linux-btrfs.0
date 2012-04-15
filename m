From: Marc MERLIN <marc@merlins.org>
Subject: Creating backup snapshots (8 per filesystem) causes No space left on device?
Date: Sun, 15 Apr 2012 08:07:41 -0700
Message-ID: <20120415150740.GA10248@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

I have a little script that creates hourly/daily/weekly snapshots on a device that
otherwise has plenty of disk space free:
gandalfthegreat:~# df -h | grep cryptroot
/dev/mapper/cryptroot     232G  144G   85G  63% /
/dev/mapper/cryptroot     232G  144G   85G  63% /usr
/dev/mapper/cryptroot     232G  144G   85G  63% /var
/dev/mapper/cryptroot     232G  144G   85G  63% /home
/dev/mapper/cryptroot     232G  144G   85G  63% /tmp
/dev/mapper/cryptroot     232G  144G   85G  63% /mnt/btrfs_pool1

I have kernel 3.3.1.

The FAQ of course talks about the topic:
https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html

but I can't get the filesystem show command to output anything useful:
gandalfthegreat:~# btrfs filesystem show /dev/mapper/cryptroot 
Btrfs Btrfs v0.19
gandalfthegreat:~# 

and the btrfs df ssems to show that I'm ok:
gandalfthegreat:~# btrfs filesystem df /home
Data: total=169.01GB, used=134.70GB
System, DUP: total=8.00MB, used=28.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=5.88GB, used=4.39GB
Metadata: total=8.00MB, used=0.00
gandalfthegreat:~# 

I read about rebalance but it's a mostly new fliesystem will little churn, and I'm 
not anywhere close to full filesystem yet.

So far, when this happened, I've had to delete a set of older snapshots.
This would make sense if I was close to full, but at 63% I'm nowhere that.

Any idea what's going on and how I can debug further and more specifically
what I should capture next time I get a no free space error in userspace?

Thanks,
Marc


gandalfthegreat:/mnt/btrfs_pool1# l
total 4
dr-xr-xr-x 1 root root 2210 Apr 15 08:00 ./
drwxr-xr-x 1 root root  112 Feb 12 17:38 ../
drwxr-xr-x 1 root root   12 Feb 12 17:57 home/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_daily_20120412_00:01:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_daily_20120413_00:01:02/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_daily_20120414_00:01:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_daily_20120415_00:01:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_hourly_20120415_06:00:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_hourly_20120415_07:00:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_hourly_20120415_08:00:01/
drwxr-xr-x 1 root root   12 Feb 12 17:57 home_weekly_20120415_00:02:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_daily_20120412_00:01:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_daily_20120414_00:01:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_daily_20120415_00:01:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_hourly_20120415_06:00:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_hourly_20120415_07:00:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_hourly_20120415_08:00:01/
drwxr-xr-x 1 root root  436 Apr  3 07:26 root_weekly_20120415_00:02:01/
drwxrwxrwt 1 root root 7476 Apr 15 08:05 tmp/
drwxrwxrwt 1 root root 7156 Apr 12 00:01 tmp_daily_20120412_00:01:01/
drwxrwxrwt 1 root root 7130 Apr 13 00:01 tmp_daily_20120413_00:01:02/
drwxrwxrwt 1 root root 7236 Apr 14 00:01 tmp_daily_20120414_00:01:01/
drwxrwxrwt 1 root root 7368 Apr 15 00:01 tmp_daily_20120415_00:01:01/
drwxrwxrwt 1 root root 7368 Apr 15 06:00 tmp_hourly_20120415_06:00:01/
drwxrwxrwt 1 root root 7368 Apr 15 07:00 tmp_hourly_20120415_07:00:01/
drwxrwxrwt 1 root root 7476 Apr 15 08:00 tmp_hourly_20120415_08:00:01/
drwxrwxrwt 1 root root 7368 Apr 15 00:02 tmp_weekly_20120415_00:02:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_daily_20120412_00:01:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_daily_20120413_00:01:02/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_daily_20120414_00:01:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_daily_20120415_00:01:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_hourly_20120415_06:00:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_hourly_20120415_07:00:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_hourly_20120415_08:00:01/
drwxr-xr-x 1 root root  206 Mar 31 11:07 usr_weekly_20120415_00:02:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_daily_20120412_00:01:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_daily_20120413_00:01:02/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_daily_20120414_00:01:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_daily_20120415_00:01:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_hourly_20120415_06:00:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_hourly_20120415_07:00:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_hourly_20120415_08:00:01/
drwxr-xr-x 1 root root  130 Feb 12 23:52 var_weekly_20120415_00:02:01/

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
