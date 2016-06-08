Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32829 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbcFHKsd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 06:48:33 -0400
Received: by mail-qg0-f53.google.com with SMTP id l44so455862qgd.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jun 2016 03:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160608083757.GA30823@localhost>
References: <20160608083757.GA30823@localhost>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 8 Jun 2016 06:47:52 -0400
Message-ID: <CADfjVrhi7X6dGdKrDYNL3sxy-kcbF0SkaNxAeyiJZhRVJYCcRQ@mail.gmail.com>
Subject: Re: Can't remove read-only snapshot with immutable flag set
To: cdlscpmv <cdlscpmv@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, June 8, 2016, cdlscpmv <cdlscpmv@gmail.com> wrote:
>
> Hi!
>
> It happened that I set the immutable flag (via `chattr +i`) on a subvolume.
> Then I made a read-only snapshot of that subvolume. Now I can't remove
> this snapshot.
>
>         #> btrfs subvolume delete my_snapshot
>         Delete subvolume (no-commit): 'my_snapshot'
>         ERROR: cannot delete 'my_snapshot': Operation not permitted
>         #> chattr -i my_snapshot
>         chattr: Read-only file system while setting flags on my_snapshot
>         #> btrfs --version
>         btrfs-progs v4.4.1
>         #> uname -r
>         4.5.2
>
> Is there any other way to do this? Or is it a bug?
>
Try
#> btrfs property set my_snaphot ro false
#> chattr -i my_snapshot
#> btrfs sub del my_snapshot
