Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46447 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2GZWBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 18:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120726210925.GD17928@shiny>
References: <20120726210925.GD17928@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2012 15:01:15 -0700
Message-ID: <CA+55aFyY-wVYZYp=m3YpUi-tf0ctHPTu9rrei21VOaf2aVroLQ@mail.gmail.com>
Subject: Re: [GIT PULL] a large btrfs update
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2012 at 2:09 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> for-linus-merged has an extra commit on top as well that changes the
> btrfs send/receive code to Al's new dentry_open.  It's a small commit,
> and my guess is that you'll cherry pick it and do your own merge.

Indeed. And I dd the semantic merge differently from what you had
done, more like what Al did for XFS in commit 765927b2d508 (see the
fairly equivalent case in fs/xfs/xfs_ioctl.c).

IOW, instead of doing the unnecessary mntget() (and then undoing it
with the path_put()), I just let dentry_open() get the references it
needs, and then just dput() the dentry in the caller (to match the
dget() done by d_obtain_alias()). No need to mess with the mnt
refcounts, since dentry_open() will get whatever refcount it needs.

But while it compiles, I haven't actually *tested* the btrfs
BTRFS_IOC_SEND send/receive path, so please do double-check my merge.

                Linus
