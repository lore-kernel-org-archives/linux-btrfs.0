Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42981 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbI1UdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 16:33:23 -0400
Date: Mon, 28 Sep 2015 23:26:48 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        carlo von lynX <lynX@time.to.get.psyced.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs receive bigger than original snapshot?
Message-ID: <20150928202648.GG21789@reaktio.net>
References: <20150922195219.GA23903@lo.psyced.org>
 <20150922200435.GL5918@carfax.org.uk>
 <CAL3q7H7F2k3WYptw5+RQa8_DvmqWRM4Q-tDwHQOHY+FH7qtCVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7F2k3WYptw5+RQa8_DvmqWRM4Q-tDwHQOHY+FH7qtCVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Sep 23, 2015 at 09:41:21AM +0100, Filipe David Manana wrote:
> On Tue, Sep 22, 2015 at 9:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Tue, Sep 22, 2015 at 09:52:19PM +0200, carlo von lynX wrote:
> >> Hello, it's me again. This time I searched the web to make sure
> >> I'm not making another beginner's mistake. I'm still not on the
> >> list, so please keep me in cc: on replies.
> >>
> >> I have optimized a btrfs subvolume with a script* that reflinks
> >> all files with identical contents, then I did a read-only snap
> >> and fed it to send/receive. The bad news: on the receiving
> >> side the same snapshot grew from 5.5G to 7.1G.
> 
> So that's likely because you have files with holes. Right now when a
> hole exists in a file the send stream will contain an instruction to
> write zeroes into the file instead of a punch hole instruction. So
> imagine a file with a 1Gb hole, the send stream makes the receiver
> write 1Gb of zeroes, wasting a lot of space (and time).
> 
> There's an over an year old patchset to add hole punching support to
> the send stream and a few other features, but it was never picked by
> Josef at the time (when he was maintaining the integration branch) nor
> Chris.
> 

Can you please point to the latest version of the hole punching patchset? 


Thanks,

-- Pasi

