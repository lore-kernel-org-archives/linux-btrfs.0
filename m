Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55169 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2IJRpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 13:45:11 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TB82o-0006SL-9S
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 10:45:10 -0700
Date: Mon, 10 Sep 2012 10:45:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Symlink to a long filename "filename too long" error
Message-ID: <20120910174510.GM5053@merlins.org>
References: <20120910163406.GG5053@merlins.org> <20120910171630.GT17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120910171630.GT17430@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2012 at 07:16:30PM +0200, David Sterba wrote:
> On Mon, Sep 10, 2012 at 09:34:06AM -0700, Marc MERLIN wrote:
> > Due to some filesystem corruption on my source device, I had a very long file as a symlink
> > target that btrfs wasn't able to recreate.
> > Mind you, in this case it's clearly not something I need, but is it
> > expected/known that ext4 can store longer filenames than btrfs?
> 
> Btrfs can store symlink targets up to it's inline limit, 3917. xfs has
> this limit hardcoded as 1024. ext4 has fast and non-fast symlink
> storage, based on the target length, so it's able to store the maximum
> PATH_MAX size into a full block for the non-fast case.

Thanks for explaining. For normal use, 3917 seems more than adequate :)
 
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
