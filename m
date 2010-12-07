From: C Anthony Risinger <anthony@extof.me>
Subject: Re: crash when mounting subvolume in a subdirectory
Date: Mon, 6 Dec 2010 19:44:13 -0600
Message-ID: <AANLkTinTLXD4g1mvvhDGAVXEgCsMX8dbh8M6aGGHHab4@mail.gmail.com>
References: <20101206232724.4bf1ebfc@simplux>
	<4CFD9087.5000503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Michael Niederle <mniederle@gmx.at>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CFD9087.5000503@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 7:40 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Michael Niederle wrote:
>> Hi!
>>
>> I'm not sure whether this *should* be possible, but I think it *shouldn't*
>> crash:
>
> It's currently not allowed to mount a subvolume which is not created in
> the root directory of the default subvolume, so you should have failed
> to mount, but you hit a bug..
>
> I've fixed it, and will send out the patch in minutes.

i did the same thing, except for a slightly different reason and
slightly more accidentally on purpose:

http://www.spinics.net/lists/linux-btrfs/msg07190.html

buuuuut, i ended up with a corrupted FS (that i still have a dump of,
happily waiting for a way to mount it... *hint* :-) so if your are
still up and running then luck is on your side, and don't do it again
;-)

C Anthony
