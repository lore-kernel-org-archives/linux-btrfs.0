Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53128 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbaDHQwX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 12:52:23 -0400
Received: by mail-bk0-f52.google.com with SMTP id my13so774669bkb.39
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 09:52:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1396971770-23553-3-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
	<1396971770-23553-3-git-send-email-lczerner@redhat.com>
Date: Tue, 8 Apr 2014 17:52:21 +0100
Message-ID: <CAL3q7H4=qTzrayoeMpWagt44Br6zJ+fQvZk5OpYMXrWU=MWVpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfstests: Fix setting FSTYP automatically
From: Filipe David Manana <fdmanana@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 8, 2014 at 4:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> Currently if the FSTYP is not set, the code to get FSTYP using blikd
> would not work. This is because we're using HOSTOS environment variable
> which might not be set (at least not on my system) and because it's
> already late in the code path.
>
> Fix this by using OSTYP environment variable as a fallback in the case
> that HOSTOS does not work and move the check to common/config.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Tested-by: Filipe David Manana <fdmanana@gmail.com>

Tests working for btrfs now.
Thanks Lukas.

> ---
>  check         |  8 --------
>  common/config | 18 +++++++++++++-----
>  2 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/check b/check
> index 8f1a6e1..ed1834d 100755
> --- a/check
> +++ b/check
> @@ -58,14 +58,6 @@ then
>      exit 1
>  fi
>
> -# Autodetect fs type based on what's on $TEST_DEV unless it's been set
> -# externally
> -if [ -z "$FSTYP" -a "$HOSTOS" == "Linux" ]; then
> -    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> -fi
> -FSTYP=${FSTYP:=xfs}
> -export FSTYP
> -
>  SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
>  SRC_GROUPS="generic shared"
>  export SRC_DIR="tests"
> diff --git a/common/config b/common/config
> index 3163801..00249e6 100644
> --- a/common/config
> +++ b/common/config
> @@ -297,11 +297,6 @@ _fsck_opts()
>         esac
>  }
>
> -[ -z "$FSTYP" ] && export FSTYP=xfs
> -[ -z "$MOUNT_OPTIONS" ] && _mount_opts
> -[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
> -[ -z "$FSCK_OPTIONS" ] && _fsck_opts
> -
>  known_hosts()
>  {
>         [ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
> @@ -446,6 +441,19 @@ get_next_config() {
>  if [ -z "$CONFIG_INCLUDED" ]; then
>         get_next_config `echo $HOST_OPTIONS_SECTIONS | cut -f1 -d" "`
>         export CONFIG_INCLUDED=true
> +
> +       # Autodetect fs type based on what's on $TEST_DEV unless it's been set
> +       # externally
> +       if [ -z "$FSTYP" ] && \
> +          [ "$HOSTOS" == "Linux" -o "$OSTYPE" == "linux-gnu" ] && \
> +          [ ! -z "$TEST_DEV" ]; then
> +               FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> +       fi
> +       FSTYP=${FSTYP:=xfs}
> +       export FSTYP
> +       [ -z "$MOUNT_OPTIONS" ] && _mount_opts
> +       [ -z "$MKFS_OPTIONS" ] && _mkfs_opts
> +       [ -z "$FSCK_OPTIONS" ] && _fsck_opts
>  fi
>
>  # make sure this script returns success
> --
> 1.8.3.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
