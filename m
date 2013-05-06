Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:60167 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3EFOfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 10:35:42 -0400
Received: by mail-vc0-f169.google.com with SMTP id gd11so3073182vcb.14
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 07:35:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <lj3k5a-6dh.ln1@hurikhan.ath.cx>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx>
	<51874A85.1050608@jan-o-sch.net>
	<lj3k5a-6dh.ln1@hurikhan.ath.cx>
Date: Mon, 6 May 2013 07:35:41 -0700
Message-ID: <CAPkEcwgAH=w7q5JdsJB+YLxDgysOwTUg7boyZFMmfB1v3fmwCw@mail.gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient backups
From: james northrup <northrup.james@gmail.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tried a git based backup? sounds spot-on as a compromise prior to
applying btrfs tweaks.  snapshotting the git binaries would have the
dedupe characteristics.

On Mon, May 6, 2013 at 12:44 AM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:
>
>>> I'm using an bash/rsync script[1] to backup my whole system on a nightly
>>> basis to an attached USB3 drive into a scratch area, then take a snapshot
>>> of this area. I'd like to have these snapshots immutable, so they should
>>> be read-only.
>>
>> Have you considered using btrfs send / receive for that purpose? You would
>> just save the dedup step.
>
> This is planned for later. In the first step I want to stay as file system
> agnostic for the source as possible. But I've put it on my todo list in the
> gist.
>
> Regards,
> Kai
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
