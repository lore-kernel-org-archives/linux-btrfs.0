Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63047 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3HDNho (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 09:37:44 -0400
Received: by mail-qc0-f178.google.com with SMTP id s1so1174678qcw.23
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 06:37:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201308042142.12310.russell@coker.com.au>
References: <201308042142.12310.russell@coker.com.au>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sun, 4 Aug 2013 15:37:22 +0200
Message-ID: <CAGy7UtjvPHbC0zSvXNAV+LYAr=QX-ePXKCXCx-VKTDD2O9fLMw@mail.gmail.com>
Subject: Re: error count
To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Russell,

a sufficiently up-to-date kernel and btrfs tool will provide the
'btrfs device stats' command, which should give you the info you want.

Regards,

Bart


On Sun, Aug 4, 2013 at 1:42 PM, Russell Coker <russell@coker.com.au> wrote:
> I've got a 3TB SATA disk that is known to have problems (it failed in a zpool
> for one of my clients).  For test purposes I'm running a BTRFS RAID-1 on two
> partitions on that disk, bad for performance and not something you'd normally
> do but good for testing.
>
> BTRFS recovers from read errors quite well and gives informative log messages.
>
> But it doesn't seem possible to get a count of the number of errors.  I think
> that at the minimum I should be able to get a count of the number of errors
> from a device since it was attached to the system.  I think that the ideal
> would be to have an error count stored on the device and available to the
> sysadmin.
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
