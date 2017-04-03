Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752163AbdDCM0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 08:26:25 -0400
Date: Mon, 3 Apr 2017 14:25:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: David Sterba <dsterba@suse.cz>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop the nossd flag when remounting with -o ssd
Message-ID: <20170403122540.GU4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170331171016.GN4781@twin.jikos.cz>
 <20170331200850.7067-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170331200850.7067-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 31, 2017 at 10:08:50PM +0200, Adam Borowski wrote:
> And when turning on nossd, drop ssd_spread.
> 
> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

I've folded the two patches and queued for 4.11. Thanks.
