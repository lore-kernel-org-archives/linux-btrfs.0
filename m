Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6839 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040Ab3JPVv5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 17:51:57 -0400
Date: Thu, 17 Oct 2013 08:51:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, jbacik@fusionio.com,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
Message-ID: <20131016215153.GK4446@dastard>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
 <525EAC5F.3040201@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525EAC5F.3040201@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 16, 2013 at 10:10:23AM -0500, Eric Sandeen wrote:
> On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
> > This test is motivated by an issue found by a btrfs user, addressed
> > and described by the following GNU/Linux kernel patch:
> > 
> > https://patchwork.kernel.org/patch/3046931/
> 
> Hi Filipe, thanks for the patch.
> 
> Usually we don't want to add new, possibly-failing cases to old tests;
> that makes it harder to identify when the code regressed vs. when
> the test changed to test new things.
> 
> It would be better to just copy the framework of tests/shared/051
> to a new test in shared/ and test only this new inheritance
> problem.
> 
> Also, I'm confused about this hunk:
> 
> > @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
> >  getfacl --numeric largeaclfile | _filter_aces
> >  
> >  echo "1 above xfs acl max"
> > -chacl $acl3 largeaclfile
> > +if [ "$FSTYP" != "btrfs" ]; then
> > +	chacl $acl3 largeaclfile
> > +else
> > +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> > +fi
> > +
> >  getfacl --numeric largeaclfile | _filter_aces
> >  
> >  echo "use 16 aces"
> 
> What's that about?

That's working around the "XFS only supports 25 ACLs test".

Another reason for making this a separate, generic test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
