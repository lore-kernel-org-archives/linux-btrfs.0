Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35589 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcEYQQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 12:16:37 -0400
Received: by mail-vk0-f65.google.com with SMTP id e126so8745706vkb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 09:16:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
Date: Wed, 25 May 2016 18:16:35 +0200
Message-ID: <CAPmG0jYr=R-+YEY6nURjDFk7QwZVDSLC0pn8-BF9XvTwy1ZuJQ@mail.gmail.com>
Subject: Re: Copy on write of unmodified data
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 10:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi,
>
> I'm looking at using a btrfs with snapshots to implement a generational
> backup capacity.  However, doing it the naïve way would have the side
> effect that for a file that has been partially modified, after
> snapshotting the file would be written with *mostly* the same data.  How
> does btrfs' COW algorithm deal with that?  If necessary I might want to
> write some smarter user space utilities for this.

Assuming 'snapshots' plural refers incremental snapshots of a
subvolume, you might want to use the send ioctl of the kernel.
Userspace btrfs-progs  btrfs send --no-data  output might give some hints.
