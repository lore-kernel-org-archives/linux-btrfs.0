From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Copy/move btrfs volume
Date: Thu, 1 Jul 2010 12:26:10 +0100
Message-ID: <AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com>
References: <i0hqkk$r4h$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i0hqkk$r4h$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 1 July 2010 11:28, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> Hello,
>
> I am testing btrfs on one of our backup servers
> (many millions of files, 1.5TB size, running on (non-btrfs-provided-)
> raid5).
>
> I am using subvolumes/snapshots with following rsync.
>
> It works very well, but I would like to ask a question... say I would need
> to copy/move the files to different server/disk.
>
> Normally I would do it with rsync, but I guess it will not preserve the
> subvolumes, it will also not detect that they are the same files (I guess
> they are not just normal hardlinks). So I would end up with duplicated
> files.
>
> What is the correct way to do this?

The only way to do this preserving duplication is to use hardlinks
between duplicated files (which reference counts the inode), and use
'rsync -H'.

Dan
-- 
Daniel J Blueman
