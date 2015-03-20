Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33465 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbCTDEn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 23:04:43 -0400
Received: by yhpt93 with SMTP id t93so34254634yhp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 20:04:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550B8732.5000302@comcast.net>
References: <550B5C63.6010401@comcast.net>
	<CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
	<550B7CAC.6030005@comcast.net>
	<CAJCQCtTO89u8203U+Oc_eyUbEDrT4YZU8xf1gG6omGWS0ehhSQ@mail.gmail.com>
	<550B8732.5000302@comcast.net>
Date: Thu, 19 Mar 2015 21:04:42 -0600
Message-ID: <CAJCQCtScEOoxXioAT3eotyMfwObbCJiV5yK47m0PmYV8M9Fn5A@mail.gmail.com>
Subject: Re: nube trying to backup my systems
From: Chris Murphy <lists@colorremedies.com>
To: don fisher <hdf3@comcast.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 8:34 PM, don fisher <hdf3@comcast.net> wrote:

> Thanks. I will try that. How does the mount distinguish between /srv and
> /usr11/srv if the subvol=srv is the same for both? It appears to work, for
> when I do a df the sizes are different. I guess it can tell from the UUID of
> / as opposed to that of /usr11.

Yes, by fs volume UUID, it can differentiate between two subvolumes
with the same name. But also by /dev/ if you use mount directly. A
given volume can only have on srv subvolume. It could also have
srv/srv and srv/srv/srv but it'll only have one of each of those.

I missed that one completely.
>
> /dev/sdc2       20972544   6117628  14641012  30% /srv
> /dev/sdb2       20972544   9492892  11112580  47% /usr11/srv
>
> I would still like to know why we need to mount the subvolumes at all.

That's openSUSE's design for snapshots and rollbacks with snapper. For
your backup purpose, you can just mount the top level and not mount
the subvolumes individually, and your rsync will work fine. It will
copy the right files to the right subvolumes by virtue of them being
treated like directories. It's just that rsync can't create subvolumes
(yet) so if you want an exact duplicate of an openSUSE install, you
have to create the subvolumes in advance of rsync.

> tried to dismount one of the subvolumes mounted on / and got a:
>
> umount: /var/log: target is busy

Can't tell you what's going on. Reproduce this error and provide the
current output from df and mount at the time.

>
> message, so could not test to /var/log access without a mount. It is easy to
> access /usr11/var/log without it being mounted. Again, why mount it?

Because the snapshots of root have an empty /var/log. To facilitate
rollback, the static /etc/fstab always mounts these subvolumes in case
the root is a rolled back snapshot.

 I
> understood mounting partitions, because that was the only access. But the
> appears to be two access channels here.

Yes they are effectively bind mounts. You don't need to do this with
your backup.

-- 
Chris Murphy
