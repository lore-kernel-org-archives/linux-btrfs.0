Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3FDOs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 10:48:57 -0400
Date: Tue, 4 Jun 2013 07:48:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: J??rn Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130604144856.GA12302@infradead.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130603195555.GC10200@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 03, 2013 at 03:55:55PM -0400, J??rn Engel wrote:
> Actually, when I compare the two invocations, I prefer the
> list_for_each_entry_del() variant over list_pop_entry().
> 
>         while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
>         list_for_each_entry_del(ref, &prefs, list) {
> 
> Christoph?

I really don't like something that looks like an iterator (*for_each*)
to modify a list.  Maybe it's just me, so I'd love to hear others chime
in.

