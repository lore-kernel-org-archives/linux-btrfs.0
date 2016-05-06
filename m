Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbcEFJJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 05:09:00 -0400
Date: Fri, 6 May 2016 11:08:22 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Spare volumes and hot auto-replacement feature
Message-ID: <20160506090822.GB29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <572A8337.1030505@mail.ru>
 <008f1f81-df20-796f-a609-78075ddd9837@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <008f1f81-df20-796f-a609-78075ddd9837@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 05, 2016 at 07:23:11AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-05-04 19:18, Dmitry Katsubo wrote:
> > Dear btrfs community,
> >
> > I am interested in spare volumes and hot auto-replacement feature [1]. I have a couple of questions:
> >
> > * Which kernel version this feature will be included?
> Probably 4.7.  I would not suggest using it in production for at least a 
> few cycles though (probably 4.9).

I wonder what are the grounds of the prediction, 4.7 is pretty much done
regarding new features. And given the number of other features that are
considered for merge I don't know an ETA. I haven't looked at the
patches yet (but don't know about others).
