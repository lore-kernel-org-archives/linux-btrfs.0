Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40034 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbbFQR6c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 13:58:32 -0400
Date: Wed, 17 Jun 2015 10:58:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Message-ID: <20150617175805.GO16468@merlins.org>
References: <20140908015124.GA21441@merlins.org>
 <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
 <20140915001836.GU8530@merlins.org>
 <20150511214412.GE15670@merlins.org>
 <CAL3q7H7SYfka5MK=8XZkw1m7PGjyR-1fzrD0tP_=dhznQ5QdGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7SYfka5MK=8XZkw1m7PGjyR-1fzrD0tP_=dhznQ5QdGQ@mail.gmail.com>
Subject: Re: btrfs differential receive has become excrutiatingly slow on one
 machine
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 12:35:20PM +0100, Filipe David Manana wrote:
> > It's a broad question, but how can I diagnose btrfs send being so slow
> > without taking the risk of killing my connection?
> > (if there is no good answer on this one, I can try another sync later
> > with -vvv and strace if you'd like)
> 
> Try to see if it's a problem at the sending side or at the receiving
> side. Redirect send's output to a file, see how much it takes. Then
> run receive with that file as input and see how long it takes.
> You can also use 'perf record -ag' while doing both, it might give
> some useful information.

Hi Filipe, sorry this took a while, I've been away and then had my
server hardware die, but things are back up and I'm now trying to sync a
100GB btrfs diff from my laptop to my server.

I've confirmed that btrfs send is fast (I sent it to a file)
Then scp of the diff is fast too (45mn for 100GB over wireless)
But the restore is slow. I see files going by quickly, and then hangs and restarts.

You requested strace -T in the past. I'm showing an exerpt of system calls that take
more than 1 second.

When I see this, I get worried:
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432663866_0.19916.legolas,U=427356,FMD5=7e806062200fb6d33546530d24aac86c:2,", 21043) = 0 <19.335333>

Or this:
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/media/tuners/mt2266.mod.dwo") = 0 <28.298224>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/INBOX/cur/1432061846_0.2789.legolas,U=381014,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,") = 0 <45.084068>

19 seconds for a truncate or 28 or 45 seconds for an unlink cannot be right of course.

It's btrfs over dmcrypt over swraid5 (5 drives). Filesystem is only half full:

gargamel:~# btrfs fi show /mnt/btrfs_pool2/
Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
        Total devices 1 FS bytes used 4.34TiB
        devid    1 size 7.28TiB used 4.43TiB path /dev/mapper/dshelf2

gargamel:~# btrfs fi df /mnt/btrfs_pool2/
Data, single: total=4.28TiB, used=4.28TiB
System, DUP: total=8.00MiB, used=496.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=77.50GiB, used=68.05GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=192.00KiB


More system calls:

