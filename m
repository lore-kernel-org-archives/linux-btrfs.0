Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extern.sonoring.de ([212.23.155.200]:35837 "EHLO
	cmail.imagmbh.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932613AbbFJG6p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 02:58:45 -0400
From: Martin <develop@imagmbh.de>
To: Anand Jain <anand.jain@oracle.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: rw-mount-problem after raid1-failure
Date: Wed, 10 Jun 2015 08:58:40 +0200
Message-ID: <1631897.Efqz0Ef53G@malu-aspire-v3-771>
In-Reply-To: <5577DB6E.8000301@oracle.com>
References: <2227931.EqpnWnc32X@malu-aspire-v3-771> <pan$cff9$37e01034$74a19930$1abaea06@cox.net> <5577DB6E.8000301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand,

the

> mount -o degraded <good-disk> <-- this should work

is my problem. The fist times it works but suddently, after a reboot, it fails 
with message "BTRFS: too many missing devices, writeable mount is not allowed" 
in kernel log.

"btrfs fi show /backup2" shows:
Label: none  uuid: 6d755db5-f8bb-494e-9bdc-cf524ff99512
	Total devices 2 FS bytes used 3.50TiB
	devid    4 size 7.19TiB used 4.02TiB path /dev/sdb2
	*** Some devices missing

I suppose there is a "marker", telling the system only to mount in ro-mode?

Due to the ro-mount I can't replace the missing one because all the btrfs-
commands need rw-access ...

Martin

Am Mittwoch, 10. Juni 2015, 14:38:38 schrieb Anand Jain:
> Ah thanks David. So its 2 disks RAID1.
> 
> Martin,
> 
>   disk pool error handle is primitive as of now. readonly is the only
>   action it would take. rest of recovery action is manual. thats
>   unacceptable in a data center solutions. I don't recommend btrfs VM
>   productions yet. But we are working to get that to a complete VM.
> 
>   For now, for your pool recovery: pls try this.
> 
>      - After reboot.
>      - modunload and modload (so that kernel devlist is empty)
>      - mount -o degraded <good-disk> <-- this should work.
>      - btrfs fi show -m <-- Should show missing if you don't let me know.
>      - Do a replace of the missing disk without reading the source disk.
> 
> Good luck.
> 
> Thanks, Anand
> 
> On 06/10/2015 11:58 AM, Duncan wrote:
> > Anand Jain posted on Wed, 10 Jun 2015 09:19:37 +0800 as excerpted:
> >> On 06/09/2015 01:10 AM, Martin wrote:
> >>> Hello!
> >>> 
> >>> I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid
> >>> Vervet, btrfs-tools 3.17-1.1). One disk failed some days ago. I could
> >>> remount the remaining one with "-o degraded". After one day and some
> >>> write-operations (with no errrors) I had to reboot the system. And now
> >>> I can not mount "rw" anymore, only "-o degraded,ro" is possible.
> >>> 
> >>> In the kernel log I found BTRFS: too many missing devices, writeable
> >>> mount is not allowed.
> >>> 
> >>> I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I
> >>> did no conversion to a single drive.
> >>> 
> >>> How can I mount the disk "rw" to remove the "missing" drive and add a
> >>> new one?
> >>> Because there are many snapshots of the filesystem, copying the system
> >>> would be only the last alternative ;-)
> >> 
> >> How many disks you had in the RAID1. How many are failed ?
> > 
> > The answer is (a bit indirectly) in what you quoted.  Repeating:
> >>> One disk failed[.] I could remount the remaining one[.]
> > 
> > So it was a two-device raid1, one failed device, one remaining, unfailed.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

