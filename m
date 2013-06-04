Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59374 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDUNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 16:13:44 -0400
Date: Tue, 4 Jun 2013 14:44:35 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arne Jansen <sensille@gmx.net>
Cc: Chris Mason <clmason@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130604184435.GA23436@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
 <20130604144856.GA12302@infradead.org>
 <20130604145322.4088.78915@localhost.localdomain>
 <51AE4969.8050709@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <51AE4969.8050709@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 4 June 2013 22:09:13 +0200, Arne Jansen wrote:
> On 06/04/13 16:53, Chris Mason wrote:
> > Quoting Christoph Hellwig (2013-06-04 10:48:56)
> >> On Mon, Jun 03, 2013 at 03:55:55PM -0400, J??rn Engel wrote:
> >>> Actually, when I compare the two invocations, I prefer the
> >>> list_for_each_entry_del() variant over list_pop_entry().
> >>>
> >>>         while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
> >>>         list_for_each_entry_del(ref, &prefs, list) {
> >>>
> >>> Christoph?
> >>
> >> I really don't like something that looks like an iterator (*for_each*)
> >> to modify a list.  Maybe it's just me, so I'd love to hear others chime
> >> in.
> > 
> > Have to agree with Christoph.  I just couldn't put my finger on why I
> > didn't like it until I saw the list_pop_entry suggestion.
> 
> list_pop_each_entry?

Or while_list_drain?

I agree the *for_each* cover didn't exactly match the content.  But if
we find a better name and you are not opposed to the concept, ...

Jörn

--
tglx1 thinks that joern should get a (TM) for "Thinking Is Hard"
-- Thomas Gleixner
