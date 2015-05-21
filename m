Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35580 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbEUIUA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 04:20:00 -0400
Received: by obcus9 with SMTP id us9so55095170obc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2015 01:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
Date: Thu, 21 May 2015 09:19:59 +0100
Message-ID: <CANBHLUhme-Y1FP21yQZ3w6QQCvOTNrXDmNKDRRY8rsMtbDJwuQ@mail.gmail.com>
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
From: Dimitri John Ledkov <xnox@debian.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 May 2015 at 21:28, Dimitri John Ledkov <dimitri.j.ledkov@intel.com> wrote:
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
>         echo "$0: $DEV does not exist"
>         exit 8
>  fi
> -if [ "$AUTO" == "false" ]; then
> +if [ "false" = "$AUTO" ]; then
>         echo "If you wish to check the consistency of a BTRFS filesystem or"
>         echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
>  fi

There was a lot of discussion about this trivial patch, mostly because
it's so trivial and has many ways to fix.

I hope btrfs maintainers could implement & push any of the proposed
ways to resolve this bashism to rule them all =)

-- 
Regards,

Dimitri.
