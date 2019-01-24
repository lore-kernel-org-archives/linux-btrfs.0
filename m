Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433E2C282C3
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 17:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F23812184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 17:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="i9Hqekk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfAXRXN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 12:23:13 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43120 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbfAXRXN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 12:23:13 -0500
Received: by mail-lf1-f65.google.com with SMTP id u18so4887526lff.10
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 09:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MjnGUWDIdvmsgUukzAgeBf+yTJwbwL3BbKEiQ6OP58=;
        b=i9Hqekk4YmXvnFeNX+sVvyGNsXeJwKPGzVSiEFKNlXrlwITxZoa2q+b+G5278xu6p6
         1Kwzv+7YnLbuVPVXwflPkH/naSZP19UN/D0OvHhmBlO+hsqu1Yj5obK57turY2XKDQtF
         oe9dAIdsLpkRIz+ir03jyHbNG9OOk4iyYFzBG04ohXgZDfgTNryzrPh1NAfi0zrv2C0w
         pyvsUmfmwxkvEDmoJXJyNaWtHHu3BTCnUoYau+iObIBd3gepou9WDmHWi8aIkGt8R/NP
         e3Ls4D8sgFBQN3eBH/QlPFkx+QbD84B7vTR3gqrfToLIDsMCUaD4tUXbJXlTH6c1hLYy
         Cbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MjnGUWDIdvmsgUukzAgeBf+yTJwbwL3BbKEiQ6OP58=;
        b=Qsd82f8Z/CwkcrkkyIwoSuqq6k/Pb+f58+dLj5PSlGSs3iSrg2GFC61x0HIwittlWB
         S8TUxI30RsTpFYuzr9PPL5QaKlBuOZPrh/FLoG1mXoMzq7KXINzFl8BcTevyYgUT5puj
         6wE6I7rvcKVISv4WKMR100DVySj/ekWkZkT6Wd9XJC0YGiCDeUtx1aJop/g79iDeW93a
         OzOIQJhfwJ4g1z5UviPn+SWKdPf6QU0TypepHrGn1wGgPd9agOOKJqhQZlR0X2tIMoD0
         LAjX77mhgLnLHcRmGj5vKFCIYstJiHALW3MdlvKe1PwYxrJFEuvD+gChYWe4HyiC5mn8
         47ug==
X-Gm-Message-State: AJcUukd7JQ0YlTE+9PtRqZLETjZ5lUxTLece3NCTFJL5JHWyYXDEP4CA
        6dElmj2l7kEpSM0paJkX2CGC/rXqjgZrGdYuh9csjw==
X-Google-Smtp-Source: ALg8bN4p6N/w4x+I9bdYiaRB+rMuT8E0s2upNoT885F5dgkf8h6QRKM8wu+WojyfkMpJcmrk/X0cMTIBofK3/P1Ib/k=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr5809670lfh.74.1548350590522;
 Thu, 24 Jan 2019 09:23:10 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au> <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com> <f191c52b-740f-f432-1307-dbb8f4010f66@suse.com>
 <f2d23645-ebd4-3799-bad8-2050764375bc@mendix.com> <d44d7535-7590-662e-ddd0-e095cb5156a4@netspace.net.au>
In-Reply-To: <d44d7535-7590-662e-ddd0-e095cb5156a4@netspace.net.au>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 24 Jan 2019 10:22:58 -0700
Message-ID: <CAJCQCtRMTADq09y=+Bu6OvsDvyzUw6iZLRUKYhQ6di5B7zRmEQ@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Dennis K <dennisk@netspace.net.au>
Cc:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 24, 2019 at 3:40 AM Dennis K <dennisk@netspace.net.au> wrote:
>
> The fact is, this thread is the first time I've seen explicitly written
> that parents must be the same at receiving and sending ends, or else
> btrfs-send/receive will produce a subvolume which differs from the source.

The central user error, as well as btrfs-progs bug is the failure to
meet the requirement that the source(s) be snapshots. Either a full
send, or an incremental send, whether with -p or -c, all of them must
be snapshots. And none of yours were snapshots. They were read-only
subvolumes made using 'btrfs property' to set the read-only flag, and
those are not snapshots.

The btrfs send command should have explicitly failed on that alone.

In my reproducer of a related user error and bug, both were snapshots,
but they were unrelated snapshots, therefore incremental send was
impossible, and the only explanation for such a command is the user is
confused, made a mistake, and therefore the command should have
failed.

>
> A user could from the descriptions of how send/receive formats its data
> strea, and from interpreting "clone sources" in a manner contrary to how
> its used in the man page and the mention of incrementals, conclude that
> send/receive is sensitive to changes at the receiving side, but its far,
> far more likely that they will start using feature like send/receive and
> setting snapshots to ro before they delve into how it works its magic.

Uhhh I think this is a specious statement if you think users are
likely to delve into 'btrfs property' and somehow think setting a
subvolume ro is making a snapshot. You're the first I've encountered
who arrived at this logic. For now almost a decade people arrive at
'btrfs subvolume snapshot' as the way to make snapshots, and the -r
flag to make them read-only snapshots.

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Snapshots

That page only describes snapshots in terms of the 'btrfs subvolume
snapshot' command - the 'btrfs property' command isn't found anywhere
on that page. So I don't actually know how you came to think setting
the ro property on a subvolume to true, makes the subvolume a
snapshot. I think you did it through assumption. And while there might
be a way to fix some things to avoid such confusion in the future, I
do think it's an edge case.


The man 8 btrfs man page could amend:

       subvolume
           Create/delete/list/manage btrfs subvolume.

to

       subvolume
           Create/delete/list/manage btrfs subvolumes and snapshots.

it is something of btrfs geekdom that snapshots are subvolumes; but
still not all subvolumes are snapshots. So...yeah, clarity is a good
thing even if there some redundancy.

> Anyway, rsync sends incremental change, and its ability to replicate a
> directory tree isn't predicated on the files present at the receiving
> end being the same as the last time it was run...

What? Yes it is. By default it compares size and time stamp on both
sides. If you use -c it uses checksums to compare. From the rsync man
page:

>Rsync finds files that need to be transferred using a "quick check" algorithm (by default) that looks for files that have changed in  size  or  in  last-modified
       time.

Rsync does not keep a database on source or destination. It absolutely
is comparing both sides, and if they aren't the same, the file is
synced from the source to the destination.

Also, the man page for btrfs receive very clearly says the receive
side snapshot must be present and must not have been changed since the
last receive, or it will fail.

>       btrfs receive will fail in the following cases:
>       1. receiving subvolume already exists
>       2. previously received subvolume has been changed after it was received

I'm still really not following where your confusion stems from, and
therefore I'm not sure what needs fixing other than the items I've
already mentioned - which itself at least would have stopped you in
your tracks, to go dig deeper or ask questions before arriving at the
understandably confusing results you were getting.

-- 
Chris Murphy
