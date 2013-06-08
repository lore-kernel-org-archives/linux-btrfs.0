Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33612 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3FHADZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 20:03:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130607184844.GE25323@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
	<1370280485-10047-2-git-send-email-joern@logfs.org>
	<CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
	<20130606181248.GA17707@logfs.org>
	<CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
	<20130607163658.GC25323@logfs.org>
	<CAHp75VdBb3Gt+sYwDbJo8BXRSsxwN0K6qw_UeJve6ycQwz2WBQ@mail.gmail.com>
	<20130607184844.GE25323@logfs.org>
Date: Sat, 8 Jun 2013 03:03:24 +0300
Message-ID: <CAHp75VfEUWYNXuo57x6JkOQfRM=03iGFaBKUeqz77SEeg_7=mA@mail.gmail.com>
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 7, 2013 at 9:48 PM, Jörn Engel <joern@logfs.org> wrote:
> On Fri, 7 June 2013 21:30:16 +0300, Andy Shevchenko wrote:
>> >
>> > spin_lock
>> > list_for_each_entry_safe
>> >         list_del
>> >         spin_unlock
>>
>> Who is doing such thing?
>
> Replace list_for_each_entry_safe with 'while (!list_empty(...))' and
> just grep.  My patch is about 'while (!list_empty(...))', not about
> list_for_each_entry_safe.

I saw your patch against btrfs.
I didn't see locking there.

Any excerpt like

 while (!list_empty(&prefs)) {
 ref = list_first_entry(&prefs, struct __prelim_ref, list);
 list_del(&ref->list);

could be transformed to
struct __prelim_ref *_ref;
list_for_each_entry_safe(ref, _ref, &prefs, list) {
 list_del(&ref->list);
 ...
}

but is it worth to do? (Same question to your approach)

I see two potential issues with while_list_drain_entry() or whatever
name you like:
 - you delete list as a first operation - you limit user to think in
that way, if you choose deletion as last operation, who will go to
free resources (call kfree() for example)?
- you always use the same ordering (list_first_entry() call), someone
may not be satisfied by that

So, the approach with while (!list_empty()) { e = list_entry();
list_del(&e->list); ... }
actually not bad. If there any bugs in code, better to fix those bugs
explicitly.

What do I not understand?

--
With Best Regards,
Andy Shevchenko
