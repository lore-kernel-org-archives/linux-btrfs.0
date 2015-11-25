Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40029 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbKYMEt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:04:49 -0500
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 22:04:46 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fdmanana@gmail.com
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Subject: Re: [PATCH 06/12] Fix btrfs/094 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 17:33:50 +0530
Message-ID: <1773494.Ogl3FMxuuo@localhost.localdomain>
In-Reply-To: <CAL3q7H4U_b_OkpA4_5MU3DMdP1LPjxNYmFXCVU0j9Zi86c2szg@mail.gmail.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com> <1984236.SDzE0v2Uyc@localhost.localdomain> <CAL3q7H4U_b_OkpA4_5MU3DMdP1LPjxNYmFXCVU0j9Zi86c2szg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 25 Nov 2015 11:51:52 Filipe Manana wrote:
> On Wed, Nov 25, 2015 at 11:47 AM, Chandan Rajendra
> 
> <chandan@linux.vnet.ibm.com> wrote:
> > On Wednesday 25 Nov 2015 11:11:27 Filipe Manana wrote:
> >> Hi Chandan,
> >> 
> >> I can't agree with this change. We're no longer checking that file
> >> data is correct after the cloning operations. The md5sum checks were
> >> exactly for that. So essentially the test is only verifying the clone
> >> operations don't fail with errors, it no longer checks for data
> >> corruption...
> >> 
> >> Same comment applies to at least a few other patches in the series.
> > 
> > Hello Filipe,
> > 
> > All the tests where we had md5sum being echoed into output have been
> > replaced with code to verify the md5sum values as shown below,
> > 
> >         if [ $foo_orig_hash != $foo_hash ]; then
> >         
> >                 echo "Read operation failed on $SCRATCH_MNT/foo: "\
> >                 
> >                      "Mimatching hash values detected."
> >         
> >         fi
> > 
> > This will cause a diff between the test's ideal output versus the output
> > obtained during the test run.
> 
> Right, it compares the digests before and after some operation (which
> should always match). However we no longer validate that the file
> content is correct before the operation. For some of the tests that is
> more important, like the ones that test read corruption after cloning
> compressed extents.

Filipe, you are right. I will drop the fautly patches and send V2 containing
fixes for only btrfs/017, btrfs/055 and btrfs/056.

Thanks for providing the review comments.

-- 
chandan

