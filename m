Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35205 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3FGOsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 10:48:02 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4B1507C0692
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Jun 2013 08:48:02 -0600 (MDT)
Date: Fri, 7 Jun 2013 10:47:59 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 6/8] Btrfs: introduce uuid-tree-gen field
Message-ID: <20130607144759.GF29248@localhost.localdomain>
References: <cover.1370534937.git.sbehrens@giantdisaster.de>
 <49cfd0aca92177345f59f3f700f6d43f8445f405.1370534938.git.sbehrens@giantdisaster.de>
 <20130607143916.GE29248@localhost.localdomain>
 <51B1F130.90401@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51B1F130.90401@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 07, 2013 at 08:41:52AM -0600, Stefan Behrens wrote:
> On 06/07/2013 16:39, Josef Bacik wrote:
> > On Fri, Jun 07, 2013 at 04:27:51AM -0600, Stefan Behrens wrote:
> >> In order to be able to detect the case that a filesystem is mounted
> >> with an old kernel, add a uuid-tree-gen field like the free space
> >> cache is doing it. It is part of the super block and written with
> >> each commit. Old kernels do not know this field and don't update it.
> >>
> >
> > So to get around the whole crashing before we finish creating the uuid tree
> > maybe set some flag or something that doesn't actually set the
> > super->uuid_tree_generation until _after_ it finishes populating the tree, and
> > then have the scan deal with having a half populated tree.  Just an idea, but we
> > have to deal with it some way.  Thanks,
> 
> That's what the patch 7/8 is doing.
> 

Yeah I just noticed that, thanks.

Josef
