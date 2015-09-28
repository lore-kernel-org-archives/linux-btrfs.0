Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:32941 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbbI1DIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 23:08:50 -0400
Received: by iofh134 with SMTP id h134so161640947iof.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Sep 2015 20:08:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$73c0$b0528a34$f375bb55$bda81535@cox.net>
References: <20150927175252.GA24990@blind.goeswhere.com>
	<pan$73c0$b0528a34$f375bb55$bda81535@cox.net>
Date: Sun, 27 Sep 2015 23:08:49 -0400
Message-ID: <CAGfcS_n7czPgSomGo8wFFn8Zxoi4QWA0L+NtK+LreA0j3aewnQ@mail.gmail.com>
Subject: Re: fstrim silently does nothing on dev add/dev rem'd filesystem
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 27, 2015 at 10:45 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> But I think part of reasoning behind the relatively low priority this
> issue has received is that it's a low visibility issue not really
> affecting most people running btrfs, either because they're not running
> on ssd or because they simply don't have a particularly high awareness of
> what trim does and thus about how it's failing to work here and what that
> means to them.  If we get a rash of people posting on-list that it's
> affecting them, that relative priority is likely to go up, and with it
> the patch testing and integration schedule for the affected patches.

I've never actually seen fstrim do anything on btrfs (0 bytes
trimmed).  I stopped using it a few months ago when the news came out
about all the issues with its implementation, and I believe my drive
is still blacklisted anyway.

It really should be fixed, but right now that goes all around - if
btrfs fixed it tomorrow I'd still be stuck until somebody figures out
how to reliably do it on a Samsung 850.

--
Rich
