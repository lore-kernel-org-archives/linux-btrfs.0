Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:35094 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbeHLFxM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 01:53:12 -0400
Received: by mail-lj1-f170.google.com with SMTP id p10-v6so10048047ljg.2
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Aug 2018 20:16:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$37ed4$1f39572a$7dd0a77a$b6954c8@cox.net>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com> <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com> <CAJCQCtQS+yiSQ4Cu-F_Spi5_6fEw_FuGdXCafJLxBe1swacabQ@mail.gmail.com>
 <pan$37ed4$1f39572a$7dd0a77a$b6954c8@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 11 Aug 2018 21:16:46 -0600
Message-ID: <CAJCQCtR9mYzFSHheyjK6sSf-KKeXtibArw9UcpH9Bh-ptXTVcg@mail.gmail.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with quota
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 9:29 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Fri, 10 Aug 2018 12:07:34 -0600 as excerpted:
>
>> But whether data is shared or exclusive seems potentially ephemeral, and
>> not something a sysadmin should even be able to anticipate let alone
>> individual users.
>
> Define "user(s)".

The person who is saving their document on a network share, and
they've never heard of Btrfs.


> Arguably, in the context of btrfs tool usage, "user" /is/ the admin,

I'm not talking about btrfs tools. I'm talking about rational,
predictable behavior of a shared folder.

If I try to drop a 1GiB file into my share and I'm denied, not enough
free space, and behind the scenes it's because of a quota limit, I
expect I can delete *any* file(s) amounting to create 1GiB free space
and then I'll be able to drop that file successfully without error.

But if I'm unwittingly deleting shared files, my quota usage won't go
down, and I still can't save my file. So now I somehow need a secret
incantation to discover only my exclusive files and delete enough of
them in order to save this 1GiB file. It's weird, it's unexpected, I
think it's a use case failure. Maybe Btrfs quotas isn't meant to work
with samba or NFS shares. *shrug*



>
> "Regular users" as you use the term, that is the non-admins who just need
> to know how close they are to running out of their allotted storage
> resources, shouldn't really need to care about btrfs tool usage in the
> first place, and btrfs commands in general, including btrfs quota related
> commands, really aren't targeted at them, and aren't designed to report
> the type of information they are likely to find useful.  Other tools will
> be more appropriate.

I'm not talking about any btrfs commands or even the term quota for
regular users. I'm talking about saving a file, being denied, and how
does the user figure out how to free up space?

Anyway, it's a hypothetical scenario. While I have Samba running on a
Btrfs volume with various shares as subvolumes, I don't have quotas
enabled.



-- 
Chris Murphy
