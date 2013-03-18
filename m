Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41475 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3CRTYr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 15:24:47 -0400
Received: by mail-ie0-f173.google.com with SMTP id 9so7503720iec.32
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 12:24:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
References: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
Date: Mon, 18 Mar 2013 13:24:46 -0600
Message-ID: <CAE5mzvi5nsTDw9ZX72hXt2EMsmxJUef3WmvArxxKhqJFJU-CLg@mail.gmail.com>
Subject: Re: Btrfs in multiple different disc -d sigle -m raid1 one drive failure...
From: cwillu <cwillu@cwillu.com>
To: Jan Beranek <jan233321@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 18, 2013 at 12:32 PM, Jan Beranek <jan233321@gmail.com> wrote:
> Hi all,
> I'm preparing a strorage pool for large data with quite low importance
> - there will be at least 3 hdd in "-d single" and "-m raid1"
> configuration.
>
> mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc
>
> What happen if one hdd fails? Do I lost everything from all three
> discs or only data from one disc? (if from only one disc, then is it
> acceptable otherwise not...)

I just finished doing some testing to check:  It will work, kinda sorta.

You'll be forced to mount read-only, and any reads of file extents
that existed on the missing disk will return an io error.  As I
understand it, single doesn't force files to be on a single disk,
instead it _doesn't_ force them to be _several_ disks; the implication
being that a large file (say, a 4gb movie) may still end up with
pieces on each disk.
