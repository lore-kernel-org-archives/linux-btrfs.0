Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35507 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbcLKFrR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 00:47:17 -0500
Received: by mail-yw0-f170.google.com with SMTP id i145so43404314ywg.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Dec 2016 21:47:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 10 Dec 2016 22:47:15 -0700
Message-ID: <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Markus Binsteiner <makkus@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 10, 2016 at 5:12 PM, Markus Binsteiner <makkus@gmail.com> wrote:
> It seems I've accidentally deleted all files in my home directory,
> which sits in its own btrfs partition (lvm on luks). Now I'm trying to
> find the roots to be able to use btrfs restore later on.
>
> btrfs-find-root seems to be taking ages though. I've run it like so:
>
> btrfs-find-root /dev/mapper/think--big-home  -o 5 > roots.txt

Uhh, just do btrfs-find-root by itself to get everything it can find.
And then work backwards from the most recent generation using btrfs
restore -t using each root bytenr from btrfs-find-root. The more
recent the generation, the better your luck that it hasn't been
overwritten yet; but too recent and your data may not exist in that
root. It really depends how fast you umounted the volume after
deleting everything.



-- 
Chris Murphy
