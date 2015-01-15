Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53264 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598AbbAOAdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 19:33:39 -0500
Message-ID: <54B70AE0.2090203@cn.fujitsu.com>
Date: Thu, 15 Jan 2015 08:33:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: tests, add support for running commands
 under root
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com> <1421256302-8503-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1421256302-8503-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH 1/2] btrfs-progs: tests, add support for running 
commands under root
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月15日 01:25
> Most of the checks run fine without root, but some of them may need to
> do a mount test or access the data. Add the support to selectively run
> commands under root, hardcoded to sudo for now.
I'm a little worried about using sudo in such test.
If the test is ran by a script, test will be stuck waiting for input and 
timeout after a long time.

I prefer NOT RUN just like xfstests.

Thanks
Qu
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
>   tests/common | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/tests/common b/tests/common
> index 80a538165949..84a4b9d335e2 100644
> --- a/tests/common
> +++ b/tests/common
> @@ -47,3 +47,18 @@ check_all_images()
>   		rm $i.restored
>   	done
>   }
> +
> +# some tests need to mount the recovered image and do verifications call
> +# 'setup_root_helper' and then check for have_root_helper == 1 if the test
> +# needs to fail otherwise; using sudo by default for now
> +sudo=
> +have_root_helper=0
> +export sudo
> +export have_root_helper
> +setup_root_helper()
> +{
> +	if [ $UID != 0 ]; then
> +		sudo=sudo
> +	fi
> +	have_root_helper=1
> +}

