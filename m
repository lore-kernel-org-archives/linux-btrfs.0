From: Bob Copeland <me@bobcopeland.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Fri, 23 Jul 2010 07:14:55 -0400
Message-ID: <AANLkTi=ffOv44xziJHTBX0LCUWXqdku30NiHqyTW=AGK@mail.gmail.com>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
	<201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
	<4C44066A.3080701@cn.fujitsu.com>
	<201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	zheng.yan@oracle.com, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201007222007.24574.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 22, 2010 at 2:07 PM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
>> Is there anything wrong with your disks or memory?
>> Sometimes the bad memory can break the filesystem. I have met this kind of
>> problem some time ago.
>
> I don't think that's the case. I've checked the RAM with memtest86+ and got no
> errors. I got the errors with two different disks, the first one with btrfs the
> second one now with XFS. Before changing to the second disk, I've run
> badblocks on it to be sure it has no errors.

You might also try kmemcheck.  There's a good chance that a bug
that scribbles random memory shows up as FS corruption.  I have had
ext4 corruption due to an inotify bug, which kmemcheck found on the
first try.

-- 
Bob Copeland %% www.bobcopeland.com
