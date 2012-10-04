Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:42822 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab2JDO2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 10:28:30 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Subject: Re: [PATCH] btrfs ulist use rbtree instead
From: Zimilo <zimilo@code-trick.com>
In-Reply-To: <506D5A60.6040208@gmx.net>
Date: Thu, 4 Oct 2012 22:28:33 +0800
Cc: Zimilo <zimilo@code-trick.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <2793AF96-98CE-4709-94EE-659D853267E4@code-trick.com>
References: <1349341866-29320-1-git-send-email-zimilo@code-trick.com> <20121004092644.GB14582@twin.jikos.cz> <506D5A60.6040208@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Detailed explanations for the patch:

     When the small inline cache is exhausted, created a new rbtree,

     and the new rbtree uses  original spaces the inline nodes placed for saving memory.

     By using the rbtree can gain a better performance when nnodes gets larger.

     
Sorry for I doest't did much more measurements, but the average lookup time increases slower then the original linear policy when nnodes goes larger.


For this is my first patch I submitted, I'm too excited to find something I can hack the kernel, however I didn't consider the whole thing.

I will continue to dive into the btrfs implementation, and work harder. 

:-)

- Rock

On 2012-10-4, at 下午5:44, Arne Jansen <sensille@gmx.net> wrote:

> On 04.10.2012 11:26, David Sterba wrote:
>>> @@ -207,16 +266,23 @@ EXPORT_SYMBOL(ulist_add);
>>>  * end is reached. No guarantee is made with respect to the order in which
>>>  * the elements are returned. They might neither be returned in order of
>>>  * addition nor in ascending order.
>>> - * It is allowed to call ulist_add during an enumeration. Newly added items
>>> - * are guaranteed to show up in the running enumeration.
>>>  */
>>> struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
>> 
>> Quick observation:
>> 
>> If there's code relying on the behaviour stated in the removed part of
>> the comment, it will break. Have you verified this is not the case?
> 
> It's a good thing to use rb-trees when the small inline cache is exhausted,
> but of course it should keep the semantics. We heavily rely on the removed
> part.
> It should be possible to keep the semantics if the elements are also kept
> in a linked list. As it inflates the size of struct ulist_node even more,
> it might make sense to use a smaller struct for the inline cache to keep
> the footprint low.
> 
> Also, a commit message might be good that explains the motivation for the
> change. Have you done any measurements?
> 
> Thanks for working on this.
> 
> -Arne
> 
>> 
>> 
>> david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/







