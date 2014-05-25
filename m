Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:51238 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYCBC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 22:01:02 -0400
Received: by mail-la0-f53.google.com with SMTP id ty20so3475192lab.40
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 19:01:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <538002C9.8080503@pobox.com>
References: <538002C9.8080503@pobox.com>
Date: Sun, 25 May 2014 03:01:00 +0100
Message-ID: <CAL3q7H7kq73rXdDCdbTVig9WFMXxpWVra24B4DsGJbS2aQc_0g@mail.gmail.com>
Subject: Re: BUG: Replacing a directory with a subvolume breaks incremental snapshots
From: Filipe David Manana <fdmanana@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 24, 2014 at 3:24 AM, Robert White <rwhite@pobox.com> wrote:
> Howdy,
>
> If you remove an existing directory and then create a subvolume with the
> same name the incremental send (btrfs send -p) will die with errno==2 (file
> not found).
>
> Steps to Reproduce:
>
> btrfs subvol create scratch # make a playground
> mkdir scratch/example
> btrfs subvol snap -r scratch scratch_BEFORE
> rmdir scratch/example
> btrfs subvol create scratch/example
> btrfs subvol snap -r scratch scratch_AFTER
> btrfs send -p scratch_BEFORE scratch_AFTER >/dev/null
>
> The output produced:
> At subvol scratch_AFTER
> ERROR: send ioctl failed with -2: No such file or directory

Fixed here:  https://patchwork.kernel.org/patch/4238131/

Thanks Robert.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
