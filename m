Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:41416 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaDHQwD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 12:52:03 -0400
Received: by mail-bk0-f50.google.com with SMTP id w10so773303bkz.23
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 09:52:01 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1396971770-23553-2-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
	<1396971770-23553-2-git-send-email-lczerner@redhat.com>
Date: Tue, 8 Apr 2014 17:52:01 +0100
Message-ID: <CAL3q7H6eLTiWYHwAXpV6Vx77PcZaGo1cSHYqC0u=w-fywsLpVw@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfstests: Unset SCRATCH_DEV when deduced from SCRATCH_DEV_POOL
From: Filipe David Manana <fdmanana@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 8, 2014 at 4:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> In the case that we already have sections in the config file we
> have to make sure that we unset SCRATCH_DEV if it has been deduced from
> the SCRATCH_DEV_POOL so that it does not complain about SCRATCH_DEV in
> this case.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Tested-by: Filipe David Manana <fdmanana@gmail.com>

Tests working for btrfs now.
Thanks Lukas.

> ---
>  common/config | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/common/config b/common/config
> index 6fa18e2..3163801 100644
> --- a/common/config
> +++ b/common/config
> @@ -372,10 +372,15 @@ get_next_config() {
>         unset MOUNT_OPTIONS
>         unset MKFS_OPTIONS
>         unset FSCK_OPTIONS
> +       # We might have deduced SCRATCH_DEV from the SCRATCH_DEV_POOL in the previous
> +       # run, so we have to unset it now.
> +       if [ "$SCRATCH_DEV_NOT_SET" == "true" ]; then
> +               unset SCRATCH_DEV
> +       fi
>
>         parse_config_section $1
>
> -       if [ -n "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
> +       if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
>                 [ -z "$MOUNT_OPTIONS" ] && _mount_opts
>                 [ -z "$MKFS_OPTIONS" ] && _mkfs_opts
>                 [ -z "$FSCK_OPTIONS" ] && _fsck_opts
> @@ -423,6 +428,7 @@ get_next_config() {
>                 fi
>                 SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>                 export SCRATCH_DEV
> +               export SCRATCH_DEV_NOT_SET=true
>         fi
>
>         echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> --
> 1.8.3.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
