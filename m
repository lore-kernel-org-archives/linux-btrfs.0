Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55117 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbCSXCs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 19:02:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YYjSd-0000UP-1D
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 00:02:43 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 00:02:42 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 00:02:42 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Date: Fri, 20 Mar 2015 00:02:37 +0100
Message-ID: <d51stb-614.ln1@hurikhan77.spdns.de>
References: <9389540.MYekrP2a8Q@merkaba> <1929370.YSr7hGqtmM@merkaba> <20150318135230.GA20767@twin.jikos.cz> <7757761.93uGJVH8dW@merkaba> <20150319132139.GE20767@twin.jikos.cz> <CAL3q7H7A349PzQ=z+YGHukWNfG_Y8EyChZV6Tr944gYsgPf-_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe David Manana <fdmanana@gmail.com> schrieb:

> On Thu, Mar 19, 2015 at 1:21 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
>>> It explains that having a correct hardlink number for directory is not
>>> mandatory, but it doesn´t explain why BTRFS always has 1 in there
>>> instead of the actual count of hardlinks. Is this an performance
>>> optimization for BTRFS or are there any other reasons why BTRFS does it
>>> this way?
>>
>> I believe it's for performance reasons. New inodes do not update the
>> parent directory metadata wrt link counts, compared to other filesystems
>> that do that.
> 
> Weird. Because creating a new inode implies adding the dentry to the
> parent directory, which implies updating the directory's i_size.

Maybe related to snapshots? Which brings us back to COW and performance:

>> The real performance hit could be noticeable. The directory inode is
>> cached in memory, so first update would be a bit slower, but the
>> metadata block needs to be cow-ed on each new file. It's stress on
>> b-tree locking and allocating new buffers for the metadata blocks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
-- 
Replies to list only preferred.

