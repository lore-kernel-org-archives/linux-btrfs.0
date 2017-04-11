Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:34781 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbdDKUMD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 16:12:03 -0400
Received: by mail-ua0-f173.google.com with SMTP id u103so5059232uau.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 13:12:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABeXuvoKmvbo_n3XQ0Y+iWGz88Jr3TwbPA7GiR3pia9407ANLw@mail.gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-7-git-send-email-deepa.kernel@gmail.com>
 <CAHC9VhTYWeKL+BAb6F3tfwzs7OKUEA8ANM=V05sfoiahNNX=9w@mail.gmail.com> <CABeXuvoKmvbo_n3XQ0Y+iWGz88Jr3TwbPA7GiR3pia9407ANLw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2017 16:12:02 -0400
Message-ID: <CAHC9VhTMU7cEJD2rffxOshEnL18i597GBsvHZm-Y8hCE9SJCAA@mail.gmail.com>
Subject: Re: [PATCH 06/12] audit: Use timespec64 to represent audit timestamps
To: Deepa Dinamani <deepa.kernel@gmail.com>
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

On Sat, Apr 8, 2017 at 1:58 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>> I have no problem merging this patch into audit/next for v4.12, would
>> you prefer me to do that so at least this patch is merged?
>
> This would be fine.
> But, I think whoever takes the last 2 deletion patches should also take them.
> I'm not sure how that part works out.

FWIW, I just merged this into the audit/next branch so at least this
will go into v4.12.

>> It would probably make life a small bit easier for us in the audit
>> world too as it would reduce the potential merge conflict.  However,
>> that's a relatively small thing to worry about.

-- 
paul moore
www.paul-moore.com
