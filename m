Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35367 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcDHEZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 00:25:06 -0400
Received: by mail-oi0-f53.google.com with SMTP id p188so123738233oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Apr 2016 21:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160404221732.47372382@jupiter.sol.kaishome.de>
References: <CALJXSJrdkqau4xWax72xQGBcaONDxWBeDLOn4KD7vP8NKJikDw@mail.gmail.com>
	<20160404221732.47372382@jupiter.sol.kaishome.de>
Date: Fri, 8 Apr 2016 00:25:03 -0400
Message-ID: <CALJXSJqep7ww_VYYsJX5S75QzbUtMeEw+j-fCXGR7gCtqFWQSw@mail.gmail.com>
Subject: Re: csum failed on innexistent inode
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2016 at 4:17 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>
> Am Mon, 4 Apr 2016 03:50:54 -0400
> schrieb Jérôme Poulin <jeromepoulin@gmail.com>:
>
> > How is it possible to get rid of the referenced csum errors if they do
> > not exist? Also, the expected checksum looks suspiciously the same for
> > multiple errors. Could it be bad RAM in that case? Can I convince
> > BTRFS to update the csum?
> >
> > # btrfs inspect-internal logical-resolve -v 1809149952 /mnt/btrfs/
> > ioctl ret=-1, error: No such file or directory
> > # btrfs inspect-internal inode-resolve -v 296 /mnt/btrfs/
> > ioctl ret=-1, error: No such file or directory
>
> I fell into that pitfall, too. If you have multiple subvolumes, you
> need to pass the correct subvolume path for the inode to properly
> resolve.
>
> Maybe that's the case for you?
>

You are absolutely right for the inode case, however, that did not
help for logical-resolve.

The file found by the inode does not seem to be corrupted though.

# btrfs sub li /mnt/btrfs/ | cut -d' ' -f9 | xargs -n1 btrfs inspect
logical-resolve -v 1809149952
ioctl ret=-1, error: No such file or directory
ioctl ret=-1, error: No such file or directory
ioctl ret=-1, error: No such file or directory
ioctl ret=-1, error: No such file or directory
...

# btrfs sub li /mnt/btrfs/ | cut -d' ' -f9 | xargs -n1 btrfs inspect
inode-resolve -v 296
ioctl ret=-1, error: No such file or directory
ioctl ret=0, bytes_left=4018, bytes_missing=0, cnt=1, missed=0
backups/runboy/data/www/dev/.virtualenv/lib/python3.4/_collections_abc.py
ioctl ret=0, bytes_left=4018, bytes_missing=0, cnt=1, missed=0
backups@2016-03-23-01-56/www/dev/.virtualenv/lib/python3.4/_collections_abc.py
ioctl ret=0, bytes_left=4018, bytes_missing=0, cnt=1, missed=0
backups@2016-03-23-02-04/www/dev/.virtualenv/lib/python3.4/_collections_abc.py
ioctl ret=0, bytes_left=4018, bytes_missing=0, cnt=1, missed=0
backups@2016-03-23-05-05/www/dev/.virtualenv/lib/python3.4/_collections_abc.py
ioctl ret=0, bytes_left=4018, bytes_missing=0, cnt=1, missed=0
...
