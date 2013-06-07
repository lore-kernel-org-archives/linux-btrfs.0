Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59459 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGSGN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 14:06:13 -0400
Date: Fri, 7 Jun 2013 12:36:58 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
Message-ID: <20130607163658.GC25323@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <1370280485-10047-2-git-send-email-joern@logfs.org>
 <CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
 <20130606181248.GA17707@logfs.org>
 <CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 June 2013 22:49:22 +0300, Andy Shevchenko wrote:
> On Thu, Jun 6, 2013 at 9:12 PM, Jörn Engel <joern@logfs.org> wrote:
> > On Thu, 6 June 2013 22:32:55 +0300, Andy Shevchenko wrote:
> >> On Mon, Jun 3, 2013 at 8:28 PM, Joern Engel <joern@logfs.org> wrote:
> >> > I have seen a lot of boilerplate code that either follows the pattern of
> >> >         while (!list_empty(head)) {
> >> >                 pos = list_entry(head->next, struct foo, list);
> >> >                 list_del(pos->list);
> >> >                 ...
> >> >         }
> >> > or some variant thereof.
> >>
> >> What the problem to use list_for_each_safe()?
> >
> > The loop may terminate with elements left on the list.  There is more,
> > but I would consider this the main problem.
> 
> I didn't quite get what you mean.

Take two threads, one doing a list_for_each_entry_safe loop and
dropping the lock after list_del, the other doing list_add.  Result is
that you finish the list_for_each_entry_safe loop with something
remaining on the list.

spin_lock
list_for_each_entry_safe
	list_del
	spin_unlock
			spin_lock
			list_add
			spin_unlock

If you search for this pattern in the kernel, you won't find too many
examples.  Quite likely that is because a) people realized this and
used a while (!list_empty()) loop to begin with or b) they started out
wrong and fixed the bug later.  Not sure how many examples of b) there
are.

At any rate, this is a purely janitorial patch.  It is almost by
definition of moderate utility and if there is significant opposition
or the patch actually causes harm in some way, we should drop it.

Jörn

--
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt
