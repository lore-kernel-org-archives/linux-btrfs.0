Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbcEaWWb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 18:22:31 -0400
Date: Wed, 1 Jun 2016 00:21:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Ashish Samant <ashish.samant@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Cleanup compress_file_range()
Message-ID: <20160531222153.GR29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458957693-1347-1-git-send-email-ashish.samant@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458957693-1347-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 07:01:33PM -0700, Ashish Samant wrote:
> Remove unnecessary checks in compress_file_range().
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>

I was looking for unmerged patches and found this one, now queued for
4.8.
