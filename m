Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32794 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbbJUQJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 12:09:13 -0400
Received: by wijp11 with SMTP id p11so102531260wij.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 09:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
Date: Wed, 21 Oct 2015 18:09:12 +0200
Message-ID: <CANznX5FS+sT3Pay+iLdA5TmP6NX-di3fm0K_yCHs4sac_OhndA@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I went through all the recovery options I could find (starting from
read-only to "extraordinarily dangerous"). Nothing seemed to work.

A Windows based proprietary recovery software (ReclaiMe) could scratch
the surface but only that (it showed me the whole original folder
structure after a few minutes of scanning and the "preview" of some
some plaintext files was promising but most of the bigger files seemed
to be broken).

I used this as a bulk storage for backups and all the things I didn't
care to keep in more than one copies but that includes my
"scratchpad", so I cared enough to use RAID5 mode and to try restoring
some things.

Any last ideas before I "ata secure erase" and sell/repurpose the disks?
