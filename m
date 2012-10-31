Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34489 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2JaAMI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:12:08 -0400
Date: Wed, 31 Oct 2012 01:12:03 +0100
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121031001203.GD3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <508FB45B.9040101@gmail.com>
 <508FC26A.1010206@pepinghege.net>
 <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
 <50904949.8010603@gmail.com>
 <20121030221412.GB11422@carfax.org.uk>
 <20121030221947.GC11422@carfax.org.uk>
 <50906702.1010608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50906702.1010608@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 07:47:14AM +0800, ching wrote:
> On 10/31/2012 06:19 AM, Hugo Mills wrote:
> > On Tue, Oct 30, 2012 at 10:14:12PM +0000, Hugo Mills wrote:
> >>> if i have 10G small files in total, then it will consume 20G by default.
> >>    If those small files are each 128 bytes in size, then you have
> >> approximately 80 million of them, and they'd take up 80 million pages,
> >> or 320 GiB of total disk space.
> >    Sorry, to make that clear -- I meant if they were stored in Data.
> > If they're inlined in metadata, then they'll take approximately 20 GiB
> > as you claim, which is a lot less than the 320 GiB they'd be if
> > they're not.
> >
> is it the same for:
> 1. 3k per file with leaf size=4K
> 2. 60k per file with leaf size=64k

The inline limit is minimum of
* 'max_inline' (8k by default)
* PAGE_SIZE
* leafsize - header

so 60k files for 64k leaves will not get inlined, unless you have a
system with 64k pages.
