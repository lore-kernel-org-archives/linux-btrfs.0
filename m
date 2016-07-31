Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33285 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbcGaKXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 06:23:48 -0400
Received: by mail-lf0-f47.google.com with SMTP id b199so97723916lfe.0
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 03:23:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$5fb1f$7ade4380$d83d2847$ba15621a@cox.net>
References: <CA+xOVSOx56oc5kF+oj18B3m23wcpy2OqbKbH9j13se+s98YvdQ@mail.gmail.com>
 <pan$5fb1f$7ade4380$d83d2847$ba15621a@cox.net>
From: Mordechay Kaganer <mkaganer@gmail.com>
Date: Sun, 31 Jul 2016 13:23:31 +0300
Message-ID: <CA+xOVSMP_ZXCoyRWL5KaDvkdPJHYtLd9f9GgD-y55=cppENLhA@mail.gmail.com>
Subject: Re: BTRFS: Transaction aborted (error -28)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Thanks for the detailed answer!

On Fri, Jul 29, 2016 at 8:23 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> ...
> Of course the fact that the transaction aborted /does/ indicate some sort
> of problem, which may in fact have left the filesystem in an unknown
> state.  However, I'd recommend a couple other checks, not balance, to be
> sure you're good.  First, a btrfs scrub of the filesystem, just to be
> sure the checksums all come out fine (or are fixable and fixed if not).
> Second, a btrfs check, which will be read-only unless you add --repair or
> similar option.

OK, scrub finished with 0 errors so I assume the FS is probably in a good shape

Regarding 'btrfs check' - my FS is huge and with a lot of metadata so
btrfs check seems to consume a lot of RAM. I've added all of my system
disk's free space as a swap but the check was killed due to OOM after
consuming about 100GB of memory.

> ...
> So I'd recommend upgrading to the latest kernel 4.4 if you want to stay
> with the stable series, or 4.6 or 4.7 if you want current, and then (less
> important) upgrading the btrfs userspace as well.  It's possible the
> newer kernel will handle the combined rsync and send stresses better, and
> if not, you're on a better base to provide bug reports, etc.

OK, upgraded to 4.4 (Ubuntu 16.04 stock kernel) and the fresh
btrfs-progs 4.7. I'm assuming the error was due to some kind of bug or
race condition and the FS is clean. Let's see how it behaves. Thanks!

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
