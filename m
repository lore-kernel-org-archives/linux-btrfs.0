Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbbIAKYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 06:24:12 -0400
Date: Tue, 1 Sep 2015 12:24:10 +0200
From: Karel Zak <kzak@redhat.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mount command now shows subvol and subvolid
Message-ID: <20150901102410.GJ2726@ws.net.home>
References: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
 <20150831134517.GQ11834@twin.jikos.cz>
 <pan$76183$87074bc$e26a0ee$dfbc2e3a@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$76183$87074bc$e26a0ee$dfbc2e3a@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 07:17:53AM +0000, Duncan wrote:
> David Sterba posted on Mon, 31 Aug 2015 15:45:17 +0200 as excerpted:
> 
> > On Sun, Aug 30, 2015 at 11:17:44AM -0600, Chris Murphy wrote:
> >> Does anyone know when this changed? Maybe it's a 4.2 thing... anyway
> >> it's very much welcome!
> > 
> > And another "side effect" is that /proc/self/mountinfo will report the
> > mounted subvolume, even if it was an implicit mount of non-toplevel
> > subvolume.
> 
> Another very nice side effect, likely accidental, but still very nice... 
> is how subvol= ends up being reported for bind-mounts.
> 
> I don't use subvolumes here, but I do use multiple separate btrfs, so 
> subvolid=5, subvol=/ for all of them, would be technically correct, if 
> not particularly useful.  But while the subvolid=5 is indeed constant 
> (and actually useful given the following), subvol= turns out to be rather 
> more helpful than the / that would normally be expected.
> 
> I have a number of bind-mounts.  Formerly mount's output for these wasn't 
> particularly helpful, since I ended up with a number of...
> 
> /dev/sda5 on <mountpoint> ...

 Try findmnt(8) rather than mount(8).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
