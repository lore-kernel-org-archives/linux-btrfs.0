Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbbFVORV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 10:17:21 -0400
Date: Mon, 22 Jun 2015 16:17:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Allow "filesystem show" command to
 handle different units
Message-ID: <20150622141719.GU6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434609972-8513-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434609972-8513-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 02:46:11PM +0800, Qu Wenruo wrote:
> Now "filesystem show" command can handle different units now.
> 
> This is handy for higher level programs to get accurate output from "fi
> show" command.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks, both applied with minor fixups.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
