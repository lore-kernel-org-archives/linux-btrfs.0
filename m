Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59136 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaAQCxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 21:53:10 -0500
Received: by mail-ob0-f180.google.com with SMTP id wm4so3725187obc.11
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 18:53:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm-jEdSB+RwA_p_DhRzH947+d7Rr_sCgEqLMO_=3n6OKeQ@mail.gmail.com>
References: <CAKcLGm-jEdSB+RwA_p_DhRzH947+d7Rr_sCgEqLMO_=3n6OKeQ@mail.gmail.com>
Date: Thu, 16 Jan 2014 20:53:07 -0600
Message-ID: <CAKcLGm82DdiDhUYT4OHk8HsJRoz98=brsjz7f7HE37Wgb0Jafg@mail.gmail.com>
Subject: Re: btrfs-endio-wri: page allocation failure
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 8:03 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I received a btrfs page allocation failure on my 3.12.7 kernel which
> is merged with Chris' for-linus branch for the 3.13_rc kernel.
>
> I have several btrfs partitions mounted, but I believe this error is
> on my btrfs root partition.
>
> Several things were going on at the same time on this partition.  I
> have a snapshot script creating and deleting snapshots of the root
> partition.  I was also compiling an application, and running Firefox.
>
> I know the snapshots may be a problem area.  The snapshot script is
> currently running with about 550 snapshots of the root partition.  It
> adds snapshots every 180 seconds, and removes the oldest snapshots
> based on available disk space.
>
> So far, I haven't encountered a crash.
>
> Since this is my root partition, I'll have to reboot to check for corruption.
>

The partition still mounts, and so far I can access everything I
spot-check, but btrfsck is reporting the following errors:

Checking filesystem on /dev/sda3
UUID: 1050ccb5-58ae-4479-9e12-2230a7b0097a
checking extents
checking free space cache
checking fs roots
checking csums
There are no extents for csum range 2267451392-2267521024
Csum exists for 2267451392-2267521024 but there is no extent record
There are no extents for csum range 10636697600-10636836864
Csum exists for 10636697600-10636836864 but there is no extent record
found 5015120900 bytes used err is 2
total csum bytes: 10233048
total tree bytes: 2166587392
total fs tree bytes: 2043346944
total extent tree bytes: 108380160
btree space waste bytes: 483349153
file data blocks allocated: 93115641856
 referenced 99033673728
Btrfs v3.12
