From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Wed, 01 Dec 2010 09:02:55 +0800
Message-ID: <4CF59EBF.1020606@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>	<AANLkTin4VPOXBOU9fM5CVqSSnwMMrUCoDqoYu5mKWXLL@mail.gmail.com>	<4CF44C95.6020908@cn.fujitsu.com> <AANLkTimcGV1GdPZcuya3MwFbkkhwRyj5MdEvY1fAmCWu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimcGV1GdPZcuya3MwFbkkhwRyj5MdEvY1fAmCWu@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

C Anthony Risinger wrote:
> On Mon, Nov 29, 2010 at 7:00 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> C Anthony Risinger wrote:
>>> On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>> You can pull from:
>>>>
>>>>        git://repo.or.cz/linux-btrfs-devel.git lzo-support
>>>>
>>>>
>>>> Lzo is a much faster compression algorithm than gzib, so would allow
>>>> more users to enable transparent compression, and some users can
>>>> choose from compression ratio and compression speed.
>>> is this in a branch somewhere?  or for inclusion in .37/.38?  this is
>>> a very attractive feature.
>>>
>>> what's the proper place (repo/branch) to see what is pending?
>> As a new feature, it's too late for .37. Hope to see it merged in .38
>> merge window.
> 
> :-(
> 
> yeah i thought it was already too late for .37, but i'd love to see
> this for .38... should add even more kick to my eee s101 netbook.
> 
>> Chris' btrfs-unstable git tree is the "official" place to see what is
>> pending, but just he hasn't picked up those patches, so for now it
>> only sits in my own tree.
> 
> i knew about Chris' tree, i probably should have been more clear;
> instead of "pending" i should have said "awaiting review", ie. is
> there a repo Chris or someone else keeps with all the potential
> patches (such as this, or the recent readonly ones, etc.)?
> 

Unfortunately no..

> i keep a pretty good eye on the list, but i thought maybe someone
> already had a nice central point to see these "up and coming" patches
> that aren't necessarily "pending" for mainline yet.
> 

But btrfs-unstable tree should have acted as this role. We put those patches
that are ready for next release in different branches in that tree,
and merge them into master branch later. And add that tree into linux-next
for wider testing..
