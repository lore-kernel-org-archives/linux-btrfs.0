Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab3FEOcq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 10:32:46 -0400
Date: Wed, 5 Jun 2013 16:32:44 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Arne Jansen <sensille@gmx.net>, Chris Mason <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] list: add while_list_drain_entry
Message-ID: <20130605143244.GC18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
 <20130604144856.GA12302@infradead.org>
 <20130604145322.4088.78915@localhost.localdomain>
 <51AE4969.8050709@gmx.net>
 <20130604184435.GA23436@logfs.org>
 <20130605020341.GA27240@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130605020341.GA27240@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 04, 2013 at 10:03:41PM -0400, Jörn Engel wrote:
> I have seen a lot of boilerplate code that either follows the pattern of
> 	while (!list_empty(head)) {
> 		pos = list_entry(head->next, struct foo, list);
> 		list_del(pos->list);
> 		...
> 	}
> or some variant thereof.
> 
> With this patch in, people can use
> 	while_list_drain_entry(pos, head, list) {
> 		...
> 	}

The while_list_drain_entry way changes the semantics: the list link is
deleted before the {...} body starts, so it's not possible to access the
list anymore. None of the code you've converted uses this, from that
point it's safe, but if this is about to be a public interface, it
should be (at least) documented.

Macro trickery to postpone list_del after the {...} finishes does not
work if kfree/kmem_cache_free/rcu_string_free/... is used.


david
