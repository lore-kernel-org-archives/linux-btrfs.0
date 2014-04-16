Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161133AbaDPPWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 11:22:40 -0400
Date: Wed, 16 Apr 2014 17:22:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
Message-ID: <20140416152239.GB29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1397572052.git.dsterba@suse.cz>
 <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
 <534D479E.3070200@fb.com>
 <20140415154412.GU29256@twin.jikos.cz>
 <534D57B1.6090501@fb.com>
 <20140415162734.GX29256@suse.cz>
 <534D6AAA.4010709@fb.com>
 <20140416133202.GZ29256@suse.cz>
 <534E8859.4040507@fb.com>
 <534E9ABD.4060300@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534E9ABD.4060300@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 04:59:09PM +0200, Brendan Hide wrote:
> On 2014/04/16 03:40 PM, Chris Mason wrote:
> >So in my example with the automated tool, the tool really shouldn't be
> >deleting a snapshot where send is in progress.  The tool should be told
> >that snapshot is busy and try to delete it again later.
> >
> >It makes more sense now, 'll queue this up for 3.16 and we can try it out
> >in -next.
> >
> >-chris
> So ... does this mean the plan is to a) have userland tool give an error; or
> b) a deletion would be "scheduled" in the background for as soon as the send
> has completed?

b) is current state, a) is the plan

with the patch, 'btrfs subvol delete' would return EPERM/EBUSY
