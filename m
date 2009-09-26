From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: user transactions and ENOSPC...
Date: Sat, 26 Sep 2009 15:08:10 +0100
Message-ID: <6278d2220909260708w49d8b948t72a4bd4eefc88d31@mail.gmail.com>
References: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 10:10 PM, Sage Weil <sage@newdream.net> wrote:
> So, the btrfs user transaction ioctls work like so
>
> =A0ioctl(fd, BTRFS_IOC_TRANS_START);
> =A0/* do many operations: write(), setxattr(), rmdir(), whatever. */
> =A0ioctl(fd, BTRFS_IOC_TRANS_END); =A0 =A0/* or close(fd); */
=2E..
> The second problem is that the application may die between START and
> END. The current ioctls are "safe" in that the transaction handle is
> closed when the struct file is released, so the fs won't get wedged i=
f
> you say segfault. =A0On the other hand, they're "unsafe" in that a pr=
ocess
> that is killed or segfaults will result in an imcomplete transaction
> making it to disk, which leaves the file system in an inconsistent st=
ate
> (from the point of view of the application).

With COW, where a transaction is incomplete due to application exit
without closing the transaction, is there a way to drop the
reference/'deallocate' the new tree nodes, thus moving back to the
prior state? Presumably the new tree nodes would get linked in when
the transaction is closed.
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
