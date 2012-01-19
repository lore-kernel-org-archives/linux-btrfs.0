From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Btrfsck gives me errors
Date: Thu, 19 Jan 2012 11:59:29 +0700
Message-ID: <CAG1y0sfc1wBHKumrfBsFqT7PM1=tck4YY66czfci-FJyOZq_4A@mail.gmail.com>
References: <CALJXSJo=zh2beZYRkJRVyvM2h0HnGESTDhganDShxpQBspU==w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJo=zh2beZYRkJRVyvM2h0HnGESTDhganDShxpQBspU==w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 19, 2012 at 9:02 AM, J=E9r=F4me Poulin <jeromepoulin@gmail.=
com> wrote:
> I did a preemptive fsck after a RAID crash and got many errors, is
> there something I should do if everything I use works?

Probably just ignore it.

Recent kernels (e.g. 3.1 or 3.2) is smart enough to automatically fix
certain types of errors. Watch syslog when you mount the fs, access
some files, unmount, and mount it again. If second mount does not show
any error message then I'm pretty sure you're safe.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
