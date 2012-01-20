From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Btrfsck gives me errors
Date: Fri, 20 Jan 2012 08:38:05 -0500
Message-ID: <CALJXSJoCGQNAX8zJx6vkPkQyQo4QzriL0eNrMF11NbzVO=NBtg@mail.gmail.com>
References: <CALJXSJo=zh2beZYRkJRVyvM2h0HnGESTDhganDShxpQBspU==w@mail.gmail.com>
	<CAG1y0sfc1wBHKumrfBsFqT7PM1=tck4YY66czfci-FJyOZq_4A@mail.gmail.com>
	<CALJXSJpjT1UCto5aojE6QgNPCTi-1U7+csCf6uUFOm7t+GR5Dg@mail.gmail.com>
	<CAG1y0sdDfFFuG0sSZHzkYmhGMCugXeN8PT33k8i02Zhnuj1-qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdDfFFuG0sSZHzkYmhGMCugXeN8PT33k8i02Zhnuj1-qg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2012 at 2:19 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> Then again, most fsck feature has been implemented in kernel space so
> a mount will automatically "fix" some types of problems (somewhat
> similar to what zfs does, which has no fsck whatsoever). So just watch
> syslog for any unusual error messages.

However it has a way to be fully backed up without losing space which
have been saved using snapshot and reflinks. Right now, this is not
production critical data, so I've got backups only of files I think
are critical to me, not reflinks and snapshots.
