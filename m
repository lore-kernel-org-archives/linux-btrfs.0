Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3HAUau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 16:30:50 -0400
Date: Thu, 1 Aug 2013 22:30:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        chris.mason@fusionio.com
Subject: Re: [PATCH 09/12] Btrfs-progs: Add chunk recover function - using
 old chunk items
Message-ID: <20130801203047.GB24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
 <1372857920-4678-10-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372857920-4678-10-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 03, 2013 at 09:25:17PM +0800, Miao Xie wrote:
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -247,6 +247,7 @@ const struct cmd_group btrfs_cmd_group = {
>  		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
>  		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
>  		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
> +		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},

Better late than never, though the patches are already in master branch
and I am horribly late.

I don't like to see this very specific command in the first level of
command namespace. In the past we've proposed a group named 'rescue'
that would collect functions that are potentially dangerous but perform
certain tasks that can make a filesystem usable again.

Examples are select-super or zero-log that are now separate utilities.

As a related topic, I was thinking about intorducing a separate
namespace that would be declared unstable and any feature in development
would be free to use it and add/modify/delete commands and params as
needed. That way developers can focus on the feature itself and let the
user interface polishing for later.

And now the name of the namespace: how about _ ? It's short, will never
clash with any other command.


david
