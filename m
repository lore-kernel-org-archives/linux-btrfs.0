Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36524 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbcFKMaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 08:30:23 -0400
Received: by mail-oi0-f43.google.com with SMTP id p204so148989117oih.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 05:30:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575B816B.90506@aarghimedes.fi>
References: <5736DFA3.3090904@aarghimedes.fi>
	<CAPmG0ja9J40q0npcANz=gN1EAiNOc400NjjA5V1wV_FFMPc02Q@mail.gmail.com>
	<575B816B.90506@aarghimedes.fi>
Date: Sat, 11 Jun 2016 06:30:22 -0600
Message-ID: <CAJCQCtStRu34z_joYtTh2+ChjLBCOruH5ej2hNU0wc88hyC46g@mail.gmail.com>
Subject: Re: Kernel crash on mount after SMR disk trouble
From: Chris Murphy <lists@colorremedies.com>
To: Jukka Larja <roskakori@aarghimedes.fi>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 9:11 PM, Jukka Larja <roskakori@aarghimedes.fi> wrote:


> I understand that usebackuproot requires kernel >= 4.6. I probably won't be
> installing a custom kernel, but if I still have the array in its current
> state when 4.6 becomes available in Debian Stretch, I'll give it a try.

It's the "recovery" mount option in older kernels.


-- 
Chris Murphy
