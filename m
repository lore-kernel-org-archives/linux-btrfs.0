From: cwillu <cwillu@cwillu.com>
Subject: Re: BTRFS fsck tool
Date: Fri, 4 Mar 2011 18:05:35 -0600
Message-ID: <AANLkTin=2=bhmdzUHV-poMwEx9et6y2m3OSba-1Rc9=v@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexey A Nikitin <moonwalker@syrius.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2011 at 5:59 PM, Alexey A Nikitin <moonwalker@syrius.us> wrote:
> I have BTRFS RAID0 setup with two disks. After some incident where I
> had to force shutdown machine this array won't mount anymore, even
> after "btrfs device scan". Unfortunately, I don't have backups since I
> can't afford another 4TB of storage. I've read that fsck tool for
> BTRFS that is expected to be released soon should allow recovery from
> this situation, but I can't find info as to where I may find the
> up-to-date release announcements so that I can download it when it's
> out. Can somebody tell me how I can keep track of fsck development
> status?

I'd expect an announcement on this mailing list.

Depending on why it doesn't mount, there's a btrfs-select-super
command in btrfs-progs which may get you up and running again.
