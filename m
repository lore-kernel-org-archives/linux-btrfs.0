Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3JAUuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 16:50:14 -0400
Message-ID: <524B3585.1060407@linux.intel.com>
Date: Tue, 01 Oct 2013 13:50:13 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Issue building a file based rootfs image with mkfs.btrfs
References: <523B4036.7030204@linux.intel.com> <20130928122952.31924.54312@localhost.localdomain>
In-Reply-To: <20130928122952.31924.54312@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2013 05:29 AM, Chris Mason wrote:
> Quoting Saul Wold (2013-09-19 14:19:34)
>> Hi there,
>>
>> I am attempting to build a rootfs image from an existing rootfs
>> directory tree.  I am using the 0.20 @ 194aa4a of Chris's git repo.
>>
>> The couple problem I saw was that the target image file needed to exist,
>> although I think I can patch that then the FS size was much larger than
>> the actual size, I tracked this to the usage of ftw not accounting for
>> symlinks, I have a patch for that which I will send once I finish
>> getting the other issues resolved.
>>
>> Next issue I hit was an assertion failure after getting "not enough free
>> space" message:
>>
>> not enough free space
>> add_file_items failed
>> unable to traverse_directory
>> Making image is aborted.
>> mkfs.btrfs: mkfs.c:1542: main: Assertion `!(ret)' failed.
>>
>> I am kind of stuck on this one, took it as far as I can right now.
>> Would I be better off dropping back to 0.19 or can we move forward
>> fixing this?
>
> Hi Saul,
>
> Update on my end, the problem is the image code expects every file to
> fit inside a single chunk.  It's only creating 8MB chunks, so any file
> over 8MB in size is causing problems.
>
> I'm fixing it up here, I should have a patch for you on Monday.
>
Any update on this?  Just curious.

Thanks
	Sau!

> Thanks!
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
