From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: can't mount RAID-1 btrfs after reboot
Date: Mon, 31 Aug 2009 01:09:46 +0200
Message-ID: <4A9B06BA.7060701@wpkg.org>
References: <4A852FB2.2030205@wpkg.org> <20090814104109.GO12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090814104109.GO12579@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

Jens Axboe wrote:

>> I'm able to mount the filesystem by using /dev/sdb4:
>>
>> # mount /dev/sdb4 /mnt/btrfs/
>>
>> After which I can unmount it, and use /dev/sda4 to mount the filesystem:
>>
>> # umount /dev/sdb4
>> # mount /dev/sda4 /mnt/btrfs/
> 
> Try btrfsctl -a first.

It seems to do the trick.

I suppose longer term, doing "btrfsctl -a" before mounting a (RAID) 
btrfs filesystem shouldn't be needed, or?


-- 
Tomasz Chmielewski
http://wpkg.org

