Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37243 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829AbaDJOAH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 10:00:07 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so3892715pde.25
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 07:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4783411.VVGoQz5kVU@fuchsia>
References: <4783411.VVGoQz5kVU@fuchsia>
Date: Thu, 10 Apr 2014 16:00:06 +0200
Message-ID: <CAPpBBdMCAFASLgGpbWo7-Pp74S_KQdZ2A7qrSNzo0rGrZAbqMw@mail.gmail.com>
Subject: Re: Copying a disk containing a btrfs filesystem
From: George Eleftheriou <eleftg@gmail.com>
To: Michael Schuerig <michael.lists@schuerig.de>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I would see one (dangerous? risky? needing more options perhaps?) solution:

dd if=/dev/sda of=/dev/sdb

/dev/sda: old disk
/dev/sdb: new disk

Maybe there is another much more complicated solution:

Plug the old disk in a USB dock/case, do the same for the new disk in
another dock/case, plug both docks/cases in another linux system
running recent kernel and btrfs-progs and convert to a
"-dconvert=raid1 -mconvert=raid1" profile with a balance. Then degrade
it by removing the old disk and rebalance-convert back to single or
DUP profile (i am not quite sure this is even possible).

Just an idea. I wouldn't trust me.



On Thu, Apr 10, 2014 at 3:21 PM, Michael Schuerig
<michael.lists@schuerig.de> wrote:
>
> SMART indicates that my notebook disk may soon be failing (an
> unreadable/uncorrectable sector), therefore I intend to exchange it. The
> disk contains a single btrfs filesystem with several nested(!)
> subvolumes, each with several read-only snapshots in a .snapshots
> subdirectory.
>
> As far as I can tell, btrfs currently does not offer a sensible way to
> duplicate the entire contents of the old disk onto a new one. I can use
> cp, rsync, or send/receive to copy the "main" subvolumes. But unless I'm
> missing something obvious, the snapshots are effectively lost. btrfs
> send optionally takes multiple clone sources, but I've never seen an
> example of its usage.
>
> If that's what "experimental" means, I'm willing to accept it. However,
> I'd like to emphasize that there's still something missing. Of course,
> most of all I'd like to be proved wrong.
>
> Michael
>
> --
> Michael Schuerig
> mailto:michael@schuerig.de
> http://www.schuerig.de/michael/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
