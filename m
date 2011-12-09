From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix ctime update of on-disk inode
Date: Fri, 09 Dec 2011 10:12:39 +0800
Message-ID: <4EE16E97.6080100@cn.fujitsu.com>
References: <4EE16713.2070907@cn.fujitsu.com> <20111209020350.GA29118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111209020350.GA29118@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Fri, Dec 09, 2011 at 09:40:35AM +0800, Li Zefan wrote:
>> To reproduce the bug:
>>
>>     # touch /mnt/tmp
>>     # stat /mnt/tmp | grep Change
>>     Change: 2011-12-09 09:32:23.412105981 +0800
>>     # chattr +i /mnt/tmp
>>     # stat /mnt/tmp | grep Change
>>     Change: 2011-12-09 09:32:43.198105295 +0800
>>     # umount /mnt
>>     # mount /dev/loop1 /mnt
>>     # stat /mnt/tmp | grep Change
>>     Change: 2011-12-09 09:32:23.412105981 +0800
>>
>> We should update ctime of in-memory inode before calling
>> btrfs_update_inode().
> 
> Can you submit this one as a test for xfstests?
> 

Sure.
