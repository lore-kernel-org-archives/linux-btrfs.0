Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35642 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdAXDvZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 22:51:25 -0500
Received: by mail-yw0-f193.google.com with SMTP id 17so19391922ywk.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 19:51:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124000524.GC11778@vader.DHCP.thefacebook.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com> <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 23 Jan 2017 20:51:24 -0700
Message-ID: <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 5:05 PM, Omar Sandoval <osandov@osandov.com> wrote:
> Thanks! Hmm, okay, so it's coming from btrfs_update_delayed_inode()...
> That's probably us failing btrfs_lookup_inode(), but just to make sure,
> could you apply the updated diff at the same link as before
> (https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4)? If
> that's the case, I'm even more confused about what xattrs have to do
> with it.

[   35.015363] __btrfs_update_delayed_inode(): inode is missing
[   35.015372] btrfs_update_delayed_inode(ino=2) -> -2


osandov-9f223b_2-dmesg.log
https://drive.google.com/open?id=0B_2Asp8DGjJ9UnNSRXpualprWHM


-- 
Chris Murphy
