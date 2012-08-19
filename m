Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36857 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2HSUFc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 16:05:32 -0400
Received: by bkwj10 with SMTP id j10so1699148bkw.19
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Aug 2012 13:05:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120819195147.6EA7EA6E3F@smtp.hushmail.com>
References: <20120819195147.6EA7EA6E3F@smtp.hushmail.com>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Sun, 19 Aug 2012 15:05:11 -0500
Message-ID: <CAGAVQTEvYtgzPP9rjt=rnYi9yNpMRXjj86TzG-kiUio7uOMPHA@mail.gmail.com>
Subject: Re: How to get Btrfs on 2nd partition of USB HDD to automount as read/write
To: dg1727 <dg1727@hushmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 19, 2012 at 2:51 PM, dg1727 <dg1727@hushmail.com> wrote:
>
> permissions of the directories in /dev are drwx------ for the NTFS
> and dr-xr-xr-x for the Btrfs.
>
> How can the OS be set up so that the Btrfs will automount
> read/write?

try:

chmod u+w /path/to/btrfs/mount

... for whatever reason mkfs.btrfs created new subvolumes (but not
snapshots!) with 555 perms, which essentially says "writable to nobody
at all" ... IIRC, this was changed within the last year or so.

-- 

C Anthony
