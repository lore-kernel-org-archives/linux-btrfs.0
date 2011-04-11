From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.29-rc2] insert_dir_item hitting assertion during log replay
Date: Mon, 11 Apr 2011 11:32:33 -0400
Message-ID: <4DA31F11.90200@redhat.com>
References: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/2011 04:29 AM, Daniel J Blueman wrote:
> When rebooting from a crash, thus during log replay on 2.6.29-rc2,
> btrfs_insert_dir_item caused an assertion failure [1]. The fs was
> being mounted clear_cache on an SSD.
>
> Probably it's not so easy to reproduce, but better to report it...
>

Do you still have this fs, and does it still panic the same way on 
mount?  Thanks,

Josef
