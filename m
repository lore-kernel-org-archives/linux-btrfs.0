Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44047 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2LLSbm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 13:31:42 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so1014879obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 10:31:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
	<1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
Date: Wed, 12 Dec 2012 12:31:41 -0600
Message-ID: <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
Subject: Re: Encryption
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: merc1984@f-m.fm
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 11:12 AM,  <merc1984@f-m.fm> wrote:
>
> So there is no way to have filesystem encryption, while keeping
> snapshots?
>
>

I run btrfs on top of LUKS encryption on my laptop.  You should be
able to do the same.

You could then run rsync through ssh.  However, rsync will have no
knowledge of any blocks shared under subvolume snapshots.

Btrfs does not yet have internal encryption.
