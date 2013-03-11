Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:47166 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWtm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:49:42 -0400
Received: by mail-la0-f53.google.com with SMTP id fr10so4469627lab.40
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
References: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 11 Mar 2013 23:49:19 +0100
Message-ID: <CAFWF=amr90tjbkd7H5_a4dC-UxrhEVhirmisZTLzViYqWO2T3w@mail.gmail.com>
Subject: Re: Unable to boot btrfs filesystem, and btrfsck aborts
To: Matthew Booth <matthew@heisenbug.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:44 PM, Matthew Booth <matthew@heisenbug.com> wrote:
> My laptop crashed hard earlier today. It reset immediately to a black
> screen followed by the BIOS. I have no idea why.
>
> However, it now fails to boot. I took a picture of the kernel panic
> that results from trying to mount the root filesystem:
> https://plus.google.com/107763699965053810188/posts/QZZt7GYzBZi
>
> To make things worse, btrfsck aborts with a double free, without
> fixing it. I took a picture of that, too:
> https://plus.google.com/107763699965053810188/posts/gKYqGgFhWyT
>
> As the kernel panic mentions btrfs_remove_free_space, I also tried
> mounting with clear_cache. Unfortunately it didn't dislodge anything.
>
> This is on a fully updated Fedora 18 system. I would really like to
> get this data back. If anybody could offer a suggestion I'd be very
> grateful.
>
> Thanks,
>
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

If you can make a complete image backup of the drive before trying any
things to bring it back.
Try mounting with -o nospace_cache, also try -o ro and -o recovery as
well as -o recovery,ro.

If you can bringt it back in ro mode you can at least copy your data
out of it if all else fails...

I'm not a dev, just a random guy having an interest in btrfs, so if
you don't have a backup and aren't able to create a dd copy of it
right now you might wanna wait for a reply of someone who actually
knows the code...

Good luck
