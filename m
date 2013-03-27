Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56503 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab3C0VsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:48:08 -0400
Date: Wed, 27 Mar 2013 17:48:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
        linux-ext4@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327214804.GA28143@thunk.org>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <20130327205407.GU6369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130327205407.GU6369@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 07:54:07AM +1100, Dave Chinner wrote:
> 
> Support for named tests have not yet been added. From the check
> script:
> 
> SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"

Ah, I thought support for named tests was there.  For right now,
though, if we have test ext4/123 and btrfs/123, that's OK and they are
considered separate tests, right?  Or do we still need to keep the
numbers unique for now?

						- Ted
