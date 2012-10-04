Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60060 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab2JDJ1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Oct 2012 05:27:03 -0400
Date: Thu, 4 Oct 2012 11:26:44 +0200
From: David Sterba <dave@jikos.cz>
To: Rock Lee <zimilo@code-trick.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs ulist use rbtree instead
Message-ID: <20121004092644.GB14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349341866-29320-1-git-send-email-zimilo@code-trick.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349341866-29320-1-git-send-email-zimilo@code-trick.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @@ -207,16 +266,23 @@ EXPORT_SYMBOL(ulist_add);
>   * end is reached. No guarantee is made with respect to the order in which
>   * the elements are returned. They might neither be returned in order of
>   * addition nor in ascending order.
> - * It is allowed to call ulist_add during an enumeration. Newly added items
> - * are guaranteed to show up in the running enumeration.
>   */
>  struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)

Quick observation:

If there's code relying on the behaviour stated in the removed part of
the comment, it will break. Have you verified this is not the case?


david
