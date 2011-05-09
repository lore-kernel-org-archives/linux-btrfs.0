From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.29-rc2] insert_dir_item hitting assertion during log replay
Date: Mon, 09 May 2011 12:03:21 -0400
Message-ID: <4DC81049.1050806@redhat.com>
References: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>	<4DA31F11.90200@redhat.com>	<BANLkTin7nYmOXcHjfS0s77s+-buQW-0cgQ@mail.gmail.com> <BANLkTimWLt9M_NLvkJX-8KphdKF2sjLyBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimWLt9M_NLvkJX-8KphdKF2sjLyBg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2011 09:36 AM, Daniel J Blueman wrote:
> On 12 April 2011 00:07, Daniel J Blueman<daniel.blueman@gmail.com>  wrote:
>> On 11 April 2011 23:32, Josef Bacik<josef@redhat.com>  wrote:
>>> On 04/10/2011 04:29 AM, Daniel J Blueman wrote:
>>>>
>>>> When rebooting from a crash, thus during log replay on 2.6.29-rc2,
>>>> btrfs_insert_dir_item caused an assertion failure [1]. The fs was
>>>> being mounted clear_cache on an SSD.
>>>>
>>>> Probably it's not so easy to reproduce, but better to report it...
>>>>
>>>
>>> Do you still have this fs, and does it still panic the same way on mount?
>>>   Thanks,
>>
>> I still have this fs, though it didn't panic at next mount. I guess
>> this creates a case for cooking a script that eg logically disconnects
>> a block device during activity (hdparm or echo 1>delete) then
>> reconnects it for remount...let me know if interested.
>
> I've hit this a few times recently following a crash in 2.6.39-rc (eg
> with -rc6 [1]) and have found the only way to access the data is mount
> -o ro,notreelog.
>
> I guess btrfs_insert_dir_item is failing due to corruption of the
> directory inode. The only solution here would be to gracefully discard
> the log item being replayed and print a warning that the filesystem
> has corruption, right?
>

Well this is -ENOSPC, so we need to figure out why we're getting ENOSPC 
and fix that, or if it's valid we need to just fail to mount and let the 
user decide if they want to discard the tree log.  Thanks,

Josef
