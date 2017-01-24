Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33606 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbdAXULK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:11:10 -0500
Received: by mail-pf0-f175.google.com with SMTP id y143so52326050pfb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 12:11:10 -0800 (PST)
Date: Tue, 24 Jan 2017 12:10:38 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124201038.GB2853@vader>
References: <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com>
 <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader>
 <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
 <20170124185644.GA2853@vader>
 <CAJCQCtTcanEcoPGwLxBcLUjzgt5MZYdDMpEvk1vgX3ZVPizHvg@mail.gmail.com>
 <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 12:19:29PM -0700, Chris Murphy wrote:
> I can reproduce it on another laptop with Fedora 25. I haven't tried
> to reproduce it in a VM. In this case, it's a single partition Btrfs
> volume, completely stock, and is about 5 weeks old, no crashes or
> forced shutdowns. The HP uses a Samsung NVMe SSD, whereas on this
> Macbook Pro it's a Samsung SATA SSD.
> 
> dmesg
> https://drive.google.com/open?id=0B_2Asp8DGjJ9cjhSRUJxc1k3NVE
> 
> 
> Chris Murphy

Hm, still no luck, maybe it's a Server vs Workstation thing? I'll try
installing Workstation. In the meantime, I noticed that in both of the
traces, systemd-tmpfiles was the process that tripped the WARN_ONCE().
Could you dump the contents of /{etc,run,usr/lib}/tmpfiles.d somewhere?
