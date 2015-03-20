Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbbCTKow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:44:52 -0400
Date: Fri, 20 Mar 2015 11:44:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Message-ID: <20150320104450.GJ20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <9389540.MYekrP2a8Q@merkaba>
 <1929370.YSr7hGqtmM@merkaba>
 <20150318135230.GA20767@twin.jikos.cz>
 <7757761.93uGJVH8dW@merkaba>
 <20150319132139.GE20767@twin.jikos.cz>
 <CAL3q7H7A349PzQ=z+YGHukWNfG_Y8EyChZV6Tr944gYsgPf-_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAL3q7H7A349PzQ=z+YGHukWNfG_Y8EyChZV6Tr944gYsgPf-_Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 09:47:15PM +0000, Filipe David Manana wrote:
> On Thu, Mar 19, 2015 at 1:21 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
> >> It explains that having a correct hardlink number for directory is not
> >> mandatory, but it doesn´t explain why BTRFS always has 1 in there instead
> >> of the actual count of hardlinks. Is this an performance optimization for
> >> BTRFS or are there any other reasons why BTRFS does it this way?
> >
> > I believe it's for performance reasons. New inodes do not update the
> > parent directory metadata wrt link counts, compared to other filesystems
> > that do that.
> 
> Weird. Because creating a new inode implies adding the dentry to the
> parent directory, which implies updating the directory's i_size.

Ah right, sorry, I've missed that.
