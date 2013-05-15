Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab3EOOCq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 10:02:46 -0400
Date: Wed, 15 May 2013 16:02:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: increase the max global reserve size to 1gig
Message-ID: <20130515140243.GY16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 08:56:54AM -0400, Josef Bacik wrote:
> Apparently 512mb was too small, with a fs_mark command we could get so much
> delayed work built up that we'd never trip the "lets commit the transaction"
> logic until we'd gotten too much delayed refs built up.  Increasing this to 1
> gig makes us much safer and we no longer abort with Dave's fs_mark tester.

With this patch on top of today's next I still hit the abort and will
file a bug.

david
