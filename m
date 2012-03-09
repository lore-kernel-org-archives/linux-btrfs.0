From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 9 Mar 2012 12:08:12 +0100
Message-ID: <CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Liu Bo <liubo2009@cn.fujitsu.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120309105537.GG4334@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/9 David Sterba <dave@jikos.cz>:
> On Fri, Mar 09, 2012 at 09:31:25AM +0800, Liu Bo wrote:
>> > There were quite many things happening in the system at that time.
>> > Can't really tell what could trigger this.
>> >
>> > Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz
>> >
>> So are these warnings based on the latest upstream of btrfs?
>
> No, from the log it's 3.2.7, so it does not conain the patch
>
> "increase the global block reserve estimates"
>
> the log shows lots of messages
>
> Mar =A08 13:36:37 kernel: use_block_rsv: 7 callbacks suppressed
> Mar =A08 13:36:37 kernel: ------------[ cut here ]------------
> Mar =A08 13:36:37 kernel: WARNING: at fs/btrfs/extent-tree.c:5985 btr=
fs_alloc_free_block+0xc5/0x292 [btrfs]()
> ...
> Mar =A08 13:36:37 kernel: =A0[<ffffffffa031161f>] ? btrfs_alloc_free_=
block+0xc5/0x292 [btrfs]
> Mar =A08 13:36:37 kernel: =A0[<ffffffff8106901d>] ? warn_slowpath_com=
mon+0x78/0x8d
> Mar =A08 13:36:37 kernel: =A0[<ffffffffa031161f>] ? btrfs_alloc_free_=
block+0xc5/0x292 [btrfs]
> Mar =A08 13:36:37 kernel: =A0[<ffffffffa032bbad>] ? btrfs_item_offset=
+0x2c/0x61 [btrfs]
> Mar =A08 13:36:37 kernel: =A0[<ffffffffa03007dc>] ? leaf_space_used+0=
x86/0xb5 [btrfs]
> Mar =A08 13:36:39 kernel: =A0[<ffffffffa0304a7a>] ? split_leaf+0x2d9/=
0x632 [btrfs]
> Mar =A08 13:36:39 kernel: =A0[<ffffffffa0306261>] ? btrfs_search_slot=
+0x6c1/0x75a [btrfs]
> Mar =A08 13:36:40 kernel: =A0[<ffffffffa0306e6e>] ? btrfs_insert_empt=
y_items+0x61/0xab [btrfs]
> Mar =A08 13:36:41 kernel: =A0[<ffffffffa032207c>] ? insert_inline_ext=
ent+0xea/0x2d4 [btrfs]
> Mar =A08 13:36:41 kernel: =A0[<ffffffffa0322389>] ? cow_file_range_in=
line+0x123/0x163 [btrfs]
> ...

=46or this one I've created also a report [1].

>
> so there is probably other problem in reservations and it just blew u=
p during
> the unlink call.

Could be as this came up after a longer time of throwing above WARN_ON.

I'm now cloning the Linus tree. Lets see if both will pop up on there.

-Jacek

[1] http://www.spinics.net/lists/linux-btrfs/msg15404.html
