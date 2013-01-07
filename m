Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42440 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3AGWCH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 17:02:07 -0500
Date: Mon, 7 Jan 2013 23:01:17 +0100
From: David Sterba <dave@jikos.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com, list.btrfs@jan-o-sch.net
Subject: Re: [PATCH] btrfs: add "no file data" flag to btrfs send ioctl
Message-ID: <20130107220117.GB3763@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20130107215118.GJ12558@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130107215118.GJ12558@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 01:51:19PM -0800, Mark Fasheh wrote:
> +#define BTRFS_SEND_FLAG_NO_FILE_DATA     0x1
> +

> +	sctx->flags = arg->flags;
> +

For compatibility reasons, you should mask the user input value and only
allow the supported flag(s).

david
