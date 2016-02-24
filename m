Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbcBXLvs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 06:51:48 -0500
Date: Wed, 24 Feb 2016 12:51:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Henrik Asp <solenskiner@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: restore: make btrfs restore able to read a
 file which lists files to restore
Message-ID: <20160224115137.GA23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456163603-6712-1-git-send-email-solenskiner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456163603-6712-1-git-send-email-solenskiner@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 06:53:23PM +0100, Henrik Asp wrote:
> --path-regex' syntax does not map well to restoring specific files.
> this patch introduces --path-from-file which takes a file listing
> files to restore.
> that file is memory mapped, and for every leaf, memmem is used to
> check if fs_file is in that list.

Is it supposed to match only full path or also substrings? The way it's
implemented it can match just part of the path but I'm not sure if this
is intended or not.

Paths in path-from-file:

  /a/b/c/d

In filesystem:

  /backup1/a/b/c/d
  /backup2/a/b/c/d

I'd expect that the path would need to match absolutelly. Alternatively,
we could do relative path matching, so:

Paths in path-from-file:

  a/b/c/d

would match both /backup[12].

Either way i find the matching rules ambiguous and not documented.
Please clarify.
