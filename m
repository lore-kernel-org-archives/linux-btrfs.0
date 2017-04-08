Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34129 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdDHR6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 13:58:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTYWeKL+BAb6F3tfwzs7OKUEA8ANM=V05sfoiahNNX=9w@mail.gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-7-git-send-email-deepa.kernel@gmail.com> <CAHC9VhTYWeKL+BAb6F3tfwzs7OKUEA8ANM=V05sfoiahNNX=9w@mail.gmail.com>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Sat, 8 Apr 2017 10:58:05 -0700
Message-ID: <CABeXuvoKmvbo_n3XQ0Y+iWGz88Jr3TwbPA7GiR3pia9407ANLw@mail.gmail.com>
Subject: Re: [PATCH 06/12] audit: Use timespec64 to represent audit timestamps
To: Paul Moore <paul@paul-moore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@fieldses.org>, Chris Mason <clm@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Sterba <dsterba@suse.com>, Evgeniy Dushistov <dushistov@mail.ru>,
        Eric Paris <eparis@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Josef Bacik <jbacik@fb.com>, Jeff Layton <jlayton@poochiereds.net>,
        John Stultz <john.stultz@linaro.org>,
        James Simmons <jsimmons@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        oleg.drokin@intel.com, Steven Rostedt <rostedt@goodmis.org>,
        yuchao0@huawei.com, ceph-devel <ceph-devel@vger.kernel.org>,
        devel@driverdev.osuosl.org, linux-audit@redhat.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-cifs@vger.kernel.org,
        "Linux F2FS DEV, Mailing List"
        <linux-f2fs-devel@lists.sourceforge.net>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        lustre-devel@lists.lustre.org,
        Linux Network Devel Mailing List <netdev@vger.kernel.org>,
        samba-technical@lists.samba.org,
        y2038 Mailman List <y2038@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have no problem merging this patch into audit/next for v4.12, would
> you prefer me to do that so at least this patch is merged?

This would be fine.
But, I think whoever takes the last 2 deletion patches should also take them.
I'm not sure how that part works out.

> It would probably make life a small bit easier for us in the audit
> world too as it would reduce the potential merge conflict.  However,
> that's a relatively small thing to worry about.

-Deepa
