Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay02.libero.it ([212.52.84.102]:56918 "EHLO
	outrelay02.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3KHMzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 07:55:11 -0500
Message-ID: <29341211.3154771383915306434.JavaMail.defaultUser@defaultHost>
Date: Fri, 8 Nov 2013 13:55:06 +0100 (CET)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <lists@colorremedies.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: R: Re: Question about btrfs as root filesystem
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>

>On Nov 7, 2013, at 4:45 PM, Michael Göhler <visit@myjm.de> wrote:
>>  The boot subvolume is then set with 'btrfs subvolume set-default' and 
mounted without subvol/subvolid option by Arch's default mount handler.
>
>I'm unconvinced it's a good idea for it to be used behind the scenes 
> for the described purpose. Consider the following:
>
>1. btrfs subvolume set-default uses a user space tool and in
> my view it's primarily a user domain behavior modifier for the mount 
command.
>
>2. It makes the actual mounted subvolume obscured, cat /proc/self/mountinfo 
> doesn't show what subvolume is mounted unless subvol= is explicitly used in 
/etc/fstab.
>
>3. Grub2 (and I'm pretty sure grubby) do not use the set-default. The GRUB 
> intent for the prefix to search an absolute path, not one relative to the
> default subvolume. There's a bug that should very recently (week) be fixed, 
> where GRUB fails to find prefix if set-default is changed. This maybe isn't 
> affecting the particular layout you describe where only rootfs is on btrfs, 
> rather than /boot being on its own subvolume.
>

Instead of using set-default, I am used to rename the subvolume.
I.E. I assume that the root filesystem is a subvolume always called 
"__active". 
When I want to rollback, I rename "__active" in "__broken" (or 
remove it), then I rename (or re-snapshot) "snapshot-yyyymmdd" 
in "__active".

>> That way, we ensure the best compatibility and lowest maintenance, 
> as we don't overwrite default init functions.
>
>I'm sympathetic to the alternative problem, which is that you need to 
> alter grub.cfg to use the proper rootflags=subvol= to explicitly use the 
> proper snapshot, and also it would mean altering the /etc/fstab within 
> that snapshot.

With rename you can address both the issues

>> 
>> Now, if we snapshots the root subvolume, the child subvolumes are 
>> not snapshoted with it. There is no back reference which would 
>> allow Btrfs to auto-mount the original child subvolumes when we 
>> mount the snapshot as new root filesystem. Of cause we could 
>> snapshot the childs separately into their desired directories. But 
>> this would not help, because our hook snapshots the snapshot again, 
>> to keep it's original untouched while rolling back. 
>> And we don't have fstab to find out the correct mount points at this early 
boot stage.
>
>The fact of the matter is, we don't have the necessary metadata support in 
> btrfs to understand the relationships between snapshots/subvolumes. 
> There is a need for this, not least of which is the use case you're 
> describing. This has come up with Fedora also for their offline 
> updates rollback they want to eventually do. And it's also an issue 
> with distribution installers which see these snapshots as wholly 
> unique instances of existing installations, rather than as related 
snapshots.
>
>
>> 
>> Atm. all scenarios results in /usr/bin/init not found.
>> 
>> So here comes my question:
>> Wouldn't it be helpful to add a --recursive option to 'btrfs subvolume 
>> snapshot' to snapshot child subvolumes together with their parent?
>> Or maybe it is possible to add some functionality to reference the 
>> child subvolumes on the snapshots fs-tree to allow auto-mounting?
>
> Well and it raises the problem of nested subvolumes making the parent  
> subvolume undeletable. So I'd question the significant benefit of 
> making nested subvolume in particular /var. It's complicating 
> how the OS is to be put back together again.

IIRC the problem of removing a subvolume with a child subvolume, 
already exists. IMHO the "btrfs sub snapshot"  --recursive option 
could have some valid uses cases. Of course we should add the 
"btrfs sub delete" --recursive option also.

BTW I agree with Chris that partition the filesystem in too much 
subvolume is a mess from a managemente POV. May be
adding an option to "ls" to highlight the subvolumes could
alleviate the problem ?

G.Baroncelli
>
>
>Chris Murphy--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
