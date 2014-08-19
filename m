Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaHSQcI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 12:32:08 -0400
Date: Tue, 19 Aug 2014 18:32:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: update manpage with new option -f for
 btrfstune
Message-ID: <20140819163206.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140703165145.GG1553@twin.jikos.cz>
 <1404698093-4149-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1404698093-4149-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404698093-4149-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 07, 2014 at 09:54:53AM +0800, Gui Hecheng wrote:
> The new option -f will force to do dangerous changes.
> e.g. clear the seeding flag.

missing signed-off-by

> --- a/Documentation/btrfstune.txt
> +++ b/Documentation/btrfstune.txt
> @@ -24,7 +24,8 @@ Enable seeding forces a fs readonly so that you can use it to build other filesy
>  Enable extended inode refs.
>  -x::
>  Enable skinny metadata extent refs.
> -
> +-f::
> +Allow dangerous changes, e.g. clear the seeding flag

Please enhance this, we've discussed it under previous patch iterations.
Thanks.
