Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33800 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3FFTtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 15:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130606181248.GA17707@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
	<1370280485-10047-2-git-send-email-joern@logfs.org>
	<CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
	<20130606181248.GA17707@logfs.org>
Date: Thu, 6 Jun 2013 22:49:22 +0300
Message-ID: <CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 6, 2013 at 9:12 PM, Jörn Engel <joern@logfs.org> wrote:
> On Thu, 6 June 2013 22:32:55 +0300, Andy Shevchenko wrote:
>> On Mon, Jun 3, 2013 at 8:28 PM, Joern Engel <joern@logfs.org> wrote:
>> > I have seen a lot of boilerplate code that either follows the pattern of
>> >         while (!list_empty(head)) {
>> >                 pos = list_entry(head->next, struct foo, list);
>> >                 list_del(pos->list);
>> >                 ...
>> >         }
>> > or some variant thereof.
>>
>> What the problem to use list_for_each_safe()?
>
> The loop may terminate with elements left on the list.  There is more,
> but I would consider this the main problem.

I didn't quite get what you mean.

list_for_each_safe() and list_for_each_entry_safe() traverse across
list. User actually decides when the proper time to remove an element
from the list.

I'm sorry, I didn't see any advantages from list_for_each_del() (or
entry variant).

--
With Best Regards,
Andy Shevchenko
