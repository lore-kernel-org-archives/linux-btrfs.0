Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61706 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaHOCs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 22:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140717174940.GR10393@wotan.suse.de>
References: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
 <20140717080301.GA14263@infradead.org> <20140717174940.GR10393@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 14 Aug 2014 22:48:05 -0400
Message-ID: <CAB=NE6WaQqp52MfZfjcShAUchj-1B+ZMsF1r6HabSiUxFLb7jQ@mail.gmail.com>
Subject: Re: [RFC v2 0/2] vfs / btrfs: add support for ustat()
To: Christoph Hellwig <hch@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>,
        jbacik@fb.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, fdmanana@suse.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 1:49 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Jul 17, 2014 at 01:03:01AM -0700, Christoph Hellwig wrote:
>> On Wed, Jul 16, 2014 at 02:37:56PM -0700, Luis R. Rodriguez wrote:
>> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
>> >
>> > This makes the implementation simpler by stuffing the struct on
>> > the driver and just letting the driver iinsert it and remove it
>> > onto the sb list. This avoids the kzalloc() completely.
>>
>> Again, NAK.  Make btrfs report the proper anon dev_t in stat and
>> everything will just work.
>
> Let's consider this userspace case:
>
>         struct stat buf;
>         struct ustat ubuf;
>
>         /* Find a valid device number */
>         if (stat("/", &buf)) {
>                 fprintf(stderr, "Stat failed: %s\n", strerror(errno));
>                 return 1;
>         }
>
>         /* Call ustat on it */
>         if (ustat(buf.st_dev, &ubuf)) {
>                 fprintf(stderr, "Ustat failed: %s\n", strerror(errno));
>                 return 1;
>         }
>
> In the btrfs case it has an inode op for getattr, that is used and we set
> the dev to anonymous dev_t. Later ustat will use user_get_super() which
> will only be able to work with a userblock if the super block's only
> dev_t is assigned to it. Since we have many anonymous to dev_t mapping
> to super block though we can't complete the search for btfs and ustat()
> fails with -EINVAL. The series expands the number of dev_t's that a super
> block can have and allows this search to complete.

Any further advice? I'll submit a v3 for RFC with some small change
for a fix for stress testing identified by Filipe Manana.

  Luis
