Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48612 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbcE0AOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 20:14:51 -0400
Date: Thu, 26 May 2016 20:14:14 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.7, part 2
Message-ID: <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
References: <cover.1464254502.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <cover.1464254502.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 11:27:06AM +0200, David Sterba wrote:
> Hi,
> 
> please pull a few more patches that did not go to pull #1 for 4.7, minor
> cleanups and fixes. Thanks.

Thanks Dave!  Trying to figure out why we're failing btrfs/011, but I
don't see how it could be related to this bunch.  I'll nail it down.

-chris
