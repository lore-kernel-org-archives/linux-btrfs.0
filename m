From: Henrik Kuhn <henrik.kuhn@origenis.de>
Subject: could not do orphan cleanup - openSUSE 12.1
Date: Wed, 02 May 2012 12:02:34 +0200
Message-ID: <4FA1063A.7080306@origenis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs-team/-users,

I do observe a strange behavior upon booting of my openSUSE 12.1 system 
( kernel 3.1.10-1.9-desktop; x86_64 ) with btrfsprogs-0.19-43.7.1.x86_64 
utils installed:

The system has two btrfs-vols: root(sda7) & home(sda8) and had been 
created during system setup of openSUSE 12.1:

# btrfs filesystem show
Label: none  uuid: a288fcff-28c8-4764-8efe-1e0cb205d588
         Total devices 1 FS bytes used 27.25GB
         devid    1 size 106.88GB used 67.29GB path /dev/sda8

Label: none  uuid: 4b3e5746-31aa-405a-a41f-540376ea5110
         Total devices 1 FS bytes used 17.93GB
         devid    1 size 40.00GB used 25.54GB path /dev/sda7

Btrfs v0.19+

The home-volume can not be mounted upon started with the msg:
btrfs: Error removing orphan entry, stopping orphan cleanup
btrfs: could not do orphan cleanup -22


Booting from the latest systemrescuecd (based upon Linux-kernel-3.0 :-( 
) a btrfsck-run on the home-vol(sda8) does not report any errors!
Whereas upon sda7 I got a lot of reportings concerning /tmp, /.snapshot, 
/var, /srv, /opt.
But I'm sure these msgs are related to the openSUSE 12.1 way of setup 
including the snapper-feature, because there a lot of subvols:

# btrfs subvolume list /
ID 256 top level 5 path tmp
ID 258 top level 5 path opt
ID 259 top level 5 path srv
ID 260 top level 5 path var/spool
ID 261 top level 5 path var/log
ID 262 top level 5 path var/run
ID 263 top level 5 path var/tmp
ID 271 top level 5 path .snapshots
ID 278 top level 5 path .snapshots/5/snapshot
ID 575 top level 5 path .snapshots/293/snapshot
...
... many, many more


Further I recognize in /var/log/messages some btrfs - orphan related 
entries:
Apr 17 09:06:57 ctrlaltdel kernel: [ 3120.205958] btrfs: unlinked 1 orphans
Apr 17 09:10:04 ctrlaltdel kernel: [ 3307.607220] btrfs: unlinked 15 orphans
Apr 17 09:11:04 ctrlaltdel kernel: [ 3367.233679] btrfs: unlinked 15 orphans
Apr 17 09:11:44 ctrlaltdel kernel: [ 3407.023880] btrfs: unlinked 16 orphans
Apr 17 09:11:51 ctrlaltdel kernel: [ 3414.172983] btrfs: unlinked 16 orphans
....
..
.
....
Apr 17 09:25:30 ctrlaltdel kernel: [ 4233.400005] btrfs: unlinked 16 orphans
Apr 17 09:26:24 ctrlaltdel kernel: [ 4286.905420] btrfs: unlinked 38 orphans
Apr 17 09:26:32 ctrlaltdel kernel: [ 4294.991357] btrfs: unlinked 38 orphans
Apr 17 09:30:03 ctrlaltdel kernel: [ 4505.997041] btrfs: unlinked 38 orphans
Apr 17 10:30:03 ctrlaltdel kernel: [ 8105.084759] btrfs: unlinked 36 orphans
Apr 17 11:30:02 ctrlaltdel kernel: [11704.102603] btrfs: unlinked 36 orphans
Apr 17 12:30:02 ctrlaltdel kernel: [15302.795729] btrfs: unlinked 36 orphans
Apr 17 13:30:02 ctrlaltdel kernel: [18902.596928] btrfs: unlinked 36 orphans
Apr 17 14:30:02 ctrlaltdel kernel: [22501.429646] btrfs: unlinked 36 orphans
Apr 17 15:30:03 ctrlaltdel kernel: [26101.699785] btrfs: unlinked 36 orphans
Apr 18 09:03:01 ctrlaltdel kernel: [ 2781.523782] btrfs: unlinked 1 orphans
Apr 24 08:38:03 ctrlaltdel kernel: [ 1223.527879] btrfs: unlinked 40 orphans
Apr 25 08:53:45 ctrlaltdel kernel: [ 2543.231171] btrfs: unlinked 2 orphans
Apr 25 09:15:02 ctrlaltdel kernel: [ 3819.781494] btrfs: unlinked 2 orphans
May  2 08:51:05 ctrlaltdel kernel: [    7.803471] btrfs: unlinked 8 orphans
May  2 09:09:51 ctrlaltdel kernel: [    9.405048] btrfs: unlinked 9 orphans
May  2 09:09:51 ctrlaltdel kernel: [   23.358868] btrfs: unlinked 1 orphans


Now the interesting part:
I can mount the home-vol RO and remount it RW without any error messages 
logged!
Since now I do not get any hourly generated oprhans logs.

But upon a system restart I need to ro-mount with a following rw-remout 
manually, again.


Any suggestions what to do?

Kind regards for your help.
Henrik Kuhn
