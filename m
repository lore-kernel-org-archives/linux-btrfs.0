Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34467 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdDHCQ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 22:16:56 -0400
MIME-Version: 1.0
In-Reply-To: <20170407213011.36e29f42@gandalf.local.home>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-3-git-send-email-deepa.kernel@gmail.com> <20170407213011.36e29f42@gandalf.local.home>
From: Deepa Dinamani <deepa.kernel@gmail.com>
Date: Fri, 7 Apr 2017 19:16:54 -0700
Message-ID: <CABeXuvoQJSg+eVH4LX5s87DtE4N3goKDnjZgJ9fLk8txgwN+QA@mail.gmail.com>
Subject: Re: [PATCH 02/12] trace: Make trace_hwlat timestamp y2038 safe
To: Steven Rostedt <rostedt@goodmis.org>
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
        oleg.drokin@intel.com, Paul Moore <paul@paul-moore.com>,
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

>> -     trace_seq_printf(s, "#%-5u inner/outer(us): %4llu/%-5llu ts:%ld.%09ld",
>> +     trace_seq_printf(s, "#%-5u inner/outer(us): %4llu/%-5llu ts:%lld.%09ld",
>>                        field->seqnum,
>>                        field->duration,
>>                        field->outer_duration,
>> -                      field->timestamp.tv_sec,
>> +                      (long long)field->timestamp.tv_sec,
>
> Refresh my memory. We need the cast because on 64 bit boxes
> timestamp.tv_sec is just a long?

This is only required until we change the definition of timespec64.
Right now it is defined as

#if __BITS_PER_LONG == 64
# define timespec64 timespec
#else
struct timespec64 {
    time64_t tv_sec;
    long tv_nsec;
};
#endif

And timespec.tv_sec is just long int on 64 bit machines.
This is why we need the cast now.

We will probably change this and only define __kernel_timespec instead
of timespec, leaving only one definition of timespec64.
At that time, we will not need this.

-Deepa
