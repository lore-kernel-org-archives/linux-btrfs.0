Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36860 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbKOQ7F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Nov 2015 11:59:05 -0500
Received: by wmww144 with SMTP id w144so83063924wmw.1
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 08:59:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
References: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sun, 15 Nov 2015 17:58:44 +0100
Message-ID: <CAA7pwKOPBLGAqZggmPZmfmRai96Py_yXjXkfEhb47XwLxxdGRA@mail.gmail.com>
Subject: Re: More memory more jitters?
To: "CHENG Yuk-Pong, Daniel" <j16sdiz@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 November 2015 at 15:11, CHENG Yuk-Pong, Daniel <j16sdiz@gmail.com> wrote:
>
> Background info:
>
> I am running a heavy-write database server with 96GB ram. In the worse
> case it cause multi minutes of high cpu loads. Systemd keeping kill
> and restarting services, and old job don't die because they stuck in
> uninterruptable wait... etc.
>
> Tried with nodatacow, but it seems only affect new file. It is not an
> subvolume option either...

How about nocow (chattr +C) on the database directories? You will have
to copy the files to make nocow versions of them.
