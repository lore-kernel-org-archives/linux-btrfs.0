Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42982 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbAVKMc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 05:12:32 -0500
Received: by mail-lb0-f181.google.com with SMTP id u10so639108lbd.12
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 02:12:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <54C0CAFB.4020708@oracle.com>
References: <54C0CAFB.4020708@oracle.com>
Date: Thu, 22 Jan 2015 10:12:30 +0000
Message-ID: <CAL3q7H59s0d9EwMzSRUc59r6W3zOJNm=wUzYxNcaL3ZCi4kUyA@mail.gmail.com>
Subject: Re: replace seed/sprout hangs (regression ?)
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 22, 2015 at 10:03 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>  The following test case hangs as of now, but as I remember Fujitsu
>  had sent a patch to fix this, a long time back. Can't find now,
>  any idea. ?
>
>  Test case:
>    add a spout device
>    replace seed / sprout device
>
>  hangs at:
>   (btrfs_reada_wait+0x4d/0xb0)

No idea when it happened.
But perhaps, it's a good time to start having an xfstest for it? :)

thanks

>
> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
