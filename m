Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbbB0QpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 11:45:04 -0500
Date: Fri, 27 Feb 2015 17:45:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Move
 (set/clear_)extent_buffer_uptodate() to extent_io.h.
Message-ID: <20150227164502.GG8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422328363-11405-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422328363-11405-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422328363-11405-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 27, 2015 at 11:12:43AM +0800, Qu Wenruo wrote:
> Unlike kernel, these functions in userland just test/set/clear a member.
> So move them to header to avoid extra function call cost.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
