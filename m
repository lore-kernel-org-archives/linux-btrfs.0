From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to
	read the system array on sda"
Date: Sun, 24 Jan 2010 08:46:14 -0800
Message-ID: <c67eed301001240846y74ec4cdajdf2b07934782eaae@mail.gmail.com>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
	 <201001240902.38535.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001240902.38535.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

hi

On Sun, Jan 24, 2010 at 12:02 AM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> On Sunday 24 January 2010, 0bo0 wrote:
>> after a simple reboot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^
> Have you do
>
> =A0# btrfsctl -a
>
> before mounting the filesystem ? This command scans all the block dev=
ices
> searching the btrfs volume. So when you mount a device of an array th=
e system
> is able to retrieves the others.

that does the trick!  and, i found/understood the reference in tthe
wiki. thanks.

how would that, then, get handled for automount @ boot via fstab?  i
guess that the scan needs to get done as well ...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
