From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Can btrfs silently repair read-error in raid1
Date: Tue, 8 May 2012 14:36:47 +0700
Message-ID: <CAG1y0seZD1n5sckdFx=BAJa+KQguKd-Dj9_Ti1EhJRY0bE2B9Q@mail.gmail.com>
References: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 8, 2012 at 2:13 PM, Clemens Eisserer <linuxhippy@gmail.com> wrote:
> Hi,
>
> I have a quite unreliable SSD here which develops some bad blocks from
> time to time which result in read-errors.
> Once the block is written to again, its remapped internally and
> everything is fine again for that block.
>
> Would it be possible to create 2 btrfs partitions on that drive and
> use it in RAID1 - with btrfs silently repairing read-errors when they
> occur?
> Would it require special settings, to not fallback to read-only mode
> when a read-error occurs?

The problem would be how the SSD (and linux) behaves when it
encounters bad blocks (not bad disks, which is easier).

If it does "oh, I can't read this block. I just return an error
immediately", then it's good.

However, in most situation, it would be like "hmmm, I can't read this
block, let me retry that again. What? still error? then lets retry it
again, and again.", which could take several minutes for a single bad
block. And during that time linux (the kernel) would do something like
"hey, the disk is not responding. Why don't we try some stuff? Let's
try resetting the link. If it doesn't work, try downgrading the link
speed".

In short, if you KNOW the SSD is already showing signs of bad blocks,
better just throw it away.

-- 
Fajar
