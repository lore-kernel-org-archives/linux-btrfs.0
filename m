Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553AbaFLJVn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 05:21:43 -0400
Date: Thu, 12 Jun 2014 11:21:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Julien Muchembled <jm@jmuchemb.eu>
Cc: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Add some simple end-to-end tests for btrfs-convert.
Message-ID: <20140612092141.GK1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
 <5388CD3A.6090600@jmuchemb.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5388CD3A.6090600@jmuchemb.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 30, 2014 at 08:26:02PM +0200, Julien Muchembled wrote:
> Le 05/21/14 19:20, Adam Buchbinder a écrit :
> > +	# 256MB is the smallest acceptable btrfs image.
> > +	dd if=/dev/zero of=$here/test.img bs=1024 count=$((256*1024)) \
> > +		>> convert-tests-results.txt 2>&1 || _fail "dd failed"
> 
> What about using a sparse file to speed up the test and be nicer with the underlying storage ?
> For example:
>   truncate -s 256M $here/test.img
> 
> Because this does not reset test.img with zeros, one may want to the
>   rm -f test.img
> line at the beginning of the test function.

Yes, good idea. Patches welcome. Thanks.
