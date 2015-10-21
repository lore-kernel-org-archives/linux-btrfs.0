Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:32988 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbJUQoQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 12:44:16 -0400
Received: by iodv82 with SMTP id v82so63567979iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 09:44:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
	<CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
Date: Wed, 21 Oct 2015 09:44:16 -0700
Message-ID: <CAN05THSFBPxhbtMYqGzC1AjNKuxh6La2PbS6p4WvRX61cbqbqQ@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If it is for mostly archival storage, I would suggest you take a look
at snapraid.


On Wed, Oct 21, 2015 at 9:09 AM, Janos Toth F. <toth.f.janos@gmail.com> wrote:
> I went through all the recovery options I could find (starting from
> read-only to "extraordinarily dangerous"). Nothing seemed to work.
>
> A Windows based proprietary recovery software (ReclaiMe) could scratch
> the surface but only that (it showed me the whole original folder
> structure after a few minutes of scanning and the "preview" of some
> some plaintext files was promising but most of the bigger files seemed
> to be broken).
>
> I used this as a bulk storage for backups and all the things I didn't
> care to keep in more than one copies but that includes my
> "scratchpad", so I cared enough to use RAID5 mode and to try restoring
> some things.
>
> Any last ideas before I "ata secure erase" and sell/repurpose the disks?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
