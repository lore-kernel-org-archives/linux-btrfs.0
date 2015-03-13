Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbbCMLEc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 07:04:32 -0400
Date: Fri, 13 Mar 2015 12:04:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: ENOMEM bugfixes
Message-ID: <20150313110430.GG20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1424773781.git.osandov@osandov.com>
 <20150312044017.GA7693@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150312044017.GA7693@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 11, 2015 at 09:40:17PM -0700, Omar Sandoval wrote:
> Ping. For anyone following along, it looks like commit cc87317726f8
> ("mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change")
> reverted the commit that exposed these bugs. Josef said he was okay with
> taking these, will they make it to an upcoming -rc soon?

Upcoming yes, but based on my experience with pushing patches that are
not really regressions in late rc's it's unlikely for 4.1.
