Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33521 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFBOS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 10:18:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAAM7YA=f74Wye8hgqR52CNG-c4Sh3sm74AzZYhSnhjN1B=G-Ow@mail.gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-5-git-send-email-deepa.kernel@gmail.com>
 <CAAM7YAmp=cZKqGHa8UqDnrQLCe+6TKx+7w9SDZv4cW5fr4dfvA@mail.gmail.com>
 <CAK8P3a1pCw1Oo-Wg70kH5L12pbtEzGDfaPZ8g6ErERJjvY8znQ@mail.gmail.com>
 <CAAM7YAnWLUXMOCVbgfdKGfvK04EtAQcz-ETm7xFO=8Y=_fCvOQ@mail.gmail.com>
 <CALAqxLV-yVKWM5es7fAFiDzhSQmtZFiZDPQwBRUYbWUtqhoWVg@mail.gmail.com>
 <CABeXuvqvLr6sSGF+rZEXXxpCBDKTOeLX1ObSjbPPY4aFBuwvMg@mail.gmail.com>
 <CAAM7YAkXNo_69tOrw6a5kpyref9nEpEp-2vxBbFVSHGmAVbt+A@mail.gmail.com>
 <CAK8P3a1TwkVRCwDWqgYE8Z3wZT2+v6xayq=dVeW8KaHmO0W4cg@mail.gmail.com>
 <CAAM7YA=BJHFLz_Ud==7L=yCzxj+1sjctc68tvpNogPhiSxxELQ@mail.gmail.com>
 <CAK8P3a0D3EXuwBj+sSVL9cmpysdvQWXnkE0zEctBJS8XOqhX7A@mail.gmail.com>
 <CAAM7YAk8JNU=XV=sOCczagWjBimO4JSPU08th7E4u6FTJN--9A@mail.gmail.com>
 <CAK8P3a3m3nt6rfvAvDG6HFuUvy+qWbmk5K0UtLGqYhYHOfdF8w@mail.gmail.com> <CAAM7YA=f74Wye8hgqR52CNG-c4Sh3sm74AzZYhSnhjN1B=G-Ow@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 2 Jun 2017 16:18:26 +0200
Message-ID: <CAK8P3a1etuRz6zwytXTHqK-T0g2YnbR4zcCwo98ehjjD1Dj+Ow@mail.gmail.com>
Subject: Re: [PATCH 04/12] fs: ceph: CURRENT_TIME with ktime_get_real_ts()
To: "Yan, Zheng" <ukernel@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, gregkh <gregkh@linuxfoundation.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Chris Mason <clm@fb.com>,
        David Miller <davem@davemloft.net>, David Sterba <dsterba@suse.com>,
        Evgeniy Dushistov <dushistov@mail.ru>, Eric Paris <eparis@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Josef Bacik <jbacik@fb.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        James Simmons <jsimmons@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        Paul Moore <paul@paul-moore.com>, Steven Rostedt <rostedt@goodmis.org>,
        yuchao0@huawei.com, ceph-devel <ceph-devel@vger.kernel.org>,
        devel@driverdev.osuosl.org, linux-audit@redhat.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>, linux-cifs@vger.kernel.org,
        "Linux F2FS DEV, Mailing List"
        <linux-f2fs-devel@lists.sourceforge.net>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Lustre Development List <lustre-devel@lists.lustre.org>,
        Networking <netdev@vger.kernel.org>, samba-technical@lists.samba.org,
        y2038 Mailman List <y2038@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 2, 2017 at 2:18 PM, Yan, Zheng <ukernel@gmail.com> wrote:
> On Fri, Jun 2, 2017 at 7:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Jun 2, 2017 at 1:18 PM, Yan, Zheng <ukernel@gmail.com> wrote:
>> What I meant is another related problem in ceph_mkdir() where the
>> i_ctime field of the parent inode is different between the persistent
>> representation in the mds and the in-memory representation.
>>
>
> I don't see any problem in mkdir case. Parent inode's i_ctime in mds is set to
> r_stamp. When client receives request reply, it set its in-memory inode's ctime
> to the same time stamp.

Ok, I see it now, thanks for the clarification. Most other file systems do this
the other way round and update all fields in the in-memory inode structure
first and then write that to persistent storage, so I was getting confused about
the order of events here.

If I understand it all right, we have three different behaviors in ceph now,
though the differences are very minor and probably don't ever matter:

- in setattr(), we update ctime in the in-memory inode first and then send
  the same time to the mds, and expect to set it again when the reply comes.

- in ceph_write_iter write() and mmap/page_mkwrite(), we call
  file_update_time() to set i_mtime and i_ctime to the same
  timestamp first once a write is observed by the fs and then take
  two other timestamps that we send to the mds, and update the
  in-memory inode a second time when the reply comes. ctime
  is never older than mtime here, as far as I can tell, but it may
  be newer when the timer interrupt happens between taking the
  two stamps.

- in all other calls, we only update the inode (and/or parent inode)
  after the reply arrives.

       Arnd
