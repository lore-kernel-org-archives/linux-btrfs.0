From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Btrfsck gives me errors
Date: Thu, 19 Jan 2012 23:24:54 -0500
Message-ID: <CALJXSJpjT1UCto5aojE6QgNPCTi-1U7+csCf6uUFOm7t+GR5Dg@mail.gmail.com>
References: <CALJXSJo=zh2beZYRkJRVyvM2h0HnGESTDhganDShxpQBspU==w@mail.gmail.com>
	<CAG1y0sfc1wBHKumrfBsFqT7PM1=tck4YY66czfci-FJyOZq_4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfc1wBHKumrfBsFqT7PM1=tck4YY66czfci-FJyOZq_4A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2012 at 11:59 PM, Fajar A. Nugraha <list@fajar.net> wrote:
> Recent kernels (e.g. 3.1 or 3.2) is smart enough to automatically fix
> certain types of errors. Watch syslog when you mount the fs, access
> some files, unmount, and mount it again. If second mount does not show
> any error message then I'm pretty sure you're safe.

I just upgraded from 3.0 to 3.2.1 and mounted the filesystem, tried
find > /dev/null and only got messages about old space inode. I then
used btrfsck again for the same exact result, I'll ignore them for
now, let's see what the shiny new btrfsck will do about them!
