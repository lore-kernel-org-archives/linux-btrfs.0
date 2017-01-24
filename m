Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35974 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAXS76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 13:59:58 -0500
Received: by mail-yw0-f195.google.com with SMTP id q71so16669434ywg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 10:59:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
References: <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com> <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader> <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 11:59:57 -0700
Message-ID: <CAJCQCtROsC8xQP_4ueuYphaPQVcDBPXMiYYMUXHhBkajErgWNg@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Chris Murphy <lists@colorremedies.com>
Cc: Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK I just did a 2nd boot - all the same everything as the previous
dmesg.log (patch kernel snapshot). Identical. But not identical
results: timing wise the problem happens much sooner, at 14s the fs
goes read only instead of 30+ seconds. And I also get this line:

[   14.039931] systemd-journald[488]: Failed to set ACL on
/var/log/journal/864b0a611b104692b266377c7d4c7a39/user-1000.journal,
ignoring: Operation not permitted

entire dmesg for this boot:
https://drive.google.com/open?id=0B_2Asp8DGjJ9LTRzZjA2SThtbkE

Did it fail to set the ACL because the file system is readonly? Or was
trying to set the ACL what triggers the problem - then it goes
readonly and then we see the the complaint that the ACL failed to be
set? There's close proximity timing wise to the first Btrfs error
messages, with the most recent patch, and systemd audit messages.
Systemd-journald is switching from /run to /var, flushing the journal
to disk within about 2 seconds of the first Btrfs error. And systemd
does chattr +C on its logs by default now (and I think it's not user
changeable behavior so I can't test if it's related).

Chris Murphy
