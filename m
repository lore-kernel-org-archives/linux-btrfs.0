Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36534 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcBXNBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 08:01:49 -0500
Received: by mail-lb0-f180.google.com with SMTP id x1so9774105lbj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 05:01:49 -0800 (PST)
From: Henrik Asp <solenskiner@gmail.com>
To: dsterba@suse.cz, Henrik Asp <solenskiner@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: restore: make btrfs restore able to read a file which lists files to restore
Date: Wed, 24 Feb 2016 14:01:46 +0100
Message-ID: <42857949.PiLisvDqGC@moerta>
In-Reply-To: <20160224115137.GA23746@twin.jikos.cz>
References: <1456163603-6712-1-git-send-email-solenskiner@gmail.com> <20160224115137.GA23746@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On onsdag 24 februari 2016 kl. 12:51:37 CET David Sterba wrote:

> Is it supposed to match only full path or also substrings? The way
> it's implemented it can match just part of the path but I'm not sure
> if this is intended or not.
> 
> Paths in path-from-file:
> 
>   /a/b/c/d
> 
> In filesystem:
> 
>   /backup1/a/b/c/d
>   /backup2/a/b/c/d

neither /backup1/a/b/c/d nor /backup2/a/b/c/d are substrings of /a/b/c/
d, so they wouldn't match; /a, /a/b, /a/b/c would match, so the 
hierarchy ./a/b/c/ is already created where data is rescued to, when d 
is encountered by search_dir().

Thinking about it now, /b/c/d in the filesystem would also match, though. 
That's clearly wrong.

> I'd expect that the path would need to match absolutelly.
> Alternatively, we could do relative path matching, so:
> 
> Paths in path-from-file:
> 
>   a/b/c/d
> 
> would match both /backup[12].
> 
> Either way i find the matching rules ambiguous and not documented.
> Please clarify.

Agreed, its ambiguous. And the code unclear. I'll rethink it.
