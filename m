From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.29-rc2] insert_dir_item hitting assertion during log replay
Date: Tue, 12 Apr 2011 00:07:20 +0800
Message-ID: <BANLkTin7nYmOXcHjfS0s77s+-buQW-0cgQ@mail.gmail.com>
References: <BANLkTi=M5q6WbkgNMURWkBCi-46E6-UOkA@mail.gmail.com>
	<4DA31F11.90200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA31F11.90200@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11 April 2011 23:32, Josef Bacik <josef@redhat.com> wrote:
> On 04/10/2011 04:29 AM, Daniel J Blueman wrote:
>>
>> When rebooting from a crash, thus during log replay on 2.6.29-rc2,
>> btrfs_insert_dir_item caused an assertion failure [1]. The fs was
>> being mounted clear_cache on an SSD.
>>
>> Probably it's not so easy to reproduce, but better to report it...
>>
>
> Do you still have this fs, and does it still panic the same way on mo=
unt?
> =A0Thanks,

I still have this fs, though it didn't panic at next mount. I guess
this creates a case for cooking a script that eg logically disconnects
a block device during activity (hdparm or echo 1 >delete) then
reconnects it for remount...let me know if interested.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
