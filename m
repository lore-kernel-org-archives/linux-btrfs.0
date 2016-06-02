Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbcFBRe7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 13:34:59 -0400
Date: Thu, 2 Jun 2016 19:34:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: convert-test: Add specially built test
 cases for new convert
Message-ID: <20160602173419.GK29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160602072250.25214-1-quwenruo@cn.fujitsu.com>
 <20160602072250.25214-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160602072250.25214-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 03:22:50PM +0800, Qu Wenruo wrote:
> New convert introduced simpler chunk/extent allocation algorithm, at the
> cost of complex backup superblock migration codes.
> 
> Use specially built ext2 images to test if btrfs-convert can convert and
> rollback images without problem.
> 
> All these special ext2 image have blocks across 2nd btrfs backup super
> block.
> 
> The naming is like the following:
> 	|<------superblock migration range----->|
> 	64M					64M + 64K
> |-Data--|-Data--|/Hole//|-Data--|/Hole//|-Data--|--Data--| = drdhdhdrd
> 
> These test cases should check all typical layouts and make sure new
> convert works.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/common                                       |   8 ++++
>  tests/convert-tests.sh                             |  30 ++++++++++++++

Please move the testing framework changes to another patch. This is
otherwise a good change, as we'll collect images for convert the same
way we do for checker.
