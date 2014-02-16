Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56654 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaBPUco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 15:32:44 -0500
Received: by mail-ve0-f181.google.com with SMTP id cz12so11192677veb.40
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 12:32:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <11335246.MGjIN0NiaF@linuxpc>
References: <11335246.MGjIN0NiaF@linuxpc>
Date: Sun, 16 Feb 2014 20:32:43 +0000
Message-ID: <CALOYprUfUvDiODcM1Hcen9tQVACmZid2ymZXdjuxd09QDyQirA@mail.gmail.com>
Subject: Re: BTRFS send: exclude directories
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 February 2014 20:07, GEO <1g2e3o4@gmail.com> wrote:
> Hi,
>
> I have been experimenting with btrfs send/receive for incremental backups, but
> could not figure out how to exclude certain directories from
> subvolumes/snapshots. For example, I want to backup my data in home, but I am
> not interested in backing up hidden directories like .cache too.
> Is it currently possible to achieve something like that?
>
> Thanks for the great work!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

You could create a read-write snapshot, remove the directories that
you're not interested in, then create a read-only snapshot of that to
send, then remove the read-write snapshot.

Note that I've not tested this myself, so I can't guarantee that it
will work. (It makes sense in my head though!)

Cheers,


WorMzy

(apologies if you receive this twice, I just noticed that gmail
doesn't reply to this mailing list, it replies to the person directly)
