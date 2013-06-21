Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:49560 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161432Ab3FUQiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:38:15 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so3452221bkb.36
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 09:38:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130621161842.GD6009@suse.cz>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
	<1370893895-24884-6-git-send-email-fdmanana@gmail.com>
	<CAL3q7H46KuUFpYpGZ1S_d2MtarOTzqQf4KuqoRTz8xQM4dZD6w@mail.gmail.com>
	<20130621161842.GD6009@suse.cz>
Date: Fri, 21 Jun 2013 17:38:14 +0100
Message-ID: <CAL3q7H52fJ8R0O-eHgJoi72LkNTSc9Jx_yQMpQpqkUjYvfCt-Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] Btrfs-progs: Validate super block checksum
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 5:18 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jun 20, 2013 at 06:08:29PM +0100, Filipe David Manana wrote:
>> Is there any reason why the btrfs progs (except for btrfs-show-super)
>> don't validate the super block's checksum?
>
> btrfsck accepts broken filesystems, so open_ctree_broken should possibly
> detect but skip the checksum mismatch.

So, when running btrfsck just report if there's a super block checksum
mismatch (like the patch does) but use it (don't skip it). For any
other tools in btrfs-progs just report the mismatch and skip to the
next super block (like what the patch does now) ?

thanks

>
> david



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
