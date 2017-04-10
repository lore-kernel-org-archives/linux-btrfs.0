Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754228AbdDJRfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 13:35:33 -0400
Date: Mon, 10 Apr 2017 19:35:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
Message-ID: <20170410173525.GE4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
 <ec137980-08d0-77d8-258b-29610a49a13f@mendix.com>
 <20170403122454.GT4781@twin.jikos.cz>
 <06cd6e94-1ffa-f6b7-acd2-cc122d2fd5f2@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <06cd6e94-1ffa-f6b7-acd2-cc122d2fd5f2@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 12:43:57AM +0200, Hans van Kranenburg wrote:
> On 04/03/2017 02:24 PM, David Sterba wrote:
> > On Fri, Mar 31, 2017 at 10:24:57PM +0200, Hans van Kranenburg wrote:
> >>>> Adding the 'nossd_spread' would be good to have, even if it might be
> >>>> just a marginal usecase.
> >>
> >> Please no, don't make it more complex if not needed.
> > 
> > The only use is when ssd,ssd_spread are on and then I'd just want to
> > disable ssd_spread, without disabling ssd at the same time.
> > 
> > 1. mount -o ssd,ssd_spread
> > 2. mount -o remount,nossd_spread
> > 
> > compared to
> > 
> > 1. mount -o ssd,ssd_spread
> > 2. mount -o remount,nossd
> > 3. mount -o remount,ssd
> > 
> > I'd vote for adding nossd_spread, as the 'no-' options are common and
> > otherwise disabling ssd_spread would be another usage exception.
> 
> Yes, 'nossd_spread' would intuitively be the thing to try to get rid of
> 'ssd_spread' on a mounted fs. But, nossd_spread is not a feature, just
> like noautodefrag isn't. nossd *is* a feature, but also a remount
> option... :o)
> 
> The mount manpage displays the values as a choice between 3 exclusive
> options: ssd|nossd|ssd_spread
> 
> They're like an increasing level of magic that is being applied:
>    nossd < ssd < ssd_spread
> 
> So, that documentation with the | makes me think: I have to choose
> either one. But that's not how it behaves, since some of them can appear

The documentation groups options by functionality, the "|" makes it
indeed confusing as exclusive options in this case. The rendering is not
consistent, I have "|" and also ",".  I hope that the text should
explain more than could fit into the brief option list and I'd like to
avoid complicating the syntax.

> But don't listen to me, I don't know what the best thing is.

Neither do I, so we talk about various aspects and update code or
documentation if we can make it more clear. I appreciate your feedback.
