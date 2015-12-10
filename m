Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36799 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbbLJR03 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 12:26:29 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1448878644-16503-2-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1448878644-16503-2-git-send-email-chandan@linux.vnet.ibm.com>
Date: Thu, 10 Dec 2015 17:26:28 +0000
Message-ID: <CAL3q7H7_RxjvP5v4BtKWzpP6WoW6xpUfBcuyU9jVBkBtLuYi_Q@mail.gmail.com>
Subject: Re: [PATCH 1/8] Filter xfs_io's output in units of page size
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 10:17 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> The helpers introduced in this commit will be used to make btrfs tests that
> assume 4k as the page size to work on non-4k page-sized systems as well.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks!

> ---
>  common/filter | 8 ++++++++
>  common/rc     | 6 ++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/common/filter b/common/filter
> index 05f2fab..1be377c 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -261,6 +261,14 @@ _filter_xfs_io_blocks_modified()
>         _filter_xfs_io_units_modified "Block" $BLOCK_SIZE
>  }
>
> +_filter_xfs_io_pages_modified()
> +{
> +       PAGE_SIZE=$(get_page_size)
> +
> +       _filter_xfs_io_units_modified "Page" $PAGE_SIZE
> +}
> +
> +
>  _filter_test_dir()
>  {
>         sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
> diff --git a/common/rc b/common/rc
> index 4c2f42c..82c1bbb 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3151,6 +3151,12 @@ get_block_size()
>         echo `stat -f -c %S $1`
>  }
>
> +get_page_size()
> +{
> +       echo $(getconf PAGE_SIZE)
> +}
> +
> +
>  init_rc
>
>  ################################################################################
> --
> 2.1.0
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
