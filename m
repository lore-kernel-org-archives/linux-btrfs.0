Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:42404 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932218AbcJZXHM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:07:12 -0400
Date: Wed, 26 Oct 2016 19:07:07 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Jens Axboe <axboe@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026230706.cbhbfyceqnkdzwua@codemonkey.org.uk>
References: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 05:03:45PM -0600, Jens Axboe wrote:
 > On 10/26/2016 04:58 PM, Linus Torvalds wrote:
 > > On Wed, Oct 26, 2016 at 3:51 PM, Linus Torvalds
 > > <torvalds@linux-foundation.org> wrote:
 > >>
 > >> Dave: it might be a good idea to split that "WARN_ON_ONCE()" in
 > >> blk_mq_merge_queue_io() into two
 > >
 > > I did that myself too, since Dave sees this during boot.
 > >
 > > But I'm not getting the warning ;(
 > >
 > > Dave gets it with ext4, and thats' what I have too, so I'm not sure
 > > what the required trigger would be.
 > 
 > Actually, I think I see what might trigger it. You are on nvme, iirc,
 > and that has a deep queue. Dave, are you testing on a sata drive or
 > something similar with a shallower queue depth? If we end up sleeping
 > for a request, I think we could trigger data->ctx being different.

yeah, just regular sata. I've been meaning to put an ssd in that box for
a while, but now it sounds like my procrastination may have paid off.

 > Dave, can you hit the warnings with this? Totally untested...
 
Coming up..
 
	Dave

