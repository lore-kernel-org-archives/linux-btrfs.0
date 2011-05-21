From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: curious writes on mounted, not used btrfs filesystem
Date: Sat, 21 May 2011 14:58:21 +0200
Message-ID: <4DD7B6ED.5040403@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem (2.6.39) which is mounted, but otherwise, not used:

# lsof -n|grep /mnt/btrfs
#


I noticed that whenever I do "sync", btrfs will write for around 6.5s and write 13 MB (see below).


If I do a "while true; do sync; done", there will be constant writes to btrfs filesystem (again - with no userspace program accessing btrfs).

When it happens, "btrfs-submit-0" is in "D" state.

What are these writes? I didn't notice anything like this with other filesystems.


$ iostat -t -k 1 sdb4|grep sdb4
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn

sdb4            320.00         0.00      1660.00          0       1660
sdb4            419.00         0.00      1720.00          0       1720
sdb4            291.00         0.00      1224.00          0       1224
sdb4            417.00         0.00      1736.00          0       1736
sdb4            609.00         0.00      2628.00          0       2628
sdb4            350.00         0.00      1452.00          0       1452
sdb4            606.00         0.00      2620.00          0       2620
sdb4            281.00         0.00      1516.00          0       1516
sdb4            352.00         0.00      1472.00          0       1472
sdb4            384.00         0.00      1584.00          0       1584
sdb4            533.00         0.00      2232.00          0       2232
sdb4            640.00         0.00      2660.00          0       2660


When btrfs is mounted with "compress" flag, there will be also reads when doing a similar operation.



See MB_wrtn before/after the sync:


$ iostat -t -m  sdb4
Linux 2.6.39-020639-generic (dom) 	05/21/2011 	_x86_64_	(8 CPU)

05/21/2011 02:45:46 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.47    0.01    1.25    8.01    0.00   88.26

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb4            127.39         0.92         1.94      94207     199343

$ time sync

real	0m6.808s
user	0m0.000s
sys	0m0.110s


$ iostat -t -m  sdb4
Linux 2.6.39-020639-generic (dom) 	05/21/2011 	_x86_64_	(8 CPU)

05/21/2011 02:46:02 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.47    0.01    1.25    8.01    0.00   88.26

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb4            127.40         0.92         1.94      94207     199356

$ time sync

real	0m6.628s
user	0m0.000s
sys	0m0.110s

$ iostat -t -m  sdb4
Linux 2.6.39-020639-generic (dom) 	05/21/2011 	_x86_64_	(8 CPU)

05/21/2011 02:46:55 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.47    0.01    1.25    8.01    0.00   88.27

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb4            127.37         0.92         1.94      94207     199369



-- 
Tomasz Chmielewski
http://wpkg.org
