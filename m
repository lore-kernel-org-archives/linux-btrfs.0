Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57198 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HCSpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 14:45:22 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Fri, 3 Aug 2012 20:45:19 +0200
Cc: linux-btrfs@vger.kernel.org, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <201208022321.51795.Martin@lichtvoll.de> <20120802214946.GB1834@merlins.org> (sfid-20120803_140753_131575_3A20DA47)
In-Reply-To: <20120802214946.GB1834@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201208032045.19803.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 2. August 2012 schrieb Marc MERLIN:
> > > I'll try plugging this SSD in a totally different PC and see what
> > > happens. This may say if it's an AHCI/intel sata driver problem.
> >
> > 
> >
> > Seems we will continue until someone starts to complain here. Maybe
> > another list will be more approbiate? But then this thread has it all
> > in one ;). Adding a CC with some introductory note might be
> > approbiate. Its your problem, so you decide ;). I´d suggest the fio
> > mailing list, there are other performance people how may want to
> > chime in.
> 
>  
> Actually you know the lists and people involved more than me. I'd be
> happy if you added a Cc to another list you think is best, and we can
> move there.

I have no more ideas for the moment.

I suggest you to try the fio mailing list at fio lalala vger.kernel.org.

I currently have no ideas for other lists. I bet there is some block layer 
/ libata / scsi list that might match. Just browse the lists from 
kernel.org and pick the one that sounds most suitable for me¹. Probably 
fsdevel but since the thing does not seem to be filesystem related beside 
some alignment effect (stripe in Ext4). Hmmm, probably linux-scsi, but 
look there first, whether block layer and libata related things are 
discussed there.

I would start a new thread. Tell the problem, tell in summary what you 
have tried and the outcome of that was and ask for advice. Add a link to 
the original thread here. (It might be a good idea to have one more post 
here with a link to the new thread so that other curious people can follow 
there – in case there are any. Otherwise I would end it on this thread. 
The thread view already looks ridiculous in KMail here ;-)

And put me on Cc ;). I´d really like to know whats going on here. As 
written I have no more ideas right now. It seems to be getting to low 
level for me.

[1] http://vger.kernel.org/vger-lists.html

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
