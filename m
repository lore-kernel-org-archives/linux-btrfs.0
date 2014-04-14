Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35599 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDNTab (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 15:30:31 -0400
Received: by mail-oa0-f54.google.com with SMTP id n16so9781443oag.13
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 12:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <534C3390.10402@fb.com>
References: <CADVynFCg4KWN9AGNKXAjoamwoLfNO4Q5czv+UCdEhqXWrG8P8A@mail.gmail.com>
 <534C2D95.4090103@fb.com> <534C3390.10402@fb.com>
From: Shaun Reich <sreich@kde.org>
Date: Mon, 14 Apr 2014 15:29:50 -0400
Message-ID: <CADVynFA+LXCqBncoe0SP6h70a57=adpvGQWzWqdAsx+J5j1grA@mail.gmail.com>
Subject: Re: sub del: directory not empty, even though it is
Cc: Shaun Reich <sreich@kde.org>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Ok, latest kernels include this commit:
>
> commit 72de6b5393c15c5228074008bbdc47e92bf6d4f7
> Author: Guangyu Sun <guangyu.sun@oracle.com>
> Date:   Tue Mar 11 11:24:18 2014 -0700
>
>     Btrfs: return EPERM when deleting a default subvolume
>
>     The error message is confusing:
>
>      # btrfs sub delete /mnt/mysub/
>      Delete subvolume '/mnt/mysub'
>      ERROR: cannot delete '/mnt/mysub' - Directory not empty
>
>     The error message does not make sense to me: It's not about deleting a
>     directory but it's a subvolume, and it doesn't matter if the subvolume is
>     empty or not.
>
>     Maybe EPERM or is more appropriate in this case, combined with an explanatory
>     kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
>     it is configured as default subvolume.")
>
>     Reported-by: Koen De Wit <koen.de.wit@oracle.com>
>     Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
>     Reviewed-by: David Sterba <dsterba@suse.cz>
>     Signed-off-by: Chris Mason <clm@fb.com>
>
> And your btrfs-debug-tree output confirms you're trying to delete the
> default subvolume.
>
> Pick a new default and it will all work ;)

yep, and that was (embarrassingly) it. set the default to 5, so i can
remove my use of subvolumes altogether and redo them properly. and the
delete of course succeeds now.

thanks

-- 
Shaun Reich,
KDE Software Developer (kde.org)
