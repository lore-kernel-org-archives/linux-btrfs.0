Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42699 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaA1Ach (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 19:32:37 -0500
Received: by mail-ve0-f179.google.com with SMTP id jx11so4008590veb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 16:32:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140127172835.GB6498@twin.jikos.cz>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
	<1390829312-814-3-git-send-email-Gerhard@Heift.Name>
	<20140127172835.GB6498@twin.jikos.cz>
Date: Tue, 28 Jan 2014 01:32:36 +0100
Message-ID: <CACeaM89+t0dse3znsq5_YrEemMCLt5KdJ9kxLqNOMYj8LkqkOw@mail.gmail.com>
Subject: Re: [PATCH RFCv2 2/6] btrfs: search_ioctl rejects unused setted values
From: Gerhard Heift <gerhard@heift.name>
To: David Sterba <dsterba@suse.cz>, Gerhard Heift <gerhard@heift.name>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-27 David Sterba <dsterba@suse.cz>:
> On Mon, Jan 27, 2014 at 02:28:28PM +0100, Gerhard Heift wrote:
>> To prevent unexpectet values in the unused fields of the search key fail early.
>> Otherwise future extensions would break the behavior of the search if current
>> implementations in userspace set them to values other than zero.
>>
>> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1947,6 +1947,9 @@ static noinline int search_ioctl(struct inode *inode,
>>       if (buf_size < sizeof(struct btrfs_ioctl_search_header))
>>               return -EOVERFLOW;
>>
>> +     if (sk->unused || sk->unused1 | sk->unused2 | sk->unused3 | sk->unused4)
>> +             return -EINVAL;
>
> The pattern that's been used for forward/backward compatibility is to
> zero the unused or reserved fields on the userspace side and ignore them
> completely in kernel.

OK, I will dismiss this patch.

> If any future version of the ioctl uses the now unused fields, it also
> has to increase the version.

Just for me to learn: If we have to increase the version, why do we
have the unused fields anyway? We could expand the struct on demand if
we need new fields. Do I miss something?
