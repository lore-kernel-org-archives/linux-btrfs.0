Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53066 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3FGSaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 14:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130607163658.GC25323@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
	<1370280485-10047-2-git-send-email-joern@logfs.org>
	<CAHp75VczX+tjqJgNv4uv=BRekm2Gc2i8WHL91vJFWSXWS8-J_A@mail.gmail.com>
	<20130606181248.GA17707@logfs.org>
	<CAHp75VfFvirRvN8FwNey4=9GvMKmPvaM5PBThbEBwZYwL_pt-A@mail.gmail.com>
	<20130607163658.GC25323@logfs.org>
Date: Fri, 7 Jun 2013 21:30:16 +0300
Message-ID: <CAHp75VdBb3Gt+sYwDbJo8BXRSsxwN0K6qw_UeJve6ycQwz2WBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] list: add list_for_each_entry_del
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 7, 2013 at 7:36 PM, Jörn Engel <joern@logfs.org> wrote:
> On Thu, 6 June 2013 22:49:22 +0300, Andy Shevchenko wrote:
>> On Thu, Jun 6, 2013 at 9:12 PM, Jörn Engel <joern@logfs.org> wrote:
>> > On Thu, 6 June 2013 22:32:55 +0300, Andy Shevchenko wrote:
>> >> What the problem to use list_for_each_safe()?
>> >
>> > The loop may terminate with elements left on the list.  There is more,
>> > but I would consider this the main problem.
>>
>> I didn't quite get what you mean.
>
> Take two threads, one doing a list_for_each_entry_safe loop and
> dropping the lock after list_del, the other doing list_add.  Result is
> that you finish the list_for_each_entry_safe loop with something
> remaining on the list.
>
> spin_lock
> list_for_each_entry_safe
>         list_del
>         spin_unlock

Who is doing such thing?

Usually if you unlock, you exit from function, or you already done
iteration through the list.

Like
lock()
list_for_each_safe() {
  if (condition) {
  list_del()
  unlock()
  return;
 }
}
unlock()
return;

In case you have to do unlock()/lock() routine inside iteration you always can
do an additional check at the end

list_for_each_safe() {
 unlock();
 lock();
}
if (!list_empty()) {
do_smth()
}
unlock();

Thus, I don't see how list*del will help.

> If you search for this pattern in the kernel, you won't find too many
> examples.  Quite likely that is because a) people realized this and
> used a while (!list_empty()) loop to begin with or b) they started out
> wrong and fixed the bug later.  Not sure how many examples of b) there
> are.

--
With Best Regards,
Andy Shevchenko
