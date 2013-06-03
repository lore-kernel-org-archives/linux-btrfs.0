Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59367 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3FCVFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 17:05:50 -0400
Date: Mon, 3 Jun 2013 15:36:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130603193647.GB10200@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130603204930.GA28299@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 June 2013 13:49:30 -0700, Christoph Hellwig wrote:
> 
> I can't say I like the structure.
> 
> A list_pop that removes and entry from the head or returns NULL if the
> list is empty would lead to nice while loops that are obviously
> readable instead.

Something like this?

#define list_pop(head) \
        ({ struct list_head *____pos; \
           list_empty(head) ? NULL : (____pos = (head)->next, \
                   list_del(____pos), ____pos) \
        })

#define list_pop_entry(head, type, member) \
        ({ struct list_head *____pos; \
           list_empty(head) ? NULL : (____pos = (head)->next, \
                   list_del(____pos), list_entry(____pos, type, member) \
        })

Would be fine with me as well.

Jörn

--
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
