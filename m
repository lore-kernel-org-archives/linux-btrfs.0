From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Kernel BUG unable to handle kernel NULL pointer dereference
Date: Sun, 23 Oct 2011 19:24:42 +0100
Message-ID: <CAAeznTpDmT7NgZdAHh7uVPBnKtitr=SmLRvfFKrd_exG6XLE9w@mail.gmail.com>
References: <CAAeznTqh1W0W743WxTO+iUfajgsMw-A6abwr1fAZ6hWOJOnw2Q@mail.gmail.com>
	<CAKcLGm-+g9xy_aL2Z_F2VYG8qFsXonB7nutM1VSs5sqLZz2PGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-+g9xy_aL2Z_F2VYG8qFsXonB7nutM1VSs5sqLZz2PGA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 23, 2011 at 4:37 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Sat, Oct 22, 2011 at 3:23 PM, Leonidas Spyropoulos
> <artafinde@gmail.com> wrote:
>> Hello, I got a kernel bug error, my guess from BTRFS.
>>
>> Here is the report,
>> Oct 22 20:44:43 localhost kernel: [25554.947970] BUG: unable to hand=
le
>> kernel NULL pointer dereference at 0000000000000030
>> Oct 22 20:44:43 localhost kernel: [25554.948002] IP:
>> [<ffffffffa01ab027>] btrfs_print_leaf+0x37/0x880 [btrfs]
>
> A patch was submitted by Sergei Trofimovich to address the issue with
> handling a NULL pointer in btrfs_print_leaf.
>
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg12021.html
>
> Unfortunately, this usually only crops up when btrfs runs into
> corruptions that it can't handle. =A0So you very likely still have
> problems even if the btrfs_print_leaf issue isn't addressed.
>

So from what I understand btrfs_print_leaf function is called only
when something is wrong and want to print out debug information,
correct?

How can I track down the real problem? Any suggestions?


--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
