Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbaBYSHH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:07:07 -0500
Date: Tue, 25 Feb 2014 19:07:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: send: lower memory requirements in common case
Message-ID: <20140225180705.GC16073@suse.cz>
Reply-To: dsterba@suse.cz
References: <1391613454-30622-1-git-send-email-dsterba@suse.cz>
 <CAL3q7H47h8v-gE_U+4tFSAfTtyjQhFH6NR9oZxuLA_HjEMw1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H47h8v-gE_U+4tFSAfTtyjQhFH6NR9oZxuLA_HjEMw1Fg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 12:00:23PM +0000, Filipe David Manana wrote:
> >         } else {
> > -               if (is_vmalloc_addr(p->buf)) {
> > -                       tmp_buf = vmalloc(len);
> > -                       if (!tmp_buf)
> > -                               return -ENOMEM;
> > -                       memcpy(tmp_buf, p->buf, p->buf_len);
> > -                       vfree(p->buf);
> > -               } else {
> > -                       tmp_buf = krealloc(p->buf, len, GFP_NOFS);
> > -                       if (!tmp_buf) {
> > -                               tmp_buf = vmalloc(len);
> > -                               if (!tmp_buf)
> > -                                       return -ENOMEM;
> > -                               memcpy(tmp_buf, p->buf, p->buf_len);
> > -                               kfree(p->buf);
> > -                       }
> > -               }
> > -               p->buf = tmp_buf;
> > -               p->buf_len = len;
> > +               char *tmp;
> > +
> > +               tmp = krealloc(p->buf, len, GFP_NOFS);
> > +               if (!tmp)
> > +                       return -ENOMEM;
> > +               p->buf = tmp;
> > +               p->buf_len = ksize(p->buf);
> >         }
> > +
> > +       path_len = p->end - p->start;
> > +       old_buf_len = p->buf_len;
> 
> I think this is not correct here. old_buf_len doesn't get assigned the
> old buffer's length but instead the new length. So this assignment
> should be before the if-then-else that allocates/reallocates the path
> buffer, just like it was done previously before this change.

You're right, I'll send a fix. Thanks.
