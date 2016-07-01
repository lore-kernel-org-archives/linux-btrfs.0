Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34016 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcGASrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 14:47:18 -0400
Received: by mail-oi0-f46.google.com with SMTP id s66so122426295oif.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 11:47:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
References: <CADbsYN2RZ9q7pFSawEkWbTXvomAONz60t7b1Hm6f7Mma=veKgQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Jul 2016 12:47:10 -0600
Message-ID: <CAJCQCtQheg_PqSaf1EZ7_oHkBBwa=CLSifMbW9=sXNLK7asFng@mail.gmail.com>
Subject: Re: btrfs lockup
To: Grey Christoforo <grey@christoforo.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 9:12 AM, Grey Christoforo <grey@christoforo.net> wrote:
> Hi,
>
> My machine locked up and I noticed this[1] in my dmesg. I figured I'd
> report it here. I *think* this is related to the numerous btrfs
> subvolumes that docker has created on my system. The lockup occurred
> when gnome's baobab[2] was scanning my
> /var/lib/docker/btrfs/subvolumes folder.

This is too well trimmed. I'm not seeing the actual oops, can you trim
this less so it's possible to see what was going on a minute (or 10)
before this?

About how many subvolumes?


-- 
Chris Murphy
