Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50282 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKW53 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:57:29 -0400
Received: by mail-lb0-f170.google.com with SMTP id ge1so3596163lbb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0fHk3VQRS4GV6=1_fe3PfHnPT=eOpZi2hO7=d_tVYLnvA@mail.gmail.com>
References: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
 <CAFWF=amr90tjbkd7H5_a4dC-UxrhEVhirmisZTLzViYqWO2T3w@mail.gmail.com> <CAMQ-g0fHk3VQRS4GV6=1_fe3PfHnPT=eOpZi2hO7=d_tVYLnvA@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 11 Mar 2013 23:57:07 +0100
Message-ID: <CAFWF=amgZerPCKd3cEhNu-mY7SmhdG5g7bU-Y_Q7=8FGZ1Zz5Q@mail.gmail.com>
Subject: Re: Unable to boot btrfs filesystem, and btrfsck aborts
To: Matthew Booth <matthew@heisenbug.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you are going to use btrfs-zero-log please create a btrfs-image
first that you can then upload to a bug report so that this can be
fixed.

# btrfs-image -c 9 -t 8 /dev/yourbtrfs /tmp/fs_image

On Mon, Mar 11, 2013 at 11:53 PM, Jan Steffens <jan.steffens@gmail.com> wrote:
> On Mon, Mar 11, 2013 at 11:49 PM, Harald Glatt <mail@hachre.de> wrote:
>> On Mon, Mar 11, 2013 at 11:44 PM, Matthew Booth <matthew@heisenbug.com> wrote:
>>> My laptop crashed hard earlier today. It reset immediately to a black
>>> screen followed by the BIOS. I have no idea why.
>>>
>>> However, it now fails to boot. I took a picture of the kernel panic
>>> that results from trying to mount the root filesystem:
>>> https://plus.google.com/107763699965053810188/posts/QZZt7GYzBZi
>>>
>>> To make things worse, btrfsck aborts with a double free, without
>>> fixing it. I took a picture of that, too:
>>> https://plus.google.com/107763699965053810188/posts/gKYqGgFhWyT
>>>
>>> As the kernel panic mentions btrfs_remove_free_space, I also tried
>>> mounting with clear_cache. Unfortunately it didn't dislodge anything.
>>>
>>> This is on a fully updated Fedora 18 system. I would really like to
>>> get this data back. If anybody could offer a suggestion I'd be very
>>> grateful.
>> If you can make a complete image backup of the drive before trying any
>> things to bring it back.
>> Try mounting with -o nospace_cache, also try -o ro and -o recovery as
>> well as -o recovery,ro.
>
> I think the bug happens during log recovery, so btrfs-zero-log might
> get it mountable again, with the caveat of losing the most recently
> fsynced changes.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
