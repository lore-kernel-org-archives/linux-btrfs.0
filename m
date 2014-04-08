Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44405 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbaDHQvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 12:51:39 -0400
Received: by mail-bk0-f48.google.com with SMTP id mx12so773945bkb.7
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 09:51:38 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1396971770-23553-1-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
Date: Tue, 8 Apr 2014 17:51:38 +0100
Message-ID: <CAL3q7H4J5q9aEN=AsrqoVreDHCs8ygyi9rjHK6K=_uuZmquLgA@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfstests: Fix SCRATCH_DEV_POOL handling
From: Filipe David Manana <fdmanana@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 8, 2014 at 4:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> With changes introduced in 667308dd97bf41382d4ab299fa5b56c235cfeb27
> it is no longer possible to use SCRATCH_DEV_POOL variable because of
> error:
>
>  common/config: Error: $SCRATCH_DEV should be unset when
>  $SCRATCH_DEV_POOL is set
>
> This was because get_next_config() would get called twice and hence it
> would complain on the second run that SCRATCH_DEV is already set. Fix
> it by making sure that we call get_next_config() only once if there
> are no sections in the config file.
>
> Also make sure that we export SCRATCH_DEV in the case we're deducing it
> from SCRATCH_DEV_POOL.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Filipe David Manana <fdmanana@gmail.com>

Tested-by: Filipe David Manana <fdmanana@gmail.com>

Tests working for btrfs now.
Thanks Lukas.

> ---
>  common/config | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/common/config b/common/config
> index 4178c27..6fa18e2 100644
> --- a/common/config
> +++ b/common/config
> @@ -360,6 +360,10 @@ parse_config_section() {
>  }
>
>  get_next_config() {
> +       if [ ! -z "$CONFIG_INCLUDED" ] && ! $OPTIONS_HAVE_SECTIONS; then
> +               return 0
> +       fi
> +
>         local OLD_FSTYP=$FSTYP
>         local OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
>         local OLD_MKFS_OPTIONS=$MKFS_OPTIONS
> @@ -414,10 +418,11 @@ get_next_config() {
>         # to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
>         if [ ! -z "$SCRATCH_DEV_POOL" ]; then
>                 if [ ! -z "$SCRATCH_DEV" ]; then
> -                       echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
> +                       echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) should be unset when \$SCRATCH_DEV_POOL ($SCRATCH_DEV_POOL) is set"
>                         exit 1
>                 fi
>                 SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> +               export SCRATCH_DEV
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
