From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Compression: per filesystem, or per subvolume?
Date: Tue, 10 May 2011 16:51:34 +0700
Message-ID: <BANLkTinDYX_twMsEDg0QgRrVmKKY_YDm+g@mail.gmail.com>
References: <BANLkTimwMnmS4jw=uwimm8b18662jO-Myw@mail.gmail.com>
	<BANLkTikS522HZBv+05md-okRey37aZd6gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikS522HZBv+05md-okRey37aZd6gA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 8, 2011 at 8:38 PM, cwillu <cwillu@gmail.com> wrote:
> It's by not-implemented-yet.=A0 Mount options are still currently glo=
bal to
> the filesystem.

Thanks for the info. I was testing combination of grub2, btrfs "/"
without separate /boot, and lzo. Using lzo feels much faster compared
to zlib, so right now I just use separate /boot/grub in ext4 to make
it work correctly.

--=20
=46ajar

>
> On May 8, 2011 7:35 AM, "Fajar A. Nugraha" <list@fajar.net> wrote:
>> Currently using Ubuntu Natty, kernel 2.6.38-9-generic, I have these
>> mount points using btrs subvolumes
>>
>> $ mount -t btrfs
>> /dev/sda2 on / type btrfs (rw,noatime,subvolid=3D256,compress-force=3D=
zlib)
>> /dev/sda2 on /home type btrfs (rw,noatime,subvolid=3D258,compress=3D=
lzo)
>>
>> Yet dmesg seems to show only zlib compression enabled
>> $ dmesg | grep btrfs
>> [ 11.097908] btrfs: force zlib compression
>>
>> Is this by design, or a bug?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
