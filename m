Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbcDYMoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:44:55 -0400
Date: Mon, 25 Apr 2016 14:44:43 +0200
From: David Sterba <dsterba@suse.cz>
To: service@automatix.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs fails desatrerous on fuzzy tests
Message-ID: <20160425124443.GI23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <570D0520.2090107@automatix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <570D0520.2090107@automatix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 04:24:32PM +0200, Juergen Sauer wrote:
> Hi!
> do you know this paper ?
> 
> http://events.linuxfoundation.org/sites/events/files/slides/AFL%20filesystem%20fuzzing%2C%20Vault%202016.pdf

Yes. There were several bugreports resulting from the fuzzing, all fixed
in 4.5 and IIRC all of them happen during mount. Thus the awkwardly low
amount of time to trigger the bugs. The fuzzing suite is not yet
released and instrumenting all the code is not all trivial, but the
Oracle guys promised to do a release but at least we have the generated
images in the btrfs-progs testsuite.

I'm curious about this level of fuzzing as it can help to make the error
handling more robust, but we'll be never able to completely defend
against crafted images. For example we can detect a missing extent
mapping when looking for it, but we cannot distinguish that from an
existing but wrong mapping.  That would be like doing a full filesystem
integrity check all the time (because we cannot trust any data we read
from disk). There are exceptions where there's enough information cached
or available from other contexts, but overall too hard to fix. And this
applies to all filesystem.s
