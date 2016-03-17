Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:34052 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935519AbcCQL0D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 07:26:03 -0400
Received: by mail-qg0-f41.google.com with SMTP id w104so68652662qge.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 04:26:02 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add stat check in open_ctree_fs_info
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1458141971-56355-1-git-send-email-ahferroin7@gmail.com>
 <pan$5827c$2850555c$6b75a991$da57cc2e@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56EA940C.9080707@gmail.com>
Date: Thu, 17 Mar 2016 07:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <pan$5827c$2850555c$6b75a991$da57cc2e@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-17 04:58, Duncan wrote:
> Austin S. Hemmelgarn posted on Wed, 16 Mar 2016 11:26:11 -0400 as
> excerpted:
>
>> Currently, open_ctree_fs_info will open whatever path you pass it and
>> try to interpret it as a BTRFS filesystem.  While this is not
>> nessecarily dangerous (except possibly if done on a character device),
>> it does result in some rather cryptic and non-sensical error messages
>> when trying to run certain commands in ways they weren't intended to be
>> run.  Add a check using stat(2) to verify that the path we've been
>> passed is in fact a regular file or a block device.
>>
>> This causes the following commands to provide a helpful error message
>> when run on a FIFO, directory, character device, or socket:
>
> Umm... what about a symlink?  A symlink isn't a block device or regular
> file, but obviously with udev, symlinks to block devices /better/ work.
> Do you dereference symlinks before doing this check?
>
>
I'm using stat(2) instead of lstat(2), and stat(2) dereferences symlinks 
just like open(2) does, so I shouldn't have to dereference them 
manually.  That said, I did check that it works with symlinks to both 
block devices and regular files, and everything appears to work correctly.
