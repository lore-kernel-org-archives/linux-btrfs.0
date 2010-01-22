From: =?iso-8859-2?Q?Jarom=EDr=20C=E1p=EDk?= <tavvva@seznam.cz>
Subject: =?us-ascii?Q?btrfs=20bad=20tree=20block=20start=20?=
Date: Fri, 22 Jan 2010 16:08:01 +0100 (CET)
Message-ID: <6227.2322.6038-7563-1397129237-1264172881@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

3 days ago I switched my root fs from ext4 to btrfs.
The system was working without problems till this morning.
I got 2 "btrfs bad tree block start 3581956096 3581652992"
messages while booting and later I discovered that 
some fonts were corrupted. 

/usr/share/fonts/TTF/liberation/*

I tried to reinstall the liberation font package, 
but the system got frozen. 
I tried to run btrfsck from USB stick (the same 
kernel version 2.6.32-3 and btrfsprogs 0.19),
but I got "Segmentation fault".

I cannot delete the mentioned directory.
It seems to be empty, but I still get the following
message : "directory not empty".

The only workaround was to rename the directory
and reinstall the font package (a new directory was
created and the liberation font is usable again).

I would like to know if there's any way how to delete
the corrupted directory or how to make the btrfsck working.

I can also provide You with some debug info
when needed.

Thanks in advance for any kind of help.

Regards,
Jaromir Capik.
