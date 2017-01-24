Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36466 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdAXUdL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:33:11 -0500
Received: by mail-yw0-f196.google.com with SMTP id q71so16929893ywg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 12:33:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124202723.GD2853@vader>
References: <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader> <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader> <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 13:33:00 -0700
Message-ID: <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 1:27 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Tue, Jan 24, 2017 at 01:24:51PM -0700, Chris Murphy wrote:
>> On Tue, Jan 24, 2017 at 1:10 PM, Omar Sandoval <osandov@osandov.com> wrote:
>>
>> > Hm, still no luck, maybe it's a Server vs Workstation thing? I'll try
>> > installing Workstation. In the meantime, I noticed that in both of the
>> > traces, systemd-tmpfiles was the process that tripped the WARN_ONCE().
>> > Could you dump the contents of /{etc,run,usr/lib}/tmpfiles.d somewhere?
>>
>> This is just ls -lZ for those directories, not sure how else to dump them.
>>
>> https://drive.google.com/open?id=0B_2Asp8DGjJ9NFJUUUpuV2lxcG8
>
> Sorry, I mean the actual contents, could you just shove them in a
> tarball? New test kernel is building right now, hopefully that does
> it...

https://drive.google.com/open?id=0B_2Asp8DGjJ9MjVOT3NXeWh3eVU

-- 
Chris Murphy
