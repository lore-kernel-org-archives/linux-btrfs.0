Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59370 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3FCVY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 17:24:57 -0400
Date: Mon, 3 Jun 2013 15:55:55 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130603195555.GC10200@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130603193647.GB10200@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 June 2013 15:36:47 -0400, Jörn Engel wrote:
> On Mon, 3 June 2013 13:49:30 -0700, Christoph Hellwig wrote:
> > 
> > I can't say I like the structure.
> > 
> > A list_pop that removes and entry from the head or returns NULL if the
> > list is empty would lead to nice while loops that are obviously
> > readable instead.
> 
> Something like this?
> 
> #define list_pop(head) \
>         ({ struct list_head *____pos; \
>            list_empty(head) ? NULL : (____pos = (head)->next, \
>                    list_del(____pos), ____pos) \
>         })
> 
> #define list_pop_entry(head, type, member) \
>         ({ struct list_head *____pos; \
>            list_empty(head) ? NULL : (____pos = (head)->next, \
>                    list_del(____pos), list_entry(____pos, type, member) \
>         })
> 
> Would be fine with me as well.

Actually, when I compare the two invocations, I prefer the
list_for_each_entry_del() variant over list_pop_entry().

        while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
        list_for_each_entry_del(ref, &prefs, list) {

Christoph?

Jörn

--
"Translations are and will always be problematic. They inflict violence
upon two languages." (translation from German)
