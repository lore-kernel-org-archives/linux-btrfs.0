Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:40300 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUIoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 03:44:08 -0500
Message-ID: <528DC7D2.4090505@giantdisaster.de>
Date: Thu, 21 Nov 2013 09:44:02 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
CC: chris.mason@fusionio.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation: filesystems: add new btrfs mount options
References: <1384956351-18832-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1384956351-18832-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 20 Nov 2013 15:05:51 +0100, David Sterba wrote:
> Two new options were added in 3.12: commit and rescan_uuid_tree
> 
> CC: linux-doc@vger.kernel.org
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  Documentation/filesystems/btrfs.txt | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index 9dae59407437..3744ec373db9 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
[...]
> - skip_balance
> +  rescan_uuid_tree
> +	Force check and rebuild procedure of the UUID tree. This should not be
> +	normally be needed.

"be" "be" twice is too much?


