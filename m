Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbcE3PQF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 11:16:05 -0400
Date: Mon, 30 May 2016 17:15:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160530151528.GB29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463369030-15434-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <d228d748-2947-a934-8bc1-afd53127e796@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d228d748-2947-a934-8bc1-afd53127e796@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 09:39:53AM +0800, Qu Wenruo wrote:
> Any comment?
> 
> This patch does not fix the submitted generic/352[1] and generic/353[2] 
> test cases, but also introduce a much better structure and design for 
> later backref walk use.
> 
> Instead of a list and do a O(n^3)~O(n^4) iteration for fiemap ioctl on a 
> reflinked(deduped) file, it's now only O(n)~O(nlogn) for SHARED flag 
> check to pass generic/352.

This is a good improvement, though there's potentially hidden cost in
the allocations and maintaining the temporary structures. Do you have
actual performance numbers?
