Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34164 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaAGKft (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 05:35:49 -0500
Date: Tue, 7 Jan 2014 11:35:43 +0100
From: Andrea Mazzoleni <amadvance@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "amadvance@gmail.com" <amadvance@gmail.com>, Josef Bacik <jbacik@fb.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC v2 2/2] fs: btrfs: Extends btrfs/raid56 to support up to
 six parities
Message-ID: <20140107103543.GB16044@gmail.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
 <1389000716-3274-3-git-send-email-amadvance@gmail.com>
 <1389017609.23310.0.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389017609.23310.0.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 01/06, Chris Mason wrote:
> Neat.  The faila/failb were always my least favorite part of the btrfs
> code ;)  Did you test just raid5/6 or also the higher parity counts?
At this stage no real testing was made with btrfs.

The intention of this btrfs patch is mainly to get feedback on the new raid
inteface, and see if it matches the needs of btrfs, and if it results in
cleaner code than before.

And besides the removal of the faila/failb variables, something other that
likely you can appreciate is the removal of all the P/Q logic from btrfs,
that it's now replaced with a single raid_rec() call.

After the raid interface stabilizes, this patch can be used as starting
point for a real btrfs patch. But at now it's just to show
some example code of what kind of modification btrfs will need.

Ciao,
Andrea
