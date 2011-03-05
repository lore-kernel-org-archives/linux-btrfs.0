From: cwillu <cwillu@cwillu.com>
Subject: Re: BTRFS fsck tool
Date: Fri, 4 Mar 2011 21:00:31 -0600
Message-ID: <AANLkTimLvU4+1s1pMCJ_ysmFp9=k3zOhJ++KHVWfrC0Y@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
	<AANLkTin=2=bhmdzUHV-poMwEx9et6y2m3OSba-1Rc9=v@mail.gmail.com>
	<AANLkTim7q=xxPH_OoEu9HW9_RAXgD=-XdS3BHoHm0wNv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexey A Nikitin <moonwalker@syrius.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim7q=xxPH_OoEu9HW9_RAXgD=-XdS3BHoHm0wNv@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2011 at 7:20 PM, Alexey A Nikitin <moonwalker@syrius.us> wrote:
> I pulled the btrfs-select-super source from get branch 'next',
> compiled it, but when I run it using
>
> ./btrfs-select-super -s 1 /dev/sdb1
>
> all I get is
>
> btrfs-select-super: disk-io.c:739: open_ctree_fd: Assertion
> `!(!tree_root->node)' failed
>
> Any ideas what might be wrong and how I can remedy it? I'm using
> Debian Wheezy x64 with it's own btrfs-tools, could that be a problem,
> should I completely replace stock btrfs-tools with the one from git
> for it to work properly?

Make sure you run it as root, and try both -s 1 and -s 2.

> PS: I subscribed to this list now, so there is no more need to cc me.

Reply to all does it automatically.
