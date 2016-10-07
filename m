Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938859AbcJGQ70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 12:59:26 -0400
Date: Fri, 7 Oct 2016 18:58:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Tim Small <tim@seoss.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Making statfs return qgroup info (for container use case etc.)
Message-ID: <20161007165847.GG11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <32dfef18-ca3b-6c29-252a-4fc9e36b373a@seoss.co.uk>
 <20161006224011.GF9806@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161006224011.GF9806@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 09:40:11AM +1100, Dave Chinner wrote:
> XFS does this with directory tree quotas. It was implmented 10 years
> ago or so, IIRC...

Sometimes, the line between a historical remark and trolling is thin....
