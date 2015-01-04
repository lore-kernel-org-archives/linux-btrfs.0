Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:59912 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADIpm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 03:45:42 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so9761657yha.4
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 00:45:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fab96edbc48bf3f26781ab76dda6f182@pl1.haspere.com>
References: <fab96edbc48bf3f26781ab76dda6f182@pl1.haspere.com>
Date: Sun, 4 Jan 2015 01:45:41 -0700
Message-ID: <CAJCQCtRYW_S8CDZQH_95RGtsTBHN3gftd9WgsScA7_oCpFYgOg@mail.gmail.com>
Subject: Re: ignoring bad blocks
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 3, 2015 at 10:40 PM, Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com> wrote:
> Hi All,
>
> Can BTRFS ignore bad blocks as they are discovered?
>
> I want to try BTRFS on some older drives, but they all have a few bad
> blocks.

Not currently, and I don't see it in the project ideas list. Right now
on Btrfs you will just get write errors, but I'm uncertain if it just
tries a new sector and continues on (indirectly not use the bad sector
but also not keeping track of it either)? The unreliable disk features
are still project ideas.

If the drives no longer have reserve sectors, then technically they're
toast. That's indicated by write failure in dmesg. Two work arounds:
use ext4 with mkfs.ext4 -c which builds a bad blocks list and then
won't use those sectors; mdadm 3.1+ has an option to build a bad
blocks list also but I don't know if raid0 or linear/concat are
supported:
http://thread.gmane.org/gmane.linux.raid/34883

If you haven't tried it, badblocks -wvs will (destructively) write
over the entire block device, and the drive firmware should detect
persistent write failures automatically and remap the LBA to a reserve
sector, removing the bad sector from use. This is transparent to
everything outside the drive. Once reserve sectors are depleted then
the drive will report write failure.



-- 
Chris Murphy
