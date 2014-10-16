Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaJPLqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 07:46:14 -0400
Date: Thu, 16 Oct 2014 13:46:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] some btrfs-progs coverity fixes
Message-ID: <20141016114612.GD22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 04:14:17PM -0700, Zach Brown wrote:
> Here's another set of coverity fixes for btrfs-progs against David's 
> integration-20141007 branch.

Thanks, I've fished 2 patches for 3.17, the rest is queued.

> I got tired of adding error checking after a few so I moved on to the
> other warnings.  Maybe we should subscribe linux-btrfs to the reports
> that coverity can send out?

I'm not sure if this is allowed by the coverity service and I was not
able to any info about that.
