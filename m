Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54739 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdFUDoN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 23:44:13 -0400
Date: Tue, 20 Jun 2017 20:43:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170621034352.GE5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org> <20170620231202.GB5303@merlins.org> <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 09:31:42PM -0600, Chris Murphy wrote:
> On Tue, Jun 20, 2017 at 5:12 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > I'm now going to remount this with nospace_cache to see if your guess about
> > space_cache was correct.
> > Other suggestions also welcome :)
> 
> What results do you get with lowmem mode? It won't repair without
> additional patches, but might give a dev a clue what's going on. I
> regularly see normal mode check finds no problems, and lowmem mode
> finds problems. Lowmem mode is a total rewrite so it's a different
> implementation and can find things normal mode won't.

Oh, I kind of forgot that lowmem mode looked for more things than regular
mode.
I will run this tonight and see what it says.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
