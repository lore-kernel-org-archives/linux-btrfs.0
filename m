Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38712 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3K0LUP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 06:20:15 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so3122586bkz.39
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 03:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131127005126.GC10988@dastard>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com> <20131127005126.GC10988@dastard>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 27 Nov 2013 12:19:54 +0100
Message-ID: <CAG-2HqW58GNmgviV6H_JMYp1gHXXWm+7hbs65jaMVsY5dv6nXg@mail.gmail.com>
Subject: Re: missing /sbin/fsck.btrfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 27, 2013 at 1:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 25, 2013 at 11:40:49PM -0700, Chris Murphy wrote:
>> Hi,
>>
>> Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful
>> of threads indicating some idea of having it just do a no-op like
>> fsck.xfs does, but then also the idea that /etc/fstab should
>> correctly set fs_passno to 0 instead of such trickery.
>
> You're missing a key thing that fsck.xfs does that fstab expects to
> work - it fails with an error if the device is missing. If the
> device is present, then fsck.xfs returns success.
>
> We did this because people were having problems when devices took a
> long time to instantiate (e.g. SAN, iscsi and other remote devices)
> and the 'device exists' check prevents /etc/fstab trying to mount
> the filesystems before they are present and then throwing a hissy
> fit....

Note that this kind of stuff should no longer be necessary, at least
if you use systemd (or I suppose Upstrat, but I didn't check):
Filesystems will only be mounted after their backing devices appear.

Cheers,

Tom
