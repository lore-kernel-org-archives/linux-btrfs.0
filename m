Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E3CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375CA21479
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="OrrCaQo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfBSAQX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 19:16:23 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:35811 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfBSAQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 19:16:22 -0500
Received: by mail-lj1-f171.google.com with SMTP id j13-v6so15908922ljc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 16:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SNo1aPTNzZX8DQghToZYgDWu+RQZl0bE/09dvQKg8zI=;
        b=OrrCaQo/8pCOLQSa439h9V4wxNAS4m6ps6fggw63gFBkdiN13/1jBeLbEnj6SydlKZ
         Asnkv9fjAiKzEB9WDLQ5HBSKd4WbAtaLzDsQaOLq980z313n/i0vprS54FaL2ek1bqe2
         GhMszBJ8f4wTo1GMVCo5tDad81KURk5jGBhYirzRoaTd79tdW00d1U/VXwRRD6ZKyjx0
         xZPXvDaWWCLPriKo4nG+H6+gC1WRtenkaO59jV9KU2oUuYr3+96uWTF9Rfvbm66uTI91
         bwjYMIyGQRUqzIpogHua4MXXTSVK8Xsbxwv3U0oxiJH5SJ6j3zky8swJ5iiZsSIsU3tq
         t9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SNo1aPTNzZX8DQghToZYgDWu+RQZl0bE/09dvQKg8zI=;
        b=sFWr3Xb8iVoWcXV0DZhO8oU89Af+SonRcFDwCFeUmHTzUqTQbDoQFE/OfKl8cKxrmM
         1L9q6Nh0gavLzWDIH7mZ8sGPFif6Y/7cUy0yCnLPzLIfjWuJKOm5DaHVjLpyzzJL1ZGL
         ut5+PNqvLSCIJcLEdBc2yzyjFmLQ4a8+vxX+eJyT9MGySx9upq0iCWoqq2N53J5inC86
         ZReyH/uj3DytDvQbezAVa2iee6s0mQk1QzeJVDekr2vLmOSHoXcucdQBQfnP34Fyw/cI
         MMG9xmJWK8R4ikQw6XPV6Hq+wCfquXJB37rCHU/R7wo19OISs9sXaMHIIe5vFEvHEEgJ
         4Q2A==
X-Gm-Message-State: AHQUAuZNgMJ+wKRksCek8RsT7ojanVOW3mejxeictyeNr360lxwDsT3N
        zEdmDDH67aTh2ITYXROTQtQksv6oZ4jdDR79XeLsLleLXc4=
X-Google-Smtp-Source: AHgI3IahZNzLTMkcwDbXgAN4uMng7OSf/H9dehcDnGgoJU/tSpO7vZcOSMJC+JA0OyrDNRDQE56Y9bJKADXGxji9WbY=
X-Received: by 2002:a2e:870c:: with SMTP id m12mr1091482lji.24.1550535380797;
 Mon, 18 Feb 2019 16:16:20 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org> <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org> <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
 <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org> <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
 <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org>
In-Reply-To: <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 17:16:09 -0700
Message-ID: <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 4:58 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> I assume i would have to use rsync (with --inplace possibly) to keep the
> master volume in sync between machines?

Why?

You previously said you didn't want to do that:
" if I change / remove, say 10 GB worth of data from the
master subvolume unrelated to the child subvolume I don't want those
gigabytes sent down the wire with btrfs send as they are unrelated. "

So instead of sending those changes with send you're going to send the
changes with rsync which is even more inefficient?

> Say for example I have a (large) file on master, on machine A, I cp
> reflink it to a child subvolume. I then send -p child subvolume to
> remote machine B (which already have the master volume).

1. The master snapshots must be identical snapshots on source and
destination; it must have been replicated using send/receive or
receive will complain.
2. I don't know what "send -p child subvolume to remove" means because
-p option means two snapshots must be included and I don't know what
two snapshots you're planning on using, so I can't answer the
question.

>Then i change
> parts of the file on the master of machine A. I then rsync (?) the
> master volume so its the same across the machines. Can I then later send
> -p the child volume, either back to the original machine (A) or to a 3rd
> machine (C) given that the master volumes are synced?

rsync'd subvolumes across volumes aren't consistent identical by btrfs
receive. I expect they can't be used for incremental send/receive.
What you're trying to achieve, big picture, isn't clear. You're
describing it in terms of send/receive and confusing it with rsync. I
don't understand what rsync has to do with this.

You realize if you merely move a large file within a subvolume, and
then you using rsync to a remote system, it will delete the original
file and then sync over the nework that same data to the new location?
Rsync has no idea how to just move files around. Btrfs send-receive
does.

> About the efficiency I'm not planning to remove large amounts of data
> that is used by child subvolumes (although some will be updated). But
> given the unpredictability of what files will be used by child
> subvolumes i might remove large unused amounts of data.

OK?


--=20
Chris Murphy
