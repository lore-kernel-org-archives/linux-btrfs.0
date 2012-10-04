Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:48155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751009Ab2JDJoE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 05:44:04 -0400
Message-ID: <506D5A60.6040208@gmx.net>
Date: Thu, 04 Oct 2012 11:44:00 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Rock Lee <zimilo@code-trick.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs ulist use rbtree instead
References: <1349341866-29320-1-git-send-email-zimilo@code-trick.com> <20121004092644.GB14582@twin.jikos.cz>
In-Reply-To: <20121004092644.GB14582@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.10.2012 11:26, David Sterba wrote:
>> @@ -207,16 +266,23 @@ EXPORT_SYMBOL(ulist_add);
>>   * end is reached. No guarantee is made with respect to the order in which
>>   * the elements are returned. They might neither be returned in order of
>>   * addition nor in ascending order.
>> - * It is allowed to call ulist_add during an enumeration. Newly added items
>> - * are guaranteed to show up in the running enumeration.
>>   */
>>  struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
> 
> Quick observation:
> 
> If there's code relying on the behaviour stated in the removed part of
> the comment, it will break. Have you verified this is not the case?

It's a good thing to use rb-trees when the small inline cache is exhausted,
but of course it should keep the semantics. We heavily rely on the removed
part.
It should be possible to keep the semantics if the elements are also kept
in a linked list. As it inflates the size of struct ulist_node even more,
it might make sense to use a smaller struct for the inline cache to keep
the footprint low.

Also, a commit message might be good that explains the motivation for the
change. Have you done any measurements?

Thanks for working on this.

-Arne

> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

