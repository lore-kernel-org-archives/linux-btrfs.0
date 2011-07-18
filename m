From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs
 utilities in Documentation/filesystems/btrfs.txt
Date: Mon, 18 Jul 2011 14:06:52 +0800
Message-ID: <4E23CD7C.30902@cn.fujitsu.com>
References: <4E23BC5F.4060200@gmail.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E23BC5F.4060200@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2011 12:53 PM, Wang Sheng-Hui wrote:
> The patch is against 3.0-rc7 kernel.
>
>> From d22497ac8c5dd55a2ef9a47de5f2ddee55f8ec50 Mon Sep 17 00:00:00 2001
> From: Wang Sheng-Hui<shhuiw@gmail.com>
> Date: Sun, 17 Jul 2011 21:45:01 -0500
> Subject: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs utilities in Documentation/filesystems/btrfs.txt
>
> git repository link for btrfs utilities
>     http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
> doesn't work, and git-clone can get failed as:
> $ git clone
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
> Initialized empty Git repository in
> /home/crossover/dev/btrfs-progs-unstable/.git/
> fatal:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git/info/refs not found: did you run git update-server-info on the server?
>
> Update git repository links for btrfs utilities to the latest ones
> in Documentation/filesystems/btrfs.txt
>
> Signed-off-by: Wang Sheng-Hui<shhuiw@gmail.com>
> ---
>   Documentation/filesystems/btrfs.txt |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index 64087c3..b095261 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -63,8 +63,9 @@ IRC network.
>   Userspace tools for creating and manipulating Btrfs file systems are
>   available from the git repository at the following location:
>
> - http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
It's the right git-web URL.
>    git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> + http://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> + https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
>
>   These include the following tools:
>


-- 
Thanks
Best Regards
Wanlong Gao
