Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaBGKbD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 05:31:03 -0500
Date: Fri, 7 Feb 2014 11:31:00 +0100
From: David Disseldorp <ddiss@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs/035: add new clone overwrite regression
 test
Message-ID: <20140207113100.680c258e@plati.site>
In-Reply-To: <20140206224509.GC13647@dastard>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
	<1391695154-2039-4-git-send-email-ddiss@suse.de>
	<20140206224509.GC13647@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 Feb 2014 09:45:09 +1100, Dave Chinner wrote:

> Not exactly what I intended.
> 
> If echo fails, it will output some kind of error message, and that
> will cause the golden image mismatch.

Fair enough. I'll resend with the two '  || echo "failed to create src"'
checks removed. Thanks again for the review Dave.

Cheers, David
