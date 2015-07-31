Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36777 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbGaMkO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 08:40:14 -0400
Received: by wicgj17 with SMTP id gj17so16088057wic.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2015 05:40:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$92f7f$b783d193$6a4f2413$86168ab3@cox.net>
References: <1437763277.673610371@apps.rackspace.com>
	<55B54568.5060902@googlemail.com>
	<pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
	<CAGfcS_=Z=bRzMvFBDeYQDU8Vxa2UVha44nWogjQ_-_irrZD1xQ@mail.gmail.com>
	<pan$92f7f$b783d193$6a4f2413$86168ab3@cox.net>
Date: Fri, 31 Jul 2015 14:40:12 +0200
Message-ID: <CAEAFGC_VKQLS7cT86YCDwTcg+eU0pWvaYbzL0nEm2VkMsANoHg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_systemd_=3A_Timed_out_waiting_for_defice_dev=2Ddisk=2D?=
	=?UTF-8?Q?by=E2=80=A6?=
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 31, 2015 at 10:44 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> For the specific case of systemd giving up on many-device btrfs mounts,
> now that I've read a bit more and am thinking in terms of dropins, I'd
> guess the following option, covered in systemd.mount and to be placed in
> the mount section with an appropriate value, should do it:
>
> TimeoutSec=
>
> The default timeoutsec setting is set in /etc/systemd/systemd.conf
> (systemd-system.conf manpage) as DefaultTimeoutStartSec=, with 90 seconds
> the shipped default if it's not set there.  Without a specific setting in
> the unit file, that system default would be used.

I'l like to stress the fact that all those timeouts were well beyond
the time it took to mount the btrfs raid manually (when it happened to
me, a long time ago - might be a different story for Vincent).
Mounting it manually did take a couple of seconds, but less then 10
seconds, which isn't even close to 30, let alone 90 seconds.
In fact, I believe it was less than 5 seconds and as far as I
remember, the fs would sometimes even be mounted for this very short
time and then (after those few seconds) systemd would unmount it.
This is something that doesn't add up in my mind, because all those
default timeout values look okay to me, but somehow, mounts appear to
time out before the time is actually up. In other words - I have never
waited 30 seconds or longer for a btrfs mount to complete, yet I
apparently hit a 90 second timeout if TimeoutSec was the culprit.

(However, again, this was my case - not sure if Vincent may be hitting
a different issue.)
