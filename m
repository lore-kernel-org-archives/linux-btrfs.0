Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbbEYM2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 08:28:04 -0400
Date: Mon, 25 May 2015 14:28:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fsck.btrfs: Fix bashism and bad getopts processing
Message-ID: <20150525122801.GD23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150521115651.GP23255@twin.jikos.cz>
 <1432212655-6238-1-git-send-email-dimitri.j.ledkov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432212655-6238-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 01:50:55PM +0100, Dimitri John Ledkov wrote:
> First fix == bashism, as that is not accepted by e.g. Debian/Ubuntu
> dash.
> 
> Secondly shift OPTIND, such that last parameter is checked to exist.
> 
> Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
> ---
>  fsck.btrfs | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fsck.btrfs b/fsck.btrfs
> index f056a7f..20b070a 100755
> --- a/fsck.btrfs
> +++ b/fsck.btrfs
> @@ -26,12 +26,13 @@ do
>  	a|A|p|y)	AUTO=true;;
>  	esac
>  done
> +shift $(($OPTIND -1))

BTW, this line is missing in the fsck.xfs stub as well, you may want to
send the patch to xfsprogs.
