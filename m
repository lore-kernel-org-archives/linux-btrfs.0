From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Can btrfs silently repair read-error in raid1
Date: Tue, 08 May 2012 09:26:53 +0200
Message-ID: <4FA8CABD.5050006@jan-o-sch.net>
References: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2012 at 09:13 (+0200), Clemens Eisserer wrote:
> Would it be possible to create 2 btrfs partitions on that drive and
> use it in RAID1 - with btrfs silently repairing read-errors when they
> occur?
> Would it require special settings, to not fallback to read-only mode
> when a read-error occurs?

No special settings required, that's exactly what btrfs is doing by
default. Though, it's not completely silent: it will tell you in your
kernel log about the repair it did.

-Jan
