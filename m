Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50677 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3CTNdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 09:33:51 -0400
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= COIFFIER <frederic.coiffier@free.fr>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Wed, 20 Mar 2013 14:33:38 +0100
Message-ID: <3160822.Hx5D6eTo7L@athlonxp>
In-Reply-To: <201303161916.55185.Martin@lichtvoll.de>
References: <6033676.gK0GbPgrpE@athlonxp> <201303161916.55185.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Thank you for your reply.

Le samedi 16 mars 2013 19:16:54 Martin Steigerwald a écrit :
> Am Freitag, 8. März 2013 schrieb Frédéric COIFFIER:
> > # btrfs scrub status /
> > scrub status for 6b6ea99b-edee-498d-bf07-f3a3f1cba2f3
> >         scrub started at Thu Mar  7 20:12:31 2013 and finished after 515 seconds
> >         total bytes scrubbed: 31.02GB with 6 errors
> >         error details: csum=6
> >         corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
> > 
> > I don't know what has produced this error (maybe an hard reset or a power cut) but I use an old not-SSD hard-disk.
> 
> This disk is still fine? Is smartctl -a happy with it?

It is old but it seems to be fine :

  9 Power_On_Hours          0x0032   077   077   000    Old_age   Always       -       20238
...
195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Always       -       63508940
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       1
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age   Always       -       0
...
SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     15811         -
# 2  Short offline       Aborted by host               20%     13984         -
# 3  Short offline       Completed without error       00%     13984         -
# 4  Short offline       Completed without error       00%       187         -

> > Today, I can't remove the file (and I can't delete its directory), updatedb runs during hours when it tries to read this file.
> > So, what is the best way to recover these errors (as I think that some files are definitely lost) ?
> > I would like to identify the corrupted files and to delete them.
> 
> I thought that with recent kernels BTRFS would report the file which is
> affected, but here it doesn´t seem so.

Yes, I read on a mailing list that a patch was proposed but with 3.8.1, it doesn't work.

> I think its also possibe to find out the file from the block number. But I
> do not remember the direct way to do it. I only know the other way around
> with filefrag -v or hdparm --fibmap - well actually file thinking on it,
> vice versa needs to have knowledge of filesystem structure… Maybe its
> possible to map something in the output in btrfs-debug-tree to above output.

In fact, yesterday, I make an rsync from btrfs to ext4 and rsync has reported "Stale NFS handle errors" for these files.
So, now there are now longer problem about that.
The most annoying thing is that we can't delete these files. So, the only way to solve these problems is to replace the filesystem.

> But I really think BTRFS displays the filename affected meanwhile. So
> maybe if it does not, its some metadata being affected? So output of btrfsck
> hints at that and that you can´t remove the file does as well. What happens
> if you try to remove the file? Do you get an input/output error or
> something like that?

# rm -rf *
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
rm: cannot remove 'drivers/misc/lis3lv02d/lis3lv02d.c': Stale NFS file handle
...

> Maybe someone else can help with that.
> 
> Aside from that: Thats uncorrectable errors for a reason :)

Yes, I absolutely agree that we can't recover some files but btrfsck sould propose to recover these error (like fsck.ext4) even if we loose some data.
In fact, I never got this kind of problem with ext filesystems.

Regards,
Frederic
