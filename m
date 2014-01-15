Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:59911 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAOT3X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 14:29:23 -0500
Received: by mail-vb0-f44.google.com with SMTP id x8so588976vbf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 11:29:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140115183918.GF6498@twin.jikos.cz>
References: <CACeaM885anPZOwbAw_2w43vOU8e0zkj-w_drar1sJhpppCsJeA@mail.gmail.com>
	<20140115183918.GF6498@twin.jikos.cz>
Date: Wed, 15 Jan 2014 20:29:22 +0100
Message-ID: <CACeaM88ouFDe0WwYdaLq_8MFG4-UCH3rFowCLYbb3qaJCUcJaw@mail.gmail.com>
Subject: Re: BTRFS_SEARCH_ARGS_BUFSIZE too small
From: Gerhard Heift <gerhard@heift.name>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have already patches for such an ioctl. Which form do you prefer?

struct btrfs_ioctl_search_args_inline {
        struct btrfs_ioctl_search_key key;
        __u64 buf_len
        char buf[0];
};

or

struct btrfs_ioctl_search_args_extern {
        struct btrfs_ioctl_search_key key;
        __u64 buf_len
        char __user *buf;
};

And against which commit should I rebase them?

2014/1/15 David Sterba <dsterba@suse.cz>:
> On Fri, Jan 10, 2014 at 12:44:17AM +0100, Gerhard Heift wrote:
>> I'm playing around with the BTRFS_IOC_SEARCH_TREE to extract the csums
>> of the physical blocks. During the tests some item_header had len = 0,
>> which indicates the buffer was to small to hold the item. I added a
>> printk into the kernel to get the original size of the item and it was
>> around 6600 bytes.
>
> This can happen with the metadata blocks bigger than 4k, the search
> ioctl does not have buffer large enough as you've found. The EXTENT_CSUM
> items seem to cap at 16k, no matter what's the node size (tried with
> 64k).
>
>> Is there another way to get the item? Otherwise I would suggest to
>> create an ioctl, which is a little bit more flexible, something like
>>
>> struct btrfs_ioctl_search_args2 {
>>         struct btrfs_ioctl_search_key key;
>>         __u64 buf_len
>>         char buf[0];
>> };
>
> Yeah, a V2 ioctl has to be introduced, the structure could look like
> this. Kernel would have uo directly copy_to_user to the buffer without
> the intermediate memcpy to the in-kernel copy of the ioctl structure.
>
>
> david
