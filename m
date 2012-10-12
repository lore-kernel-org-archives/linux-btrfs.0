Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53865 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710Ab2JLKBf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 06:01:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Date: Fri, 12 Oct 2012 12:01:34 +0200
Cc: Ilya Dryomov <idryomov@gmail.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <506C6BC8.5050809@gmail.com> <20121003174643.GB2890@zambezi.lan> (sfid-20121003_220020_097175_EDF4F210)
In-Reply-To: <20121003174643.GB2890@zambezi.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210121201.34490.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 3. Oktober 2012 schrieb Ilya Dryomov:
> On Wed, Oct 03, 2012 at 06:46:00PM +0200, Goffredo Baroncelli wrote:
> > On 10/03/2012 05:01 PM, Ilya Dryomov wrote:
> > >"Type" for the first column is probably enough.
> > >
> > >Why is the third column called Chunk-size?  If my understanding is
> > >correct, it's just a break down of Disk_allocated from the summary
> > >section.  If so, why not call it Disk_allocated to avoid confusion?
> >
> > 
> >
> > Using everywhere Disk_<something> was my first attempt. But after
> > some thoughts I decided that these are two different kind of
> > information. It is true that Disk_allocated is the sum of
> > Chunk-Sizes... But my feels is that this is a kind of
> > "implementation details". If some other type of allocation unit will
> > be added to BTRFS, then these will be added to Disk_allocated, but
> > not to Chunk list...
> > I prefer to not change the wording until an enough critical mass of
> > people converge to a unique solution .
> 
> It is the chunks that is the implementation detail that we want to
> hide. Average Btrfs user wouldn't want to know anything about chunks,
> the only thing he'd be interested in is Disk_allocated and similar
> fields.

Hmm, thats an argument as well.

But how to name it differently without completely hiding aways what it is.

One could speak of data types or so. So we have Data, Metadata and System 
data areas on the disk. That are made of several chunks. But since the 
command displays the summary of all chunks, one could speak about data 
areas.

Anybody a better name for the summary of all chunks of one type?

Anyway, I like it as it is in this patch set way more than before. So from 
my point of view: Put it in and probably change output a bit later when 
there is some more feedback about it available.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
