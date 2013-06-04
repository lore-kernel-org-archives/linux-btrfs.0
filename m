Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60770 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FDOx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 10:53:27 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 1BD637C04D8
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Jun 2013 08:53:27 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130604144856.GA12302@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org> <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org> <20130604144856.GA12302@infradead.org>
Message-ID: <20130604145322.4088.78915@localhost.localdomain>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Date: Tue, 4 Jun 2013 10:53:22 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Christoph Hellwig (2013-06-04 10:48:56)
> On Mon, Jun 03, 2013 at 03:55:55PM -0400, J??rn Engel wrote:
> > Actually, when I compare the two invocations, I prefer the
> > list_for_each_entry_del() variant over list_pop_entry().
> > 
> >         while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
> >         list_for_each_entry_del(ref, &prefs, list) {
> > 
> > Christoph?
> 
> I really don't like something that looks like an iterator (*for_each*)
> to modify a list.  Maybe it's just me, so I'd love to hear others chime
> in.

Have to agree with Christoph.  I just couldn't put my finger on why I
didn't like it until I saw the list_pop_entry suggestion.

-chris

