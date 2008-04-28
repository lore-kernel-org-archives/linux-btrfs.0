From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: [PATCH] Fix btrfs-convert's large file support.
Date: Mon, 28 Apr 2008 23:04:29 +0800
Message-ID: <3d0408630804280804v2e994e06v9bd7e3ee0eed30c4@mail.gmail.com>
References: <13c114d20804272303mf33127bs233b68c8c2244c9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: "Zhu Yanhai" <piggestpig@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <13c114d20804272303mf33127bs233b68c8c2244c9f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/4/28 Zhu Yanhai <piggestpig@gmail.com>:
> Hello,
>  This patch add ext2_inode.i_size_high into account when calculating
> regular file's size in btrfs-convert,  which makes it deal with large files
>  bigger than 4GB properly.
>
Thanks

YZ
