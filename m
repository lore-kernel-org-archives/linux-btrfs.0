Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:40579 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbeGATA6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 15:00:58 -0400
Received: by mail-ot0-f172.google.com with SMTP id f17-v6so15153116otl.7
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2018 12:00:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
 <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com> <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Jul 2018 13:00:56 -0600
Message-ID: <CAJCQCtQgLnaLyFjT8yB8bH3uuNMnT3VXvOndC1c9Wkasjb+R8g@mail.gmail.com>
Subject: Re: btrfs check --readonly crash
To: Lewis Diamond <me@lewisdiamond.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 1, 2018 at 12:01 PM, Lewis Diamond <me@lewisdiamond.com> wrote:
> Yes, you are right, after running `btrfs check --clear-space-cache v1
> <dev>` a `btrfs check --readonly` passes without error. Thanks!
>
> I'm absolutely not familiar with the btrfs code, but would it be
> possible to have some error handling in `btrfs check` that picks up
> this situation instead of crashing?

It shouldn't crash, but also you didn't say what version of
btrfs-progs you're using so it's plausible it's already been fixed.
It's worth trying btrfs-progs 4.17 to see if it still crashes, and if
it does still crash, then take a btrfs-image (using -ss option) so
developers have a chance of making btrfs better.




-- 
Chris Murphy
