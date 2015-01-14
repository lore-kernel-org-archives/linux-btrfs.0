Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57063 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbbANBMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 20:12:19 -0500
Date: Tue, 13 Jan 2015 20:12:04 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: avoid build warning on 32-bit
To: <dsterba@suse.cz>
CC: Arnd Bergmann <arnd@arndb.de>, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <1421197924.21014.17@mail.thefacebook.com>
In-Reply-To: <20150114001606.GQ3685@twin.jikos.cz>
References: <4264141.3m7C7LgF5c@wuerfel>
	<20150114001606.GQ3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 7:16 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Jan 13, 2015 at 03:09:03PM +0100, Arnd Bergmann wrote:
>>  A recent change introduced a type cast from a private 64-bit
>>  value to a pointer, which works fine on 64-bit architectures,
>>  but not on 32-bit ones, where it produces a harmless compiler
>>  warning:
>> 
>>  fs/btrfs/extent_io.c: In function 'btrfs_free_io_failure_record':
>>  fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer 
>> of different size [-Wint-to-pointer-cast]
>> 
>>  This adds an intermediate cast to 'unsigned long', which tells
>>  the compiler to ignore the type mismatch.
>> 
>>  Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>  Fixes: f612496bca664 ("Btrfs: cleanup the read failure record after 
>> write
>>  			or when the inode is freeing")
> 
> Already reported, but not merged

I'll take the original cast one for now and we can do the larger 
cleanup for the next merge window.

-chris

