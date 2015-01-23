Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:47715 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbAWTVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 14:21:20 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so7652544wev.12
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 11:21:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150123100515.GD26830@smurf.noris.de>
References: <20150123100515.GD26830@smurf.noris.de>
From: Noah Massey <noah.massey@gmail.com>
Date: Fri, 23 Jan 2015 14:20:38 -0500
Message-ID: <CADfjVrg6f21W1+LeXL0t+jXYn2LnQhscZDWgFFUhiR2xBswwkQ@mail.gmail.com>
Subject: Re: Moving snapshots
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 5:05 AM, Matthias Urlichs <matthias@urlichs.de> wrote:
> Hello,
>
> how do I move a (read-only) snapshot?
>

If you want to move a read-only snapshot to a different directory,
'..' changes, and therefore is not a read-only operation.

> Simply creating another read-only snap from the first one and then deleting
> the source works, except that it destroy's the snapshot's identity -- which
> means that it can't be used as a parent for "btrfs receive" any more.  :-(

# btrfs property set -ts /path/to/snapshot ro false
# mv /path/to/snapshot /new/path
# btrfs property set -ts /new/path ro true

worked for me

>
> --
> -- Matthias Urlichs

--
Noah
