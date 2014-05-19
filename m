Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:60240 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESMy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 08:54:26 -0400
Received: by mail-la0-f49.google.com with SMTP id pv20so4011167lab.36
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 05:54:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140517222321.GM10192@merlins.org>
References: <E1WiphR-0003MN-50@legolas.merlins.org>
	<20140510224249.GA15909@merlins.org>
	<20140512232609.GI14174@merlins.org>
	<CAL3q7H6K6b_oZKYZDtHCBCieL_Ya9DHSkN3Rug5azqR6gzDVAQ@mail.gmail.com>
	<20140514132618.GB13083@merlins.org>
	<20140517222321.GM10192@merlins.org>
Date: Mon, 19 May 2014 13:54:25 +0100
Message-ID: <CAL3q7H7cMHpDeZKfip7431SiiC9H4F3YmucvVuCqOGC0uZDKBA@mail.gmail.com>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub warn of
 silent corruption?
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 17, 2014 at 11:23 PM, Marc MERLIN <marc@merlins.org> wrote:
> Before I delete this and start over, anything else you'd like from it?

Can you create an image of the fs with btrfs-image
(https://btrfs.wiki.kernel.org/index.php/Btrfs-image) and uploaded it
somewhere (or send it to me directly) to see if it's easy to
reproduce?

thanks

>
> Also, it the 3.15rc5 deadlock I had, did not occur again.
> So, I think it may well have been related to my doing a big
> send/receive.
> See "3.15rc5 deadlock" thread.
>
> Marc
>
> On Wed, May 14, 2014 at 06:26:18AM -0700, Marc MERLIN wrote:
>> On Tue, May 13, 2014 at 09:11:34PM +0100, Filipe David Manana wrote:
>> > > Is there anything you'd like from the subvolumes on the source that
>> > > btrfs cannot process and that I'm going to delete so that I can start
>> > > syncing back from the SSD to the HDD?
>> >
>> > For the issue you had with send sending weird path names, I just found
>> > a case that leads to it (or a crash or some other weird stuff):
>> >
>> > https://patchwork.kernel.org/patch/4170401/
>> >
>> > But you really need to be using a lot of hard links and deleting them,
>> > so maybe it's caused by something else.
>>
>> Unfortunately, even with your patch, I see get
>> legolas:/mnt/btrfs_pool2# btrfs send home_ro.20140507_10\:00\:01 | btrfs receive /mnt/btrfs_pool1/
>> At subvol home_ro.20140507_10:00:01
>> At subvol home_ro.20140507_10:00:01
>> ERROR: chown merlin/.config/google-chrome-mysetup/ ��� failed. No such file or directory
>>
>>
>> I just ran btrfsck and I see nothing majorly wrong with the source
>> filesystem:
>> legolas:~# btrfsck /dev/mapper/disk2 2>&1 |tee /tmp/fsck
>> checking extents
>> checking free space cache
>> checking fs roots
>> root 22504 inode 1926322 errors 400, nbytes wrong
>> Checking filesystem on /dev/mapper/disk2
>> UUID: 6afd4707-876c-46d6-9de2-21c4085b7bed
>> free space inode generation (0) did not match free space cache generation (78684)
>> free space inode generation (0) did not match free space cache generation (75988)
>> free space inode generation (0) did not match free space cache generation (76193)
>> free space inode generation (0) did not match free space cache generation (28818)
>> free space inode generation (0) did not match free space cache generation (28818)
>> free space inode generation (0) did not match free space cache generation (33187)
>> free space inode generation (0) did not match free space cache generation (31543)
>> free space inode generation (0) did not match free space cache generation (16710)
>> found 283033724420 bytes used err is 1
>> total csum bytes: 663653972
>> total tree bytes: 7333687296
>> total fs tree bytes: 5844262912
>> total extent tree bytes: 631451648
>> btree space waste bytes: 1497868045
>> file data blocks allocated: 1081231372288
>>  referenced 807338209280
>> Btrfs v3.14.1
>>
>>
>> To be clear, I do not need this to work, this is a snapshot I'm going to
>> delete anyway, but if there is anything you'd like me to try or capture
>> for you to help with improving the code, please let me know.
>>
>> Marc
>> --
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                       .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
