Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33562 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932679AbdC2XUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 19:20:54 -0400
Received: by mail-vk0-f42.google.com with SMTP id d188so35876929vka.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 16:20:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170329215554.GT11714@carfax.org.uk>
References: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
 <20170329215554.GT11714@carfax.org.uk>
From: Tim Cuthbertson <ratcheer@gmail.com>
Date: Wed, 29 Mar 2017 18:20:52 -0500
Message-ID: <CAAKzf7n=e9Onnc5D-U_zBtXXpFk11QiN7RhisqAB5Ej0DQOcfA@mail.gmail.com>
Subject: Fwd: Confusion about snapshots containers
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---------- Forwarded message ----------
From: Hugo Mills <hugo@carfax.org.uk>
Date: Wed, Mar 29, 2017 at 4:55 PM
Subject: Re: Confusion about snapshots containers
To: Tim Cuthbertson <ratcheer@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>


On Wed, Mar 29, 2017 at 04:27:30PM -0500, Tim Cuthbertson wrote:
> I have recently switched from multiple partitions with multiple
> btrfs's to a flat layout. I will try to keep my question concise.
>
> I am confused as to whether a snapshots container should be a normal
> directory or a mountable subvolume. I do not understand how it can be
> a normal directory while being at the same level as, for example, a
> rootfs subvolume. This is with the understanding that the rootfs is
> NOT at the btrfs top level.
>
> Which should it be, a normal directory or a mountable subvolume
> directly under btrfs top level? If either way can work, what are the
> pros and cons of each?

   The current best practice recommendation is that it should be a
normal directory, not contained within any of the subvolumes that are
being snapshotted. So (using the @-prefix convention to indicate a
subvol), you'd have something like this:

<top-level>
   @root
   @home
   snapshots
      root
         @2017-03-28
         @2017-03-29
      home
         @2017-03-28
         @2017-03-29

   To use this, mount the top level of the FS (-o subvolid=0) on a
known path, such as /media/btrfs/<fslabel>/, and do the subvol
management, and nothing else, under that mount.

(Optionally, you can flatten the dir hierarchy to
/snapshots/@root-2017-03-28, but I prefer the slightly deeper version
above).

   The snapshots container can be either a dir or a subvol, but you
gain almost nothing from it being a subvol, and you lose the ability
to move subvols/snapshots in and out of it cheaply with mv. Hence the
recommendation to use a directory.

   Hugo.

--
Hugo Mills             | O tempura! O moresushi!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |


Thank you Hugo. That seems to work.

So, another question...

Do I then leave the top level mounted all the time for snapshots, or
should I create them, send them to external storage, and umount until
next time?
