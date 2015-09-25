Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbbIYVsX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 17:48:23 -0400
Date: Fri, 25 Sep 2015 23:47:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] progress indicator for btrfs-check
Message-ID: <20150925214725.GT11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443012156.git.silvio.fricke@gmail.com>
 <cover.1443074502.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1443074502.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2015 at 08:13:03AM +0200, Silvio Fricke wrote:
> I have noticed that a long running process like "btrfs check" needs a progress
> indicator. Please look into these patches.

Thanks, that's useful and people have been asking for that. The simple
indicator looks good to me, we might add some more verbose modes later.
I've fixed some code formatting and added manpage text.
