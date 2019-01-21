Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FCAC3713C
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 22:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C4FD20870
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 22:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="O7tkZYQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfAUWbc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 17:31:32 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:33813 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfAUWbc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 17:31:32 -0500
Received: by mail-lf1-f54.google.com with SMTP id p6so16672445lfc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 14:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJ0AoWhW3vv7f+JJOwNcCGJZicuEfAccAcBK3NMAxow=;
        b=O7tkZYQf2vBgujs+1EEGta8rGdkN9tQiqWy74qdPH8L3yfeTVOHHyEJ4a7oSN221pF
         7wi9nlA2fCzLFfKLwo6CaHBCRXDWfgpmMi1Q827PjYUnTXGFCnbIBIaGeCA+vtRaTI6d
         F2wI1SYg3fRvZQJaqrxVehadWoTWVfjbRiLM2aGOK4JsbnOBEhB9zXf6cjLHZAwCDIxm
         RmA8r3bPRPgvrkFC74e896jVbFaKiFN/B0iY32d6RlxU4TcWf0SeIhtoBlIELynYPBPt
         FWQkLYcqkLiO4LKNCdhKfIiSPbIh4KvlW4PqYcVv0upZvbKkBOwVgJJIX5WJAkMI0Lg0
         SVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJ0AoWhW3vv7f+JJOwNcCGJZicuEfAccAcBK3NMAxow=;
        b=f3Ga1OCo0YuDk+N2wl+FHhB7lTbJztbGjmmv+xUgJhc9uxMG8oq/4oF+giAlKo2cHV
         8Sn4gyKVqH0VF0lDwlfW20lwErftCmhTKV3r9VR1ZtoGh/RFdfOh63P7LZhi3ghh1srT
         HvrkoAVGuy+9JmM7wZKDcg6HNn0M+JHzriLIwwFuATc+CGZNS9nT7HfyBXk7hginicOI
         qTkd9HhH8faXtzt5TUweQwp/G6OxhUM9HUu7uQV9UVi3ShmR6OU0QLzY+ZYd/Y0kzjXi
         a1NUPjZ5AQDEI6ccXJ7OGwxD+z7LXY8A43dj9LiBQEobqTpaa1IjPuHyAVxs2ve8G8Xk
         G3Vw==
X-Gm-Message-State: AJcUukdFxmEvluncFhyAqxjLAZm+I8w7x1DQnyejUl0VXH7PpNJFmmbt
        jcBV9+viOtiiGl/ivUCeK3Fgkc3AWep+mGMoy68v9Q==
X-Google-Smtp-Source: ALg8bN6T8OECEoMX2OIhiDvKG9WKkVeGl6IioRhip8L1zWQZSfOZIlbctCinnZ48tww/EWh52itACD6Xq9RLdQm2GNQ=
X-Received: by 2002:a19:5601:: with SMTP id k1mr17425726lfb.99.1548109395924;
 Mon, 21 Jan 2019 14:23:15 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
In-Reply-To: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 21 Jan 2019 15:23:03 -0700
Message-ID: <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Dennis K <dennisk@netspace.net.au>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Jan 20, 2019 at 3:34 AM Dennis K <dennisk@netspace.net.au> wrote:
>
> Apologies in advance, if the issue I put forward is actually the
> intended behavior of BTRFS.
>
> I have noted while playing with sub-volumes, and trying to determine
> what exactly are the requirements for a subvolume to act as a legitimate
> parent during a receive operation, that modification of one subvolume,
> can affect children subvolumes that are received.
>
> It's possible I have noted this before when directories which I though
> should have existed in the destination volume, where not present,
> despite being present in the snapshot at the sending end.  (ie, a
> subvolume is sent incrementally, but the received subvolume is missing
> files that exist on the sent side).
>
> I can replicate this as follows
>
> Create the subvolumes and put some files in them.
> # btrfs sub create 1
> # btrfs sub create 2
> # cd 1
> # dd if=/dev/urandom bs=1M count=10 of=test
> # cd ..
> # btrfs sub snap 1 2
> # dd if=/dev/urandom bs=1M count=1 of=test2
> # cd ..
>
> Now set as read-only to send.  Subvolume 1 has the file "test, and
> subvolume 2 has the files "test" and "test2".
> # btrfs prop set 1 ro true
> # btrfs prop set 2 ro true
>
> Send, snapshot 2 is an incremental send.  The files created are the
> expected sizes.
> # btrfs send 1 -f /tmp/1
> # btrfs send -p 1 2 -f /tmp 2
>
> Now we make subvolume one read-write
> # btrfs prop set 1 ro false
> # rm 1/test
>
> Delete subvolume 2 and then recreate it be receiving it.
> # btrfs sub del 2
> # btrfs receive -f /tmp/2 .

This is an unworkable workflow, for multiple reasons. Your 1 and 2
subvolumes are not related to each other, and incremental send should
fail. So I think you might have stumbled on a bug.

(from man page)
       btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>]
<subvol> [<subvol>...]

(simplifed)

       btrfs send [-p <parent>] [<subvol>...


If <parent> has a UUID of 54321, I expect that <subvol> must have
Parent UUID of 54321, or the send command should fail.

Setting aside the possibility for a bug, let's describe the proper
workflow. Your subvolumes 1 and 2 are separate file trees, they're not
related and shouldn't ever appear together in a send/receive. If you
want to do incremental send, to send only changes that happen in 1 and
2 the workflow looks like this.

btrfs sub snap -r 1 1.20190120
btrfs sub snap -r 2 2.20190120
btrfs send 1.20190120 | btrfs receive /destination/
btrfs send 2.20190120 | btrfs recieve /destination/

First the snapshots are from the outset read only. And these are the
snapshots that you will send to the destination file systems, without
p, to initially populate the destination. Second, you will make
changes to original subvolumes 1 and 2, which are still rw subvolumes.
And then and some later time you snapshot them again, thus:

btrfs sub snap -r 1 1.20190121
btrfs sub snap -r 2 2.20190121

And then send the difference or increment with the command:

btrfs send -p 1.20190120 1.20190121 | btrfs receive /destination/
btrfs send -p 2.20190120 2.20190121 | btrfs receive /destination/

And if the original volume dies and you need to restore these
subvolumes to their most recent state:

btrfs send 1.20190121 | btrfs receive /newdestination/
btrfs send 2.20190121 | btrfs receive /newdestination/
btrfs sub snap 1.20190121 1
btrfs sub snap 2.20190121 2

You do not need to do incremental restore, because the subvolume that
appears as a result of an incremental send is *fully* populated, not
merely with just the incremental data. And in this case I take a
default rw snapshot.

I literally never use the 'property set' feature to set ro and unset
ro because I think it's dangerous.


>
> I understand that during send/receive, a snapshot is taken of the parent
> subvolume, then it is modified.  The problem is that if that snapshot is
> modified, then these modifications will affect the received subvolumes,
> including, in this case, silent data loss.


I think this is user error. And the bug is actually a feature request
for better error handling to account for the user inadvertently trying
to do an incremental send with a subvolume that does not have a
matching parent UUID to the -p specified parent subvolume's UUID. I
thought there was a check for this but I'm virtually certain I've run
into this problem myself with no warning and yes it's an unworkable
result at destination.

-- 
Chris Murphy
