Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaLSNhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 08:37:03 -0500
Date: Fri, 19 Dec 2014 14:36:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs-progs: fi usage, update manpage
Message-ID: <20141219133659.GG27601@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1418912740.git.dsterba@suse.cz>
 <488c53a0e5e255f9504cfc2a029e7c1c72994f66.1418912740.git.dsterba@suse.cz>
 <5493B1F8.2070106@jp.fujitsu.com>
 <5493F65B.5080603@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493F65B.5080603@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 06:56:43PM +0900, Satoru Takeuchi wrote:
> +There are some options to set unit. See the description of *df* subcommand
> +from '-b' option to '-t' option.

The unit options exist only for very few subcommands so I found it more
convenient to list all of them near to the command itself rather than
pointing somewhere else.
