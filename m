Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:64080 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaK3W5s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 17:57:48 -0500
Received: by mail-yk0-f176.google.com with SMTP id q200so4189889ykb.7
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 14:57:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
References: <547B5724.1060507@libero.it>
	<CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
	<CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
Date: Sun, 30 Nov 2014 22:57:47 +0000
Message-ID: <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
From: Dimitri John Ledkov <xnox@debian.org>
To: cwillu <cwillu@cwillu.com>
Cc: "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 November 2014 at 22:31, cwillu <cwillu@cwillu.com> wrote:
>
> In ubuntu, the initfs runs a btrfs dev scan, which should catch
> anything that would be missed there.
>

I'm sorry, udev rule(s) is not sufficient in the initramfs-less case,
as outlined.

In case of booting with initramfs, indeed, both Debian & Ubuntu
include snippets there to run btrfs scan.

-- 
Regards,

Dimitri.
