Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:51461 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3BEC77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 21:59:59 -0500
Received: by mail-qc0-f170.google.com with SMTP id d42so2942876qca.15
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2013 18:59:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <441f44ee-a354-4c03-86f3-ce37141cdc1c@email.android.com>
References: <20130202160212.GB4694@shiny>
	<51102B40.6000207@zytor.com>
	<20130205012316.GB28437@shiny>
	<441f44ee-a354-4c03-86f3-ce37141cdc1c@email.android.com>
Date: Tue, 5 Feb 2013 13:59:58 +1100
Message-ID: <CA+WRLO8Wkicve7AwHEvfYnKOLYXCLmJWUZsYPARwABf=LJ2nog@mail.gmail.com>
Subject: Re: experimental raid5/6 code in git
From: Gareth Pye <gareth@cerberos.id.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I felt like having a small play with this stuff, as I've been wanting
it for so long :)

But apparently I've made some incredibly newb error.

I used the following two lines to check out the code:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
raid56-experimental
git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
raid56-experimental-progs

Then I did not very much to compile both of them (installed lots and
lots of packages that various places told me would be needed so they'd
both compile) finishing up with a "sudo make install" for both the
kernel and the tools.
Rebooting miracuously it came up with the new kernel and uname -a
assures me that I have a new kernel running:
btrfs@ubuntu:/kernel/raid56-experimental$ uname -a
Linux ubuntu 3.6.0+ #1 SMP Tue Feb 5 12:26:03 EST 2013 x86_64 x86_64
x86_64 GNU/Linux
but 3.6.0 sounds rather low, but it is newer than Ubuntu 12.10's 3.5
so I believe I am running the kernel I just compiled

Where things fail is that I can figure out how to make a raid5 btrfs,
I'm certain I'm using the mkfs.btrfs that I just compiled (by
explicitly calling it in the make folder) but it wont recognise what I
assume the parameter to be:
btrfs@ubuntu:/kernel/raid56-experimental-progs$ ./mkfs.btrfs -m raid5
-d raid5 /dev/sd[bcdef]
Unknown profile raid5

Which flavour of newb am I today?

PS: I use newb in a very friendly way, I feel no shame over that term :)

On Tue, Feb 5, 2013 at 1:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Also, a 2-member raid5 or 3-member raid6 are a raid1 and can be treated as such.
>
> Chris Mason <chris.mason@fusionio.com> wrote:
>
>>On Mon, Feb 04, 2013 at 02:42:24PM -0700, H. Peter Anvin wrote:
>>> @@ -1389,6 +1392,14 @@ int btrfs_rm_device(struct btrfs_root *root,
>>char
>>> *device_path)
>>>      }
>>>      btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
>>>
>>> +    if ((all_avail & (BTRFS_BLOCK_GROUP_RAID5 |
>>> +                      BTRFS_BLOCK_GROUP_RAID6) && num_devices <= 3)) {
>>> +            printk(KERN_ERR "btrfs: unable to go below three devices "
>>> +                   "on raid5 or raid6\n");
>>> +            ret = -EINVAL;
>>> +            goto out;
>>> +    }
>>> +
>>>      if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
>>>              printk(KERN_ERR "btrfs: unable to go below four devices "
>>>                     "on raid10\n");
>>> @@ -1403,6 +1414,21 @@ int btrfs_rm_device(struct btrfs_root *root,
>>char
>>> *device_path)
>>>              goto out;
>>>      }
>>>
>>> +    if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
>>> +        root->fs_info->fs_devices->rw_devices <= 2) {
>>> +            printk(KERN_ERR "btrfs: unable to go below two "
>>> +                   "devices on raid5\n");
>>> +            ret = -EINVAL;
>>> +            goto out;
>>> +    }
>>> +    if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
>>> +        root->fs_info->fs_devices->rw_devices <= 3) {
>>> +            printk(KERN_ERR "btrfs: unable to go below three "
>>> +                   "devices on raid6\n");
>>> +            ret = -EINVAL;
>>> +            goto out;
>>> +    }
>>> +
>>>      if (strcmp(device_path, "missing") == 0) {
>>>              struct list_head *devices;
>>>              struct btrfs_device *tmp;
>>>
>>>
>>> This seems inconsistent?
>>
>>Whoops, missed that one.  Thanks!
>>
>>-chris
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
