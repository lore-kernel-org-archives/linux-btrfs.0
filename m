Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35798 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbcA0VB0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 16:01:26 -0500
Received: by mail-qg0-f54.google.com with SMTP id o11so17759961qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 13:01:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A8EF4F.7060900@netcologne.de>
References: <56A8EF4F.7060900@netcologne.de>
From: bbrendon@gmail.com
Date: Wed, 27 Jan 2016 13:00:45 -0800
Message-ID: <CADrfcda=ZGF35kR5_Ho9VacMbSbFwDTnT-s1hJcLf4AZNGaCbg@mail.gmail.com>
Subject: Re: Progress indicator when (slowly) mounting a btrfs filesystem?
To: Christian Rohmann <crohmann@netcologne.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my experience there are cases where the system does nothing and it
just appears to hang but leaving it overnight results in success.

Very strange indeed.

On Wed, Jan 27, 2016 at 8:24 AM, Christian Rohmann
<crohmann@netcologne.de> wrote:
> Hey btrfs-folks,
>
> when one cuts the power to a machine with an 8 device RAID6 btrfs
> mounted, it takes about 15 - 20 minutes to mount the btrfs again
> afterwards. This is with kernel 4.4 and btrfs-progs 4.4 mind you. I
> looked at iotop and it was reading from all disks heavily, so it was
> doing something. The long mount time for such a rather expected case
> might be a problem in itself, but either way, a mount action that takes
> a while needs to present some sort of progress indication, so the user
> knows what btrfs is at work getting things mounted.
>
>
>
> Regards
>
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
