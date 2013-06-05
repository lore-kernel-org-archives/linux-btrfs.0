Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab3FEOZu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 10:25:50 -0400
Date: Wed, 5 Jun 2013 16:25:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Arne Jansen <sensille@gmx.net>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Chris Mason <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130605142545.GB18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
 <20130604144856.GA12302@infradead.org>
 <20130604145322.4088.78915@localhost.localdomain>
 <51AE4969.8050709@gmx.net>
 <20130604184435.GA23436@logfs.org>
 <20130605020939.GC27240@logfs.org>
 <51AEE07E.6070301@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51AEE07E.6070301@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 05, 2013 at 08:53:50AM +0200, Arne Jansen wrote:
> On 05.06.2013 04:09, Jörn Engel wrote:
> > On Tue, 4 June 2013 14:44:35 -0400, Jörn Engel wrote:
> >>
> >> Or while_list_drain?
> 
> I'm fine with while_list_drain, although a name starting with list_
> like all other list macros would be nice. How about just list_drain?

The list_ prefix makes it imho more readable, we know that list_* are
macros, but 'while_list_drain' does not fit to the group. I'd go for

list_drain or list_drain_entry


david
