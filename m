Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55972 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3CNEcc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 00:32:32 -0400
Received: by mail-wi0-f173.google.com with SMTP id hq4so3383289wib.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 21:32:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFy8SQVzHYXmCkwgJ2tmE4QoZDGF4z1efN4z4CkVACQi2LEY_Q@mail.gmail.com>
References: <CAFy8SQVzHYXmCkwgJ2tmE4QoZDGF4z1efN4z4CkVACQi2LEY_Q@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Thu, 14 Mar 2013 05:32:11 +0100
Message-ID: <CAFWF=amiXCdrvrWnuPW5-bn2V5FgvaK3VaOXMKGdfZwHH2KLfA@mail.gmail.com>
Subject: Re: Any method to 'umount' a subvolume?
To: Queen Adam <adam900710@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's because the test shouldn't be in your root in the first place.
The common way of thinking now is to create a btrfs volume with a
structure for holding subvolumes inside of which your system root is a
member. You then mount the system root via -o subvol= and will only
see it and nothing else. If you want access to the "control" structure
you mount that without -o subvol. If you want to mount another
subvolume (even in place of your root) you mount that with -o subvol
to whereever you want.

Examples:
real btrfs root:
/root/default
/root/snap1
/root/snap2
/home/default
/home/snap1

The system root mounts /root/default on boot via -o
subvol=root/default as well as the /home/default subvolume for /home.

Then if you want to make a snapshot you mount btrfs to something like
/mnt/ctrl and do 'btrfs sub snap / /mnt/ctrl/root/snap3' and umount
/mnt/ctrl again.

Rolling back a snapshot is as easy as mounting /mnt/ctrl and doing 'mv
/mnt/ctrl/root/default /mnt/ctrl/root/default-old && mv
/mnt/ctrl/root/snap3 /mnt/ctrl/root/default' followed by a reboot. No
changes are necessary to your boot system and on the next boot you are
rolled back and can delete the default-old subvol if you desire.

On Thu, Mar 14, 2013 at 5:24 AM, Queen Adam <adam900710@gmail.com> wrote:
> Hi all,
>
> When using "btrfs sub create test" commands to create a subvolume, it
> will create test directory in the current directory.
>
> But the subvol directory can only be delete by "btrfs sub delete"
> command, which seems also delete all the data in the subvolume.
>
> Any method about the 'umount'-like method to 'umount' the subvolume
> and delete the subvolume directory without deleting all the data?
> The method now seems less flexible (can mount -o subvol=test to other
> path but the test/ can't be deleted)
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
