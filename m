Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbcBDOUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 09:20:04 -0500
Date: Thu, 4 Feb 2016 15:19:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Fix self-reference of man btrfs-subvolume
Message-ID: <20160204141947.GC9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56B2AE9A.5000204@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56B2AE9A.5000204@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 04, 2016 at 10:51:23AM +0900, Satoru Takeuchi wrote:
> btrfs-subvolume(8) is mentioned at "SEE ALSO" section of itself.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Aplied, thanks.
