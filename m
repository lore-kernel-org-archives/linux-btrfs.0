Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ocz85.ocztechnology.com ([64.79.114.85]:57679 "EHLO
	webmail.ocztechnology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3KVMJn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 07:09:43 -0500
From: Joshua Varghese <jvarghese@ocztechnology.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 22 Nov 2013 04:09:40 -0800
Subject: Re: Receive fails (Could not find parent subvolume)
Message-ID: <528F4984.8080000@ocztechnology.com>
References: <528E467B.40002@ocztechnology.com>
 <528F283F.5060903@ocztechnology.com> <528F3320.8040800@giantdisaster.de>
 <528F3599.6020303@ocztechnology.com>
In-Reply-To: <528F3599.6020303@ocztechnology.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you. it worked with 3.12.0 :)

On Fri 22 Nov 2013 10:44:41 GMT, Joshua wrote:
> Hi Stefan,
>
> Thank you for replying. I am running on a 3.10 kernel, will upgrade it
> and check.
>
> Regards
>
> On Fri 22 Nov 2013 10:34:08 GMT, Stefan Behrens wrote:
>> Re: Receive fails (Could not find parent subvolume)
>>
>> On Fri, 22 Nov 2013 01:47:43 -0800, Joshua Varghese wrote:
>> > Hi,
>> >
>> > I'm trying to implement a mechanism for incremental backup using
>> btrfs.
>> > I have two hardisks and each has a btrfs partition on it. I am able to
>> > take a snapshot of the source partition and send it to the backup disk
>> > using the send-recieve mechanism. When I try to send an incremental
>> > backup of a new snapshot with the previous snapshot as the parent
>> btrfs
>> > command complains (ERROR: could not find parent subvolume). The kernel
>> > logs also record a error (kernel: could not find root 9). I've listed
>> > the actual commands and their outputs below. Please let me know if you
>> > need any more information.
>> >
>> > # btrfs sub create check_backup
>> > /Create subvolume './check_backup/
>> > # touch check_backup/before_first_snap
>> > # btrfs sub snapshot -r check_backup/ first_snap
>> > /Create a readonly snapshot of 'check_backup/' in './first_snap'/
>> > # btrfs sub snapshot -r check_backup/ second_snap
>> > /Create a readonly snapshot of 'check_backup/' in './second_snap'/
>> >
>> > <second volume mounted at /mnt/gentoo/>
>> > # btrfs send  first_snap | btrfs receive /mnt/gentoo/backup/test/
>> > /At subvol first_snap//
>> > //At subvol first_snap//
>> > /# btrfs send  -p first_snap second_snap/ | btrfs receive
>> > /mnt/gentoo/backup/test/
>> > /At subvol second_snap///
>> > //At snapshot second_snap//
>> > //ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 40e9283cdf98a796, UUID_KEY,
>> > 0fc9a258f8cd8da7) ret=-1, //error: No such file or directory//
>> > //ERROR: could not find parent subvolume//
>> > /
>> > /(kernel log): kernel: could not find root 9/
>>
>> Works for me.
>>
>> How old is your kernel (which version)? You need 3.12 or better if you
>> use the most recent btrfs-progs. New progs and old kernel doesn't work
>> in this case, new kernel and old progs would work.
>>
>>
>> > As I understand the send command would take a difference between
>> the two
>> > snapshots and the send it to the receive. I used the file mechanism
>> > instead of the pipe and realized that the receive is the one that
>> complains.
>> > I'd also read in the documentation
>> >
>> (http://docs.oracle.com/cd/E37670_01/E37355/html/ol_sendrecv_btrfs.hml)
>> > about clone source. I don't understand its implication in incremental
>> > backup.
>> >
>> > Regards,
>> > Josh
>>

CONFIDENTIAL COMMUNICATION:  This communication including any attached file(s) is CONFIDENTIAL, intended only for the named recipient (s) above and contains trade secrets or other information that is exempt from disclosure under applicable law.  Any use, dissemination, distribution or copying of this communication and any file attachments by anyone other than the named recipient (s) is strictly prohibited. If you have received this communication in error, please immediately notify us by reply electronic mail and permanently delete the original transmission and any attachments from your computer system and any copies of this message and file attachments. Thank you.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
