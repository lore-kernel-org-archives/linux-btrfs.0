Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59430 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3FFTmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 15:42:00 -0400
Date: Thu, 6 Jun 2013 14:12:48 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
Message-ID: <20130606181248.GA17707@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <1370280485-10047-2-git-send-email-joern@logfs.org>
 <CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 June 2013 22:32:55 +0300, Andy Shevchenko wrote:
> On Mon, Jun 3, 2013 at 8:28 PM, Joern Engel <joern@logfs.org> wrote:
> > I have seen a lot of boilerplate code that either follows the pattern of
> >         while (!list_empty(head)) {
> >                 pos = list_entry(head->next, struct foo, list);
> >                 list_del(pos->list);
> >                 ...
> >         }
> > or some variant thereof.
> 
> What the problem to use list_for_each_safe()?

The loop may terminate with elements left on the list.  There is more,
but I would consider this the main problem.

Jörn

--
If you're willing to restrict the flexibility of your approach,
you can almost always do something better.
-- John Carmack
