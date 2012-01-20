From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Btrfsck gives me errors
Date: Fri, 20 Jan 2012 14:19:13 +0700
Message-ID: <CAG1y0sdDfFFuG0sSZHzkYmhGMCugXeN8PT33k8i02Zhnuj1-qg@mail.gmail.com>
References: <CALJXSJo=zh2beZYRkJRVyvM2h0HnGESTDhganDShxpQBspU==w@mail.gmail.com>
	<CAG1y0sfc1wBHKumrfBsFqT7PM1=tck4YY66czfci-FJyOZq_4A@mail.gmail.com>
	<CALJXSJpjT1UCto5aojE6QgNPCTi-1U7+csCf6uUFOm7t+GR5Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJpjT1UCto5aojE6QgNPCTi-1U7+csCf6uUFOm7t+GR5Dg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2012 at 11:24 AM, J=E9r=F4me Poulin <jeromepoulin@gmail=
=2Ecom> wrote:
> On Wed, Jan 18, 2012 at 11:59 PM, Fajar A. Nugraha <list@fajar.net> w=
rote:
>> some files, unmount, and mount it again. If second mount does not sh=
ow
>> any error message then I'm pretty sure you're safe.
>
> I just upgraded from 3.0 to 3.2.1 and mounted the filesystem, tried
> find > /dev/null and only got messages about old space inode.

That's normal. You'll also get the message if you switch back to 3.0,
but it should be harmless.

> I then
> used btrfsck again for the same exact result, I'll ignore them for
> now, let's see what the shiny new btrfsck will do about them!

who knows when it will be available :)

Then again, most fsck feature has been implemented in kernel space so
a mount will automatically "fix" some types of problems (somewhat
similar to what zfs does, which has no fsck whatsoever). So just watch
syslog for any unusual error messages.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
