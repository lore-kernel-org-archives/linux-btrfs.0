From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] Add user-space support for read-only snapshot creation.
Date: Tue, 26 Apr 2011 13:42:31 +0800
Message-ID: <4DB65B47.5060803@cn.fujitsu.com>
References: <1303733730-sup-9388@think> <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	dcrmorgado@gmail.com
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Philipp wrote:
> There is kernel side support for the creation of read-only snapshots
> for some time now, but I did not find any patches for the userspace
> btrfs utilites. Thus I created this patchset which is tested and
> working with kernel version 2.6.39-rc2.
> 
> Andreas Philipp (5):
>   Add support for read-only subvolumes.
>   Support the new parameters in do_clone(int argc, char** argv).
>   Added support for an additional ioctl.
>   Test the additional ioctl.
>   Updated documentation for btrfs subvolume snapshot.
> 

Thanks for doing this!
