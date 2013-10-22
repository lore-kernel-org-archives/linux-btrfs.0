Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3JVOdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 10:33:06 -0400
Date: Tue, 22 Oct 2013 16:33:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
Message-ID: <20131022143303.GU1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
 <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 01:53:22PM +0800, Anand Jain wrote:
> @@ -386,7 +395,7 @@ static int btrfs_scan_kernel(void *search)
>  static const char * const cmd_show_usage[] = {
> -	"btrfs filesystem show [options] [<path>|<uuid>]",
> +	"btrfs filesystem show [options|<path>|<uuid>]",

Options should stay separate from the path/uuid, you're extending the
syntax to accept a device:

	"btrfs filesystem show [options] [<path>|<uuid>|<device>]",

I'm fixing it locally, let me know if this doesn't match what you've
intended.

david
