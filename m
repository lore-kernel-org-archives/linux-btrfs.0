Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33772 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbcBMSZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 13:25:17 -0500
Received: by mail-ig0-f181.google.com with SMTP id y8so51116083igp.0
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 10:25:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160213032846.GB6717@merlins.org>
References: <20160213032846.GB6717@merlins.org>
Date: Sat, 13 Feb 2016 11:25:16 -0700
Message-ID: <CAJCQCtSW-JkH52E3fSx-wd6hUBmVZw0UxMwDbZQiBwaz3Oppig@mail.gmail.com>
Subject: Re: Is there now a way to migrate FS without losing shared COW blocks
 between subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 8:28 PM, Marc MERLIN <marc@merlins.org> wrote:
> btrfs send lets you keep COW blocks within a subvolume.
> But if I have lots of backups where subvolumes have shared data, and I need
> to migrate this to a new filesystem, is there a decent way?
>
> I know I can btrfs device add new drive as raid1, but I'm trying to migrate
> off an old filesystem that likely wasn't created well. Is there a way to do
> that?
> I guess ideally I'd need btrfs send on a volume level, not subvolume level.

btrfs send -e should accept a long list of subvolumes, or if you have
good bashfoo maybe you can have bash hand over the list in the proper
subvolume order. This effectively acts like a recursive send. The
problem is that right now it's not working. Even if I use fully
qualified paths, starting with the top level volume (id5) being
mounted, it doesn't work. But that's the only way I know of to do what
you want. Otherwise it's with -p and it's pretty tedious to do
manually but again, good bashfoo and you can probably automate a loop.
Send SV1 manually, then -p SV1 SV2 then -p SV2 SV3 then -p SV3 SV4,
and so on. I'm pretty sure -e does that for you but I haven't been
able to test it because I can't get it to work.



-- 
Chris Murphy
