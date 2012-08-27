Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49808 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2H0JQh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 05:16:37 -0400
Received: by obbuo13 with SMTP id uo13so7678293obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2012 02:16:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50388BBF.70903@robertbuhren.de>
References: <5028D57F.5090803@robertbuhren.de>
	<1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
	<5035EFDE.4090404@robertbuhren.de>
	<20120824133348.GY17430@twin.jikos.cz>
	<50388BBF.70903@robertbuhren.de>
Date: Mon, 27 Aug 2012 12:16:36 +0300
Message-ID: <CAHf9xvZ-VRx7yWZoqp-NMwzwmxHsjhBDS6agJfcY+3VcwjsA2g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Robert Buhren <robert@robertbuhren.de>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Robert,
do you think you can make the "root_snap_send" file of yours available
anywhere (not sure how big it is)?

Also, I am not sure I understand how you btrfs tree looks like WRT to
where all subvolumes are mounted (but all others seem to understand
well).

You mentioned:
> /dev/loop0 on /mnt/TEST_ROOT type btrfs (rw,relatime,compress=lzo,space_cache)  # default-subvolume
> /dev/loop0 on /mnt/TEST_ROOT/root_volid0 type btrfs (rw,relatime,compress=lzo,space_cache) # subvolid= 0
> /dev/loop1 on /mnt/TEST_ROOT/backup_volid0 type btrfs (rw,relatime,compress=lzo,space_cache)

> btrfs subvolume snapshot -r /mnt/TEST_ROOT/root_volid0/root/ /mnt/TEST_ROOT/root_volid0/root_snap
Are you trying to snapshot a directory here? I.e., what is "root"
within "root_volid0"?
Can you pls list all subvolumes you have on your source filesystem
(the one you are trying to backup), and where each one is mounted?
Again, looks like I'm the only one confused about this, so apologies.

You can also possibly use the "tree" utility to better visualize your
fs tree, like:
tree -A  --inodes --noreport /mnt/TEST_ROOT

Jan, David, hope it's ok with you if I'll try to debug this.

Thanks,
Alex.






On Sat, Aug 25, 2012 at 11:24 AM, Robert Buhren <robert@robertbuhren.de> wrote:
> On 24.08.2012 15:33, David Sterba wrote:
>>
>> On Thu, Aug 23, 2012 at 10:54:54AM +0200, Robert Buhren wrote:
>>>
>>> I'm on linux-3.6-rc2 and btrfs-progs from git.
>>
>> Please try it with Chris' for-linus branch, it contains a fair portion
>> of send-related fixes and from brief look they may be related to the
>> errors you see.
>>
>> david
>
> Hi David,
>
> i just tried it with a kernel from the "for-linus" branch. But i still get
> the same error.
> Just to be sure:
> You ment this branch:
> http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=shortlog;h=refs/heads/for-linus
>
> right?
>
>
> Regards,
>
> Robert
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
