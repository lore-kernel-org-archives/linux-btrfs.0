Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61267 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2G3LaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 07:30:00 -0400
Received: by ghrr11 with SMTP id r11so4663372ghr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 04:29:59 -0700 (PDT)
Message-ID: <1343647796.6064.12.camel@ayu>
Subject: Re: subvolumes: default and IDs
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Florian Lindner <mailinglists@xgm.de>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 30 Jul 2012 07:29:56 -0400
In-Reply-To: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
References: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-07-30 at 09:56 +0200, Florian Lindner wrote:
> Hey!
> 
> I recently starting playing with btrfs and subvolume, but it has left
> me puzzled:

> root@horus /mnt/test # btrfs subvolume get-default .
> ID 256 top level 5 path sv1
> ID 259 top level 5 path sv2
> <<<
> 
> What is the default subvolume now? How can I tell?

It looks like there's currently a bug in btrfs-progs - the 'get-default'
command is actually doing a 'list' instead of printing the default. With
any luck it's just a little error in the command-line parsing and should
be easy to fix...

> >>>
> root@horus /mnt # btrfs subvolume set-default 5 test
> root@horus /mnt # umount test && /mnt # mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
> 
> Ok, 5 seems to be the root subvolume id. Is it always like that? I
> remembered to have read somewhere it was 0 ? (which makes a kind of
> more sense for me)

The internal ID of the root subvolume is 5, yes. I don't know whether
this is a current implementation detail and subject to change, or if it
will permanently stay that way. I *think* it's part of the disk format,
and it permanent.

In either case, the subvol id '0' is treated as an alias for 'the
original root subvolume', and the two can be used interchangeably in the
mount command. I always find '0' just a bit easier to remember :)

> >>>
> root@horus /mnt # btrfs subvolume set-default 0 test
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1.file
> <<<
> 
> set-default 0 seems to do nothing but does not produce an error
> either.

Looks like you've found another bug (or maybe just a missing feature);
it would be nice if this command allows you to use '0' as an alias for
the root subvolume.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

