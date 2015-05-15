Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35128 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946011AbbEOUnm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 16:43:42 -0400
Received: by iesa3 with SMTP id a3so42366782ies.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 13:43:42 -0700 (PDT)
Date: Fri, 15 May 2015 13:43:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
Message-ID: <20150515204340.GA20386@mew.dhcp4.washington.edu>
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 15, 2015 at 09:28:29PM +0100, Dimitri John Ledkov wrote:
> Bug-Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=784911
> Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
> ---
>  fsck.btrfs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fsck.btrfs b/fsck.btrfs
> index f056a7f..3a92804 100755
> --- a/fsck.btrfs
> +++ b/fsck.btrfs
> @@ -31,7 +31,7 @@ if [ ! -e $DEV ]; then
>  	echo "$0: $DEV does not exist"
>  	exit 8
>  fi
> -if [ "$AUTO" == "false" ]; then
> +if [ "false" = "$AUTO" ]; then
>  	echo "If you wish to check the consistency of a BTRFS filesystem or"
>  	echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
>  fi

I'm going to completely bikeshed here, but Yoda conditions are already
ugly in C, and completely pointless in Bash, where you can't ever
accidentally reassign a variable in a condition. Either way, I think:

if [ ! $AUTO ]; then

would be clearer anyways.

Thanks!
-- 
Omar
