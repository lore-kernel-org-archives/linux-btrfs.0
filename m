Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab3H1QcD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 12:32:03 -0400
Date: Wed, 28 Aug 2013 18:32:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
Message-ID: <20130828163200.GD23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 26, 2013 at 04:56:06PM -0400, Josef Bacik wrote:
> +#ifdef BTRFS_ASSERT
> +
> +static inline void assfail(char *expr, char *file, int lin)

typo: lin instead of line
