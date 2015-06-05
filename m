Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423160AbbFEQqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 12:46:11 -0400
Date: Fri, 5 Jun 2015 18:46:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: qgroup limit: add a check for invalid
 input of 'T/G/M/K'
Message-ID: <20150605164609.GW6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433323624-2194-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <1433323624-2194-2-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433323624-2194-2-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 03, 2015 at 05:27:04PM +0800, Dongsheng Yang wrote:
> Add a check to error out in the following case:
> 
>  # ./btrfs qgroup limit  T /mnt/
> Invalid size argument given
> 
> Without this patch, btrfs-progs would parse the input as 0
> and continue.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Applied, thanks.
