Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbcFOIJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 04:09:19 -0400
Date: Wed, 15 Jun 2016 10:09:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: correct the destination of
 btrfs-receive
Message-ID: <20160615080954.GG6205@suse.cz>
Reply-To: dsterba@suse.cz
References: <491d91eb-0d51-b8ba-a046-61e2e392f06e@jp.fujitsu.com>
 <20160614085133.GE6205@twin.jikos.cz>
 <20160614091608.GC5437@carfax.org.uk>
 <9a4c1521-f1eb-8eaf-59c8-f2e0cb897ed9@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9a4c1521-f1eb-8eaf-59c8-f2e0cb897ed9@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 10:55:45AM +0900, Satoru Takeuchi wrote:
> >> ie. all the context lines start with two spaces instead of one. I'll
> >> apply this patch manually but please have a look.
> > 
> >    Looking at this, I suspect it's a consequence of sending it as
> > "Content-Type: format=flowed; delsp=yes". I'm not sure which of those
> > two options is the culprit. When I look at the message in my client
> > (mutt), it looks absolutely fine. When I pipe it to hexdump, the
> > double-spacing is apparent.
> 
> You're right. These are added to charset="iso-2022-jp" plain text
> mail since thunderbird 45.
> 
> I disabled the setting that appends the above mentioned options.
> So, probably the following sample patch doesn't have strange spaces.

Yes, looks good now, thanks.
