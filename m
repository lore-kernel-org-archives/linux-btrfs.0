From: Chris Samuel <chris@csamuel.org>
Subject: Re: Can btrfs silently repair read-error in raid1
Date: Wed, 09 May 2012 09:34:22 +1000
Message-ID: <4FA9AD7E.6010503@csamuel.org>
References: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/05/12 17:13, Clemens Eisserer wrote:

> Would it be possible to create 2 btrfs partitions on that drive and
> use it in RAID1 - with btrfs silently repairing read-errors when they
> occur?

You can, I tried that in 2009:

http://www.csamuel.org/2009/01/04/btrfs-raid1-benchmark-on-dell-e4200-with-128gb-ssd

But as Chris Mason pointed out on list at that time, it doesn't
necessarily mean you're any safer due to the way that FTL's work:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/2575

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
