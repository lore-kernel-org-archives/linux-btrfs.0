Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34722 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbCSVrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 17:47:16 -0400
Received: by igcau2 with SMTP id au2so18858037igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 14:47:15 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150319132139.GE20767@twin.jikos.cz>
References: <9389540.MYekrP2a8Q@merkaba>
	<1929370.YSr7hGqtmM@merkaba>
	<20150318135230.GA20767@twin.jikos.cz>
	<7757761.93uGJVH8dW@merkaba>
	<20150319132139.GE20767@twin.jikos.cz>
Date: Thu, 19 Mar 2015 21:47:15 +0000
Message-ID: <CAL3q7H7A349PzQ=z+YGHukWNfG_Y8EyChZV6Tr944gYsgPf-_Q@mail.gmail.com>
Subject: Re: number of hardlinks for directory in ls -lid always 1?
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Martin Steigerwald <martin@lichtvoll.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 1:21 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
>> It explains that having a correct hardlink number for directory is not
>> mandatory, but it doesn´t explain why BTRFS always has 1 in there instead
>> of the actual count of hardlinks. Is this an performance optimization for
>> BTRFS or are there any other reasons why BTRFS does it this way?
>
> I believe it's for performance reasons. New inodes do not update the
> parent directory metadata wrt link counts, compared to other filesystems
> that do that.

Weird. Because creating a new inode implies adding the dentry to the
parent directory, which implies updating the directory's i_size.

>
> The real performance hit could be noticeable. The directory inode is
> cached in memory, so first update would be a bit slower, but the
> metadata block needs to be cow-ed on each new file. It's stress on
> b-tree locking and allocating new buffers for the metadata blocks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
