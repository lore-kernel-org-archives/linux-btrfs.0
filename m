From: Alexey A Nikitin <moonwalker@syrius.us>
Subject: Re: BTRFS fsck tool
Date: Fri, 4 Mar 2011 19:20:52 -0600
Message-ID: <AANLkTim7q=xxPH_OoEu9HW9_RAXgD=-XdS3BHoHm0wNv@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <AANLkTin=2=bhmdzUHV-poMwEx9et6y2m3OSba-1Rc9=v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=2=bhmdzUHV-poMwEx9et6y2m3OSba-1Rc9=v@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I pulled the btrfs-select-super source from get branch 'next',
compiled it, but when I run it using

./btrfs-select-super -s 1 /dev/sdb1

all I get is

btrfs-select-super: disk-io.c:739: open_ctree_fd: Assertion
`!(!tree_root->node)' failed

Any ideas what might be wrong and how I can remedy it? I'm using
Debian Wheezy x64 with it's own btrfs-tools, could that be a problem,
should I completely replace stock btrfs-tools with the one from git
for it to work properly?

PS: I subscribed to this list now, so there is no more need to cc me.

Best,

Alexey

--
This message was created with 100% recycled electrons



2011/3/4 cwillu <cwillu@cwillu.com>:
> On Fri, Mar 4, 2011 at 5:59 PM, Alexey A Nikitin <moonwalker@syrius.us> wrote:
>> I have BTRFS RAID0 setup with two disks. After some incident where I
>> had to force shutdown machine this array won't mount anymore, even
>> after "btrfs device scan". Unfortunately, I don't have backups since I
>> can't afford another 4TB of storage. I've read that fsck tool for
>> BTRFS that is expected to be released soon should allow recovery from
>> this situation, but I can't find info as to where I may find the
>> up-to-date release announcements so that I can download it when it's
>> out. Can somebody tell me how I can keep track of fsck development
>> status?
>
> I'd expect an announcement on this mailing list.
>
> Depending on why it doesn't mount, there's a btrfs-select-super
> command in btrfs-progs which may get you up and running again.
>
