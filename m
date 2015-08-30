Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33207 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbH3KKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 06:10:31 -0400
Received: by iods203 with SMTP id s203so132240330iod.0
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Aug 2015 03:10:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <55E214DD.9070504@gmail.com>
References: <55E214DD.9070504@gmail.com>
Date: Sun, 30 Aug 2015 11:10:30 +0100
Message-ID: <CAL3q7H6AeFVzXQeRPWdGnV4B9RDParRN2sTyr4=XT6SfFFekEA@mail.gmail.com>
Subject: Re: 4.1.6 gentoo-hardened: Hang during rename
From: Filipe David Manana <fdmanana@gmail.com>
To: Kenneth Lakin <kennethlakin@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 29, 2015 at 9:23 PM, Kenneth Lakin <kennethlakin@gmail.com> wrote:
> Hey. It looks like I'm being bitten by:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/44987/ except I'm
> hitting it during rename, rather than unlink. Dmesg spew here:
> http://pastebin.ca/3137198 (That pastebin post includes the -unrelated-
> source of the W taint.)
>
> I'm running on Gentoo hardened-sources 4.1.6 on x86 (rather than amd64).
> The affected volume is mounted with
> "rw,relatime,ssd,discard,space_cache,autodefrag" and -AFAIK- has no
> subvolumes.
>
> emerge is the blocked program and is the Gentoo package manager. This
> lockup happens occasionally during the "Updating Portage cache" step of
> the emerge sync operation. The emerge task is unkillable and is blocked
> in D status. Attempts to re-run the cache update task have it hang at
> what appears to be the same place. Only a reboot can "fix" the problem.
> The rest of the system works just fine; the only thing that appears to
> be blocked is the Portage cache update.
>
> I couldn't find an open bug for this, but my Google-fu may be weak
> today. Did I miss the bug report, or is this a currently unknown or
> unconfirmed issue? Let me know if I can help with diagnostics.

The fix landed in 4.2-rc:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6ca0709756710c47ec604dd08b9fc45929d36390

And it's not in 4.1 nor any other older releases.
>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
