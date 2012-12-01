Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43729 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2LATAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2012 14:00:48 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so2343337ieb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2012 11:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
References: <CAFhuFEdxHxdiAutfxxsQ9i0OJj_CfRwWD-0LuhvoJYGHkTsG4A@mail.gmail.com>
Date: Sat, 1 Dec 2012 21:00:48 +0200
Message-ID: <CAOcd+r1LnMP=CU37mUSxZGuksTY4kYo+Y5vg9n3BV-E=ye=-Yg@mail.gmail.com>
Subject: Re: Snapper snapshot comparison algorithm
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: nafisa mandliwala <nafisa.mandliwala@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi nafisa,
in order to understand how btrfs send code compares two btrfs file
trees, you may read this:
http://www.spinics.net/lists/linux-btrfs/msg17731.html (where I am
trying to understand it) and further down the thread. It's a very nice
algorithm, actually.

Thanks,
Alex.



On Sat, Dec 1, 2012 at 9:54 AM, nafisa mandliwala
<nafisa.mandliwala@gmail.com> wrote:
> I needed help with understanding the snapshot comparison algorithm
> that snapper uses and its shortcomings. From reading the code, what I
> understood is that it does a block by block compare. I'm not very sure
> if that's the best way to go about it. Also, since the send receive
> code is still in development stages, is there a scope to add more
> functionality to it?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
