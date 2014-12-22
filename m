Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaLVLhq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 06:37:46 -0500
Date: Mon, 22 Dec 2014 12:37:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs pre-release 3.18-rc2
Message-ID: <20141222113745.GM27601@suse.cz>
Reply-To: dsterba@suse.cz
References: <20141219182130.GL27601@twin.jikos.cz>
 <5497D3A9.8040900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5497D3A9.8040900@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 04:17:45PM +0800, Qu Wenruo wrote:
> I'm doing the btrfsck test framework tweaks, it will not be a big change 
> but it will change the original
> dir hierarchy, including moving of all the binary/btrfs-image dump to 
> different dirs
> (some dir may contains several images).
> 
> I'm afraid it may also delay 3.18 progs release, so just info you in 
> advance.

I think I could run the tests with rc2 codebase against the images you'd
provide but will not merge the code changes for that release.
