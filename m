Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55612 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbaIIXxe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 19:53:34 -0400
Date: Wed, 10 Sep 2014 09:53:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15 v2] btrfs: new test to run btrfs balance and
 subvolume test simultaneously
Message-ID: <20140909235331.GI20518@dastard>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
 <1409233676-22787-2-git-send-email-eguan@redhat.com>
 <20140908100127.GF30012@dastard>
 <20140909115324.GU2977@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140909115324.GU2977@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 09, 2014 at 07:53:24PM +0800, Eryu Guan wrote:
> On Mon, Sep 08, 2014 at 08:01:27PM +1000, Dave Chinner wrote:
> > I'm thinking that we need to start separating common/rc in
> > filesystem specific include files. Not necessary for this series,
> > but we really need to so using this file as a dumping ground for
> > shared code rather than for init and config stuff.
> 
> Agreed, maybe I can add one more patch as a last patch to sort out all
> btrfs shared code to common/btrfs

Better to do a separate series where all the different
per-filesystem functionality is moved about rather than do it on an
ad hoc, one filesystem at a time basis. If I find some time in the
next few days, I'll look at doing this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
