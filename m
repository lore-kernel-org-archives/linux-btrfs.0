From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to
	read the system array on sda"
Date: Mon, 25 Jan 2010 00:35:39 +0100
Message-ID: <23a15591001241535h3768f413iee4bde3214a07bc5@mail.gmail.com>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
	 <201001240902.38535.kreijack@libero.it>
	 <c67eed301001240846y74ec4cdajdf2b07934782eaae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001240846y74ec4cdajdf2b07934782eaae@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2010 at 5:46 PM, 0bo0 <0.bugs.only.0@gmail.com> wrote:
> hi
>
> On Sun, Jan 24, 2010 at 12:02 AM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
>> On Sunday 24 January 2010, 0bo0 wrote:
>>> after a simple reboot,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^
>> Have you do
>>
>> =A0# btrfsctl -a
>>
>> before mounting the filesystem ? This command scans all the block de=
vices
>> searching the btrfs volume. So when you mount a device of an array t=
he system
>> is able to retrieves the others.
>
> that does the trick! =A0and, i found/understood the reference in tthe
> wiki. thanks.
>
> how would that, then, get handled for automount @ boot via fstab? =A0=
i
> guess that the scan needs to get done as well ...
> --

Please see this discussion:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/4126/focus=3D4187
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
