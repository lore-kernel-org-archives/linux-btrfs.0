Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBLObs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 09:31:48 -0500
Date: Wed, 12 Feb 2014 15:31:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] make 'btrfs fi show /mnt/point/' works with ending
 '/' character
Message-ID: <20140212143146.GM16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
 <52FAD9F2.6090001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FAD9F2.6090001@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 12, 2014 at 10:18:26AM +0800, Qu Wenruo wrote:
> Please ignore this patchset since adding a new option to
> find_mount_root is not the best method to solve the problem.

I'll merge the first patch, it's moving a utility finction to a file
where it IMO belongs.
