Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab2FOP5a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 11:57:30 -0400
Date: Fri, 15 Jun 2012 11:57:28 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Mahone <andrew.mahone@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: PATCH: btrfs defrag ioctl, override extent count and size checks
 compression enabled.
Message-ID: <20120615155728.GB1556@localhost.localdomain>
References: <CAOUOUDzAEe8mZwrtqaFyQ1B9B8AFOhxyv5X70uQCPbVzYk8v+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOUOUDzAEe8mZwrtqaFyQ1B9B8AFOhxyv5X70uQCPbVzYk8v+g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2012 at 12:21:40PM -0400, Andrew Mahone wrote:
> I noticed a few days ago that btrfs fi defrag -cXXX can not be used to
> compress files unless they are fragmented. The attached patch passes
> the compression flag to should_defrag_range, where it disables the
> adjacent-extent and extent size checks if set. The inline/sparse
> extent check is not modified - I assumed it would not be useful to
> compress inline extents.
> 

Need a Signed-off-by: line and please inline your patches, don't attach them.
Once you resubmit I'll include in btrfs-next.  Thanks,

Josef