gargamel:~# grep ' <[1-9]'  /mnt/btrfs_pool2/strace
ioctl(3, BTRFS_IOC_SNAP_CREATE_V2, 0x7ffca6be3a40) = 0 <11.430413>
link("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/tmp01/dsc05964.jpg", "/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/albums/Outings/Dinners/Misc/20150228_Alexander_Patisserie.jpg") = 0 <1.572029>
) = 93 <1.195424>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Storage/ext/beknehfpfkghjoafdifaflglpjkojoco/def/Cookies", 7168) = 0 <53.618366>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/iio/dac/.ad7303.ko.cmd") = 0 <64.146415>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/iio/dac/.mcp4725.ko.cmd") = 0 <10.403782>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/iio/dac/ad5360.mod.dwo") = 0 <2.180297>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/iio/dac/ad5360.mod.o") = 0 <1.278088>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/md/persistent-data/built-in.o") = 0 <3.706420>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/media/tuners/mt2266.mod.dwo") = 0 <28.298224>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/media/usb/dvb-usb-v2/.tmp_af9035.dwo") = 0 <7.626091>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/src/linux-3.19.8-amd64-i915-volpreempt-s20150421/drivers/net/wimax/i2400m/i2400m.ko") = 0 <25.749138>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-unstable/Default/Cache/f_002221") = 0 <1.751792>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/INBOX/cur/1432061343_0.31033.legolas,U=381013,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,") = 0 <10.108744>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/INBOX/cur/1432061846_0.2789.legolas,U=381014,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,") = 0 <45.084068>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-unstable/Default/Application Cache/Cache/f_000406") = 0 <1.018996>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-unstable/Default/IndexedDB/https_docs.google.com_0.indexeddb.leveldb/004187.ldb") = 0 <1.421004>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Cache/f_000113") = 0 <3.521448>
utimensat(AT_FDCWD, "/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Cache", {{1432074658, 417493132}, {1434520921, 352677949}}, AT_SYMLINK_NOFOLLOW) = 0 <7.411364>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Cache/f_000114") = 0 <1.069991>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Application Cache/Cache/f_0058af") = 0 <11.624418>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Application Cache/Cache/f_0058b0") = 0 <13.887990>
unlink("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/.config/google-chrome-beta/Profile 1/Application Cache/Cache/f_0058bf") = 0 <1.050436>
utimensat(AT_FDCWD, "/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/o2323882-50676-0/204_20150519_WLW_PAO.jpg", {{1432186112, 0}, {1432186112, 0}}, AT_SYMLINK_NOFOLLOW) = 0 <1.487349>
link("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/tmp06/dsc00007.jpg", "/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/PrivPix/albums/Home/Misc/Barranca/850_Garage_Door.jpg") = 0 <1.296418>
read(0, "\17\0%\0www/Pix/new/Div1pix/orig/dsc"..., 49209) = 49209 <3.409544>
read(0, "\17\0%\0www/Pix/new/Div1pix/orig/dsc"..., 49209) = 49209 <1.708734>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div1pix/orig/dsc00117.jpg", 4043020) = 0 <30.348609>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div1pix/orig/dsc00118.jpg", 3271147) = 0 <19.919724>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div1pix/orig/dsc00119.jpg", 4152259) = 0 <5.785387>
pwrite(5, "\314\362\221O\202\302\10@4\16Ikv\243\365fnV\251\317\243  <4(\34s\251LB\227"..., 49152, 10485760) = 49152 <0.000023>
pwrite(5, "_\255\250\351n\323\211 <2PH\23\250  ;\255f9\30x3.\301\307,\262T\3%>"..., 49152, 16924672) = 49152 <0.000023>
pwrite(5, "vD_'\241\3051\251,\5\2\250E\32\252~\256\323\30\2\341\303 <2\233H\21202\221v"..., 49152, 5865472) = 49152 <0.000031>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00157"..., 49204) = 49204 <3.668907>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00157"..., 49204) = 49204 <4.023088>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00175.ARW", 20588032) = 0 <11.129091>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00176"..., 49204) = 49204 <8.645482>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00189"..., 49204) = 49204 <1.369523>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00189.ARW", 20804096) = 0 <2.916934>
pwrite(5, "\237\225+\255&#\201x4\17\20\244\360\220 <5\205(\255\210r\331l4\227\4%\301\350\214:"..., 49152, 12582912) = 49152 <0.000020>
pwrite(5, "\252\207\273\213\205\0X|D\215H\4\200x\210r\364\336\366\353d\3408(*\214\203#Q <2"..., 49152, 17072128) = 49152 <0.000037>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00211"..., 49204) = 49204 <6.216209>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00211"..., 49204) = 49204 <2.990708>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00211.ARW", 21403136) = 0 <3.533557>
pwrite(5, "D\263\26\3G\0051\201|>!\224\254\325:\255\254\222S\213@\201` <4\213C\243B\321<"..., 49152, 13549568) = 49152 <0.000027>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00225.ARW", 20851200) = 0 <8.745869>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00226.ARW", 20775936) = 0 <4.497084>
pwrite(5, "\250\36\353\217eb <4\237\217\352\346+:\24186g\3\241\20\241T.\240\225\255\250\244F\243"..., 49152, 11255808) = 49152 <0.000025>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00250"..., 49204) = 49204 <1.323551>
read(0, "\17\0 \0www/Pix/new/Div2pix/DSC00250"..., 49204) = 49204 <8.653995>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00250.ARW", 21162496) = 0 <4.062709>
pwrite(5, "\270#\327\v\304\342\200\230T\22\33\v,U\372\252\5\316\351\vG\22 <2\"\225N\352mZ\255"..., 49152, 11829248) = 49152 <0.000019>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00277.ARW", 21304320) = 0 <24.996196>
pwrite(5, "\3422\224\27\302D\320 <2\235\217g\303\252\244W\266lG\241@\261tT\252_\316W\203\202\267"..., 49152, 18595840) = 49152 <0.000021>
pwrite(5, "z\23Y8\t\346\344\t\f*\222Q$r\0214FCW\24\210\303\303 <6\35\323'#\360P"..., 49152, 3817472) = 49152 <0.000023>
pwrite(5, ":BO\230LG\241\231\10\10\211\300B0 <2d\26(\357\303\231=\2\212B#p\0IT"..., 49152, 11059200) = 49152 <0.000033>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00313.ARW", 20855808) = 0 <10.785386>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00314.ARW", 20806656) = 0 <1.424402>
pwrite(5, "\0274\327\303\200qP$\22\224\305$\324\212\311\206\306R\222\223\306\341\340 <6\234\314f\23\232\341"..., 49152, 868352) = 49152 <0.000020>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00345.ARW", 20960256) = 0 <7.405145>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/www/Pix/new/Div2pix/DSC00346.ARW", 20952064) = 0 <17.107006>
pwrite(5, "\26\2\17\n\6a\00080$\24K\342p \34*}\340\265`\20( <1!m\3020\24\22"..., 32768, 7831552) = 32768 <0.000028>
rename("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/o2241724-43287-0", "/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432663866_0.19916.legolas,U=427356,FMD5=7e806062200fb6d33546530d24aac86c:2,") = 0 <6.434152>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432663866_0.19916.legolas,U=427356,FMD5=7e806062200fb6d33546530d24aac86c:2,", 21043) = 0 <19.335333>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432663868_0.19916.legolas,U=427355,FMD5=7e806062200fb6d33546530d24aac86c:2,", 688135) = 0 <6.613715>
truncate("/mnt/btrfs_pool2/backup/debian64/legolas/varchange_ggm_daily_ro.20150616_23:06:10/merlin-change/Maildir.google/lists2/new/1432665782_0.19916.legolas,U=427359,FMD5=7e806062200fb6d33546530d24aac86c:2,", 10795) = 0 <1.009631>

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
