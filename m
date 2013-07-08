Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:33590 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793Ab3GHEhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 00:37:16 -0400
Date: Mon, 8 Jul 2013 14:37:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130708043709.GB3438@dastard>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130705204100.GA15943@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130705204100.GA15943@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 05, 2013 at 04:41:00PM -0400, Jörn Engel wrote:
> On Mon, 3 June 2013 13:28:03 -0400, Joern Engel wrote:
> > 
> > A purely janitorial patchset.  A fairly common pattern is to take a
> > list, remove every object from it and do something with this object -
> > usually kfree() some variant.  A stupid grep identified roughly 300
> > instances, with many more hidden behind more complicated patterns to
> > achieve the same end results.
> 
> Next version of the same patchset.  Object size is shrinking now, at
> least for the one compiler I tested.  And a few kernel hackers met on
> a frozen lake in hell with pigs flying overhead and could actually
> agree on a name.  While I am sure almost every reader will still
> disagree and have one or two better suggestions, I would like to use
> this historical moment.
> 
> list_del_each and list_del_each_entry is shall be!

Can you add _init variants to this? There are many loops that
actually require list_del_init() rather than list_del()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
