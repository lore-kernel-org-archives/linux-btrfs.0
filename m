From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Tue, 30 Nov 2010 11:12:17 -0600
Message-ID: <AANLkTimcGV1GdPZcuya3MwFbkkhwRyj5MdEvY1fAmCWu@mail.gmail.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
	<AANLkTin4VPOXBOU9fM5CVqSSnwMMrUCoDqoYu5mKWXLL@mail.gmail.com>
	<4CF44C95.6020908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF44C95.6020908@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 7:00 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> C Anthony Risinger wrote:
>> On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrot=
e:
>>>
>>> You can pull from:
>>>
>>> =A0 =A0 =A0 =A0git://repo.or.cz/linux-btrfs-devel.git lzo-support
>>>
>>>
>>> Lzo is a much faster compression algorithm than gzib, so would allo=
w
>>> more users to enable transparent compression, and some users can
>>> choose from compression ratio and compression speed.
>>
>> is this in a branch somewhere? =A0or for inclusion in .37/.38? =A0th=
is is
>> a very attractive feature.
>>
>> what's the proper place (repo/branch) to see what is pending?
>
> As a new feature, it's too late for .37. Hope to see it merged in .38
> merge window.

:-(

yeah i thought it was already too late for .37, but i'd love to see
this for .38... should add even more kick to my eee s101 netbook.

> Chris' btrfs-unstable git tree is the "official" place to see what is
> pending, but just he hasn't picked up those patches, so for now it
> only sits in my own tree.

i knew about Chris' tree, i probably should have been more clear;
instead of "pending" i should have said "awaiting review", ie. is
there a repo Chris or someone else keeps with all the potential
patches (such as this, or the recent readonly ones, etc.)?

i keep a pretty good eye on the list, but i thought maybe someone
already had a nice central point to see these "up and coming" patches
that aren't necessarily "pending" for mainline yet.

thanks Li,

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
