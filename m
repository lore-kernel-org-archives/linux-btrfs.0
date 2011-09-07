From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -rc6] btrfs: xattr: fix attribute removal
Date: Wed, 07 Sep 2011 11:05:19 +0800
Message-ID: <4E66DF6F.504@cn.fujitsu.com>
References: <1315316025-11138-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315316025-11138-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> An attribute is not removed by 'setfattr -x attr file' and remains
> visible in attr list. This makes xfstests/062 pass again.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
