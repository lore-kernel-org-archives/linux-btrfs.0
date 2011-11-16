From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/btrfs/inode.c:1587
Date: Wed, 16 Nov 2011 09:16:03 -0500
Message-ID: <20111116141603.GO29279@shiny>
References: <CAO47_--H0+6bu4qQ2QA9gZcHvGVWO4QUGCAb3+9a5Kg3+23UiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--H0+6bu4qQ2QA9gZcHvGVWO4QUGCAb3+9a5Kg3+23UiQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2011 at 09:19:53AM +0100, Christian Brunner wrote:
> Hi,
> 
> this time I've hit a new bug. This happened while ceph was rebuilding
> his filestore (heavy io).
> 
> The btrfs version is from 3.2-rc1, applied to a 3.0 kernel.

This one means some part of the kernel has set a btrfs data page dirty
without going through the proper setup.  A few of us have hit it, but we
haven't been able to nail down a solid way to reproduce it.

Have you hit it more than once?

-chris
