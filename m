Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33292 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcAGTQ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 14:16:57 -0500
Received: by mail-io0-f179.google.com with SMTP id q21so262457799iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jan 2016 11:16:57 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <568EB86F.7070800@gmail.com>
References: <568EB86F.7070800@gmail.com>
Date: Thu, 7 Jan 2016 19:16:56 +0000
Message-ID: <CAL3q7H5VsDHfwwnoHc9_N9cg1KrtFro6gW59-XRoPj_orUyKVw@mail.gmail.com>
Subject: Re: btrfs trim erases bootloader area
From: Filipe Manana <fdmanana@gmail.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 7, 2016 at 7:11 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> As discussed on opensuse-factory list, running fstrim on btrfs erases
> bootloader area, rendering system unbootable. See
>
> https://lists.opensuse.org/opensuse-factory/2016-01/msg00067.html
> https://lists.opensuse.org/opensuse-factory/2016-01/msg00090.html
>
> and follow-ups that demonstrate that beginning of device gets zeroed out.
>
> Not sure what we can do, but from GRUB side I can only see disabling
> embedding support on btrfs entirely.

Try this (sent to the btrfs mailing list yesterday):

http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/commit/?h=integration-4.5&id=7b6cb6618b45bb383f9336ec89df5f1f31f9935b

thanks

>
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
