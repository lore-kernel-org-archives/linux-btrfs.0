Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63568 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3ISQyx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 12:54:53 -0400
Received: by mail-wi0-f174.google.com with SMTP id hj3so8267051wib.7
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 09:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523B2455.4000609@redhat.com>
References: <1379536166-19232-1-git-send-email-jbacik@fusionio.com>
	<20130918211325.GB4330@dastard>
	<523B2455.4000609@redhat.com>
Date: Thu, 19 Sep 2013 19:54:52 +0300
Message-ID: <CAOi1vP_w25B7Lui3CYPXvbvSFdO1-xdjxJySHfi3x1164W1+Eg@mail.gmail.com>
Subject: Re: [PATCH] xfstests: unify apostrophes in output files
From: Ilya Dryomov <idryomov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <jbacik@fusionio.com>,
        xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 19, 2013 at 7:20 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> xfstests: unify apostrophes in output files
>
> From: Tomas Racek <tracek@redhat.com>
>
> With coreutils v8.16 the style of apostrophes changed from `word' to
> 'word'. This is breaking some tests which use the older form.
>
> This commit introduces function changes the golden output of the
> affected tests and introduces a filter for the older style output.
>
> [dchinner: modified to use a global filter in check rather than
> per-test filters]
>
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> (Resending as proper top-level, modified, reviewed patch --Eric)
>
>  check                 |  4 ++++
>  common/config         |  1 +
>  tests/generic/193.out | 16 ++++++++--------
>  tests/generic/230.out |  8 ++++----
>  tests/generic/235.out |  2 +-
>  tests/generic/245.out |  2 +-
>  tests/generic/294.out |  8 ++++----
>  tests/generic/306.out |  2 +-
>  tests/xfs/103.out     |  2 +-
>  tests/xfs/200.out     |  2 +-
>  10 files changed, 26 insertions(+), 21 deletions(-)
>
> diff --git a/check b/check
> index 4085eae..ba7fd21 100755
> --- a/check
> +++ b/check
> @@ -478,6 +478,10 @@ do
>                 echo " - no qualified output"
>                 err=true
>             else
> +
> +               # coreutils 2.16+ changed quote formats in error messages from

Should that be 8.16+?

Thanks,

                Ilya
