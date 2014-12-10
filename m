Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:64800 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaLJO4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 09:56:04 -0500
Received: by mail-yh0-f46.google.com with SMTP id t59so1333731yho.19
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 06:56:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWWdAnWu30-cYGZLTu6EgGR9wnGQBHGv+UDtHigR5dQieA@mail.gmail.com>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<CAH-HCWWdAnWu30-cYGZLTu6EgGR9wnGQBHGv+UDtHigR5dQieA@mail.gmail.com>
Date: Wed, 10 Dec 2014 22:56:02 +0800
Message-ID: <CA+qeAOpdf8L1hzKr5jUFizy7RyEXnFUabew=K_0mEYPTR=yEOQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 10, 2014 at 9:59 PM, Shriramana Sharma <samjnaa@gmail.com> wrote:
> On Tue, Dec 9, 2014 at 4:50 PM, Dongsheng Yang
> <yangds.fnst@cn.fujitsu.com> wrote:
>>         # df -h /mnt
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>
> LOL -- not being a user of RAID I can't comment on the patch, but I
> was somewhat wondering what the "fd" command in the subject line is...
> :-)

Yea, it should be "df". :)
>
> --
> Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
