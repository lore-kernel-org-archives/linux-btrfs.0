Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3JWQlm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 12:41:42 -0400
Date: Thu, 24 Oct 2013 00:41:36 +0800
From: Eryu Guan <eguan@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131023164136.GI2675@dhcp-13-216.nay.redhat.com>
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
 <5267F88E.1010607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5267F88E.1010607@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 11:25:50AM -0500, Eric Sandeen wrote:
> On 10/23/13 6:24 AM, Eryu Guan wrote:
> > btrfs replace on readonly fs should not be allowed.
> > 
> > Regression test case for commit:
> > bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> 
> Could you speed this up by just truncating the loop files to 256m, rather
> than writing 256m to each (for a total of 768m IO?)

Sure, and that does save much time, 7s -> 1s on my test box.

V2 will be coming soon.

Thanks for the review!

Eryu
