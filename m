From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Wed, 9 Nov 2011 01:53:15 -0500
Message-ID: <CAPL5yKfHjzeP_8gV9WMwY=SrA23wMWGJNnPH5cYNeZsoNQ3zpA@mail.gmail.com>
References: <20111106183851.GA4339@shiny>
	<CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
	<20111108182728.GR4954@shiny>
	<20111108201753.GA4149@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Dan Merillat <dan.merillat@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-ke
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108201753.GA4149@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 8, 2011 at 3:17 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Tue, Nov 08, 2011 at 01:27:28PM -0500, Chris Mason wrote:
>> On Tue, Nov 08, 2011 at 12:55:40PM -0500, Dan Merillat wrote:
>> > On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.co=
m> wrote:
>> > > Hi everyone,
>> > >
>> > > This pull request is pretty beefy, it ended up merging a number =
of long
>> > > running projects and cleanup queues. =A0I've got btrfs patches i=
n the new
>> > > kernel.org btrfs repo. =A0There are two different branches with =
the same
>> > > changes. =A0for-linus is against 3.1 and has also been tested ag=
ainst
>> > > Linus' tree as of yesterday.
>> >
>> > [91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
>> > [91795.123538] btrfs: open_ctree failed
>> >
>> > FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
>> > whenI tried to mount on 3.1 (x64) again. =A0Format change in 3.2 o=
r
>> > 32/64 bit compatibility issues?
>>
>> I'm trying to reproduce right now but I did many bounces between 3.2=
 and
>> 3.1 code before releasing. =A0I didn't try jumping between 32 and 64=
 bit.
>>
>> Are there any other messages in dmesg? =A0Could you please see what
>> btrfs-debug-tree says?
>
> Ok, so I spun the wheel going between 32 and 64 and 3.1 and 3.2. =A0I=
'm
> not having trouble with basic tests.
>
> So, we'll have to dig in and see why the open is failing. =A0btrfsck =
or
> btrfs-debug-tree will help.

This is on a USB device, however I had used the filesystem quite a bit
on the 64bit machine before moving it to the 32bit 3.2 box.   It's
still mountable on the 32bit box even when I get the open_ctree failed
on 3.1

[140865.425067] device label ROOT devid 1 transid 3436 /dev/sdi2
[140865.426291] btrfs: open_ctree failed
harik@fileserver:~/src/3.0/3.2-rc1$ sudo btrfsck /dev/sdi2
[sudo] password for harik:
found 3105894400 bytes used err is 0
total csum bytes: 2916272
total tree bytes: 119631872
total fs tree bytes: 109928448
btree space waste bytes: 33045213
file data blocks allocated: 5391962112
 referenced 2984988672
Btrfs Btrfs v0.19

http://dl.dropbox.com/u/1071112/btrfs-debug-tree.sdi2.bz2

Exact kernel that won't mount is linus 3.1 +
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Aug 3 11:08:02 2011 -0700
    btrfs: allow cross-subvolume file clone

Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Fri Sep 2 15:56:25 2011 +0800

    Btrfs: fix defragmentation regression
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
