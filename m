Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:51969 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3AIO5d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 09:57:33 -0500
Received: by mail-ia0-f175.google.com with SMTP id 21so1426792iay.34
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2013 06:57:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130109125936.GT20089@twin.jikos.cz>
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
	<20130109125936.GT20089@twin.jikos.cz>
Date: Thu, 10 Jan 2013 01:27:33 +1030
Message-ID: <CACCfv7qAMJGix0phr-XCE2d22zOfvvywNfY2FVou65N0FnmgZA@mail.gmail.com>
Subject: Re: Btrfs fs not mounting or being identified after power loss.
From: Jordan Windsor <jordanw2@gmail.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
here's the output:

[root@archpc btrfs-progs]# ./btrfsck --super 1 /dev/sdb1
using SB copy 1, bytenr 67108864
No valid Btrfs found on /dev/sdb1

Thanks.

On Wed, Jan 9, 2013 at 11:29 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Jan 08, 2013 at 04:10:13PM +1030, Jordan Windsor wrote:
>> /dev/sdb1 is the lost btrfs fs.
>>
>> [root@archpc ~]# btrfs-find-root -v /dev/sdb1
>> No valid Btrfs found on /dev/sdb1
>
>> [root@archpc ~]# btrfsck /dev/sdb1
>> No valid Btrfs found on /dev/sdb1
>
> Looks like the first superblock is partially or completely damaged.
> Btrfsck is able to operate starting from a different superblock
>
>   btrfsck --super 1 /dev/sdb1
>
> to see if there are other valid copies.
>
> david
