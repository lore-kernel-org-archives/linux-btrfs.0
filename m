Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaLSNsU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 08:48:20 -0500
Date: Fri, 19 Dec 2014 14:48:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: WorMzy Tykashi <wormzy.tykashi@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: integration-20141218 possible corruption test
 regression
Message-ID: <20141219134810.GH27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com>
 <719D86DC-BC2F-4A9C-9D17-F90AFFF3FFC2@gmail.com>
 <5493C450.8060204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493C450.8060204@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 02:23:12PM +0800, Qu Wenruo wrote:
> In fact, it's not a regression.
> 
> The 013 testcase is a special case that uses a script to corrupt the 
> image and then do the btrfsck test.
> 
> There is a patch before the commit, to allow btrfs-progs test script 
> call corruption script.
> But since there is still some discussion about the corruption script and 
> maybe later verify script,
> the previous patch is not picked.

Yes, I'm waiting for final version of the patch, but wanted to add all
test images that were available.
