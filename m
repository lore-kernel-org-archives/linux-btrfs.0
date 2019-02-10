Return-Path: <SRS0=C9fc=QR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4262C282C2
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 18:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D7212146F
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 18:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GygXVUA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfBJSei (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 13:34:38 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:38650 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfBJSei (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 13:34:38 -0500
Received: by mail-lj1-f176.google.com with SMTP id c19-v6so6967817lja.5
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2019 10:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZtjXC++XXk9agML/Qo37ulV6GWfTlbwV+86N4TKWPc=;
        b=GygXVUA70R1JDSzy4aMKl8Q+n29rsc6srt2JJJXkyYVxSqQb6E8nQjXiPV1+HOU7Lr
         lEIeNod+iwLTemJoreCKXW3TQn6eGZdPujwGLuWBfR45TIU7tZH9ZGAkQFjBJS1UgCqY
         Gy9kJOXZABlSnvGnw+LjMQvUjcMEISVDVGMXLDgCviYVVJAXjuCdYXGj3pXc3EDEsH6I
         aDNHqeHMrYkkwiLqPVnbpr+J+xRRg8YQtX90j688tE7jb+5KzXh8El9OCXi9JLialIEw
         WbOfC4QWkFlk0frmqHdFt0lxDuKZ6/oOwHDdSeH4dfqPPEVPbMDmIZUpqatiAipykAS+
         P5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZtjXC++XXk9agML/Qo37ulV6GWfTlbwV+86N4TKWPc=;
        b=mOUjpVf1MNXlpIoBrCAW7ow83TVg5vUlfG6kN5FnqCx7q98x2saEo/iVipIstFE+jR
         a96zp/LtdPKhapYkO3toyCcu4AMzx56LiJG4Ij+05vl9DSTKCXDPjxYeafXVguqm+uNt
         PitRCWGEeCYYqCwokaFmWuzFfEEGMLDw4GtNe9WKGrwHtSwajLH0Eb7SBOG44Ngy58Zh
         Zz2jjSsXcH2Eq1VhcIfOwTfS5R/vGbb84oM9udLWNp8McZIAABYjkZoyV5Ahrm4VJ4zo
         vaGF5Q4PRWA88flaWSuvgHz7EdpJIyXfwhnl3eFtzP1eRaj5WUa5ApOxfXkXcJPhaslv
         nSfg==
X-Gm-Message-State: AHQUAua4G0qnCngpLL+RCNyb0g33t+L8Hi/HS/ZfQ4JmZc02M8KLF7gl
        l1wD+wtAYNjjNjWjPz0saGkvQ/zrl0MeG804RbOmVw==
X-Google-Smtp-Source: AHgI3IbdGT4rnj8rYb1FFpJJX7pc7yI2czn/plSkbAp2dB/22EU6GXBTib0i69Jro8eoUOibNACJ1/W2TBHvvbI70f0=
X-Received: by 2002:a2e:9a09:: with SMTP id o9-v6mr11342859lji.132.1549823675844;
 Sun, 10 Feb 2019 10:34:35 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr> <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net> <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net> <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
 <f67c6a69-4fc8-e33a-543e-9b97adf54438@dirtcellar.net>
In-Reply-To: <f67c6a69-4fc8-e33a-543e-9b97adf54438@dirtcellar.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Feb 2019 11:34:24 -0700
Message-ID: <CAJCQCtQ-nLkOYE5ARk+rjT4JBxR6Atn1gU-+U8gAT0sb7Mduow@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     waxhead <waxhead@dirtcellar.net>
Cc:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 9, 2019 at 5:13 AM waxhead <waxhead@dirtcellar.net> wrote:

> Understood, but that is not quite what I meant - let me rephrase...
> If BTRFS still can't mount, why would it blindly accept a previously
> non-existing disk to take part of the pool?!

It doesn't do it blindly. It only ever mounts when the user specifies
the degraded mount option, which is not a default mount option.

>E.g. if you have "disk" A+B
> and suddenly at one boot B is not there. Now you have only A and one
> would think that A should register that B has been missing. Now on the
> next boot you have AB , in which case B is likely to have diverged from
> A since A has been mounted without B present - so even if both devices
> are present why would btrfs blindly accept that both A+B are good to go
> even if it should be perfectly possible to register in A that B was
> gone. And if you have B without A it should be the same story right?

OK no, you haven't gone far enough to setup the split brain scenario
where there is a partially legitimate complaint. Prior to split brain,
it's entirely reasonable for Btrfs to mount *when you use the degraded
mount option* - it does not blindly mount. And if you've ever done
exactly what you wrote in the above paragraph, you'd see Btrfs
*complains vociferously* about all the errors it's passively finding
and fixing. If you want a more active method of getting device B
caught up with A automatically - that's completely reasonable, and
something people have been saying for some time, but it takes a design
proposal, and code.

As for split brain scenario, it is only the user's manual intervention
with multiple 'degraded' mount options (which again, is not the
default) that caused the volume to arrive in such a state. Would it be
wise to have some additional error checking? Sure. Someone would need
to step up with a design and to do code work, same as any other
feature. Maybe a rudimentary check would be comparing the timestamps
for leaves or nodes ostensibly with the same transid, but in any case
that doesn't just happen for free.


> >> So what you are saying is that the generation number does not
> >> represent a true frozen state of the filesystem at that point?
> > It does _only_ for those devices which were present at the time of the
> > commit that incremented it.
> >
> So in other words devices that are not present can easily be marked /
> defined as such at a later time?

That isn't how it currently works. When stale device B is subsequently
mounted (normally) along with device A, it's only passively fixed up.
Part of the point of non-automatic degraded mounts that require user
intervention is the lack of anything beyond simple error handling and
fixups.

> Ok, not sure I still understand how/why systemd knows what devices are
> part of btrfs (or md or lvm for that matter). I'll try to research this
> a bit - thanks for the info!

It doesn't, not directly. It's from the previously mentioned udev
rule. For md, the assembly, delays, and fall back to running degraded,
are handled in dracut. But the reason why this is in udev is to
prevent a mount failure just because one or more devices are delayed;
basically it inserts a pause until the devices appear, and then
systemd issues the mount command.


--
Chris Murphy
