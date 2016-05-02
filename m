Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37140 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbcEBAjc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 20:39:32 -0400
Received: by mail-wm0-f51.google.com with SMTP id a17so119373936wme.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 17:39:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
Date: Sun, 1 May 2016 20:39:31 -0400
Message-ID: <CAD=QJKiQb0Ryedw+52pfZ-Tp0W9O0jPqxgGqxhY7b=U+2eP3wg@mail.gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 May 2016 at 03:00, Kai Krakow <hurikhan77@gmail.com> wrote:
> Hello!
>
> I'm not sure what triggeres this, neither if it is btrfs specific. The
> filesystems have been recreated from scratch. Mainly during my rsync
> backup (from btrfs to btrfs), but not necessarily limited to rsync
> usage, my system experiences uninterruptable freezes of commands like
> "df", "du", "btrfs fs sync", and probably more.

Out of curiosity, does this occur if you don't create or delete
snapshots, or if your backup script doesn't create or delete
snapshots?  And when it occurs, are you able to go to another terminal
and run a command that you don't use often, that definitely had to be
read from disk, but that doesn't query any filesystem properties (eg:
whois)?

Thanks,
Nicholas
