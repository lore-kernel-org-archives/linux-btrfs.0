Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34474 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbCTM7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 08:59:15 -0400
Received: by iedfl3 with SMTP id fl3so1493218ied.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 05:59:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150320123922.GL20767@twin.jikos.cz>
References: <9389540.MYekrP2a8Q@merkaba>
	<1929370.YSr7hGqtmM@merkaba>
	<20150318135230.GA20767@twin.jikos.cz>
	<7757761.93uGJVH8dW@merkaba>
	<20150319132139.GE20767@twin.jikos.cz>
	<CAL3q7H7A349PzQ=z+YGHukWNfG_Y8EyChZV6Tr944gYsgPf-_Q@mail.gmail.com>
	<20150320123922.GL20767@twin.jikos.cz>
Date: Fri, 20 Mar 2015 12:59:14 +0000
Message-ID: <CAL3q7H5ycuGP=LFsC0Pm7uhO5OxrjzLfEXq-wkVZMHd9rJ5Bkw@mail.gmail.com>
Subject: Re: number of hardlinks for directory in ls -lid always 1?
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 12:39 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Mar 19, 2015 at 09:47:15PM +0000, Filipe David Manana wrote:
>> On Thu, Mar 19, 2015 at 1:21 PM, David Sterba <dsterba@suse.cz> wrote:
>> > On Wed, Mar 18, 2015 at 03:23:50PM +0100, Martin Steigerwald wrote:
>> >> It explains that having a correct hardlink number for directory is not
>> >> mandatory, but it doesn´t explain why BTRFS always has 1 in there instead
>> >> of the actual count of hardlinks. Is this an performance optimization for
>> >> BTRFS or are there any other reasons why BTRFS does it this way?
>> >
>> > I believe it's for performance reasons. New inodes do not update the
>> > parent directory metadata wrt link counts, compared to other filesystems
>> > that do that.
>>
>> Weird. Because creating a new inode implies adding the dentry to the
>> parent directory, which implies updating the directory's i_size.
>
> I wonder why the link count is not maintained then. The directory inode
> is modified anyway, add a few ifs here and there will not make things
> worse and we could get rid of this special behaviour, plus find could
> use the link count reliably.
>
> It can be turned on in a fully backward compatible way:
>
> * new directories/subvolumes will get dir nlink set to 2
> * if mkdir/rmdir/move sees a parent link count of 1, no change
> * otherwise inc/dec the link count for new subdirectoris/subvolumes
>
> Jeff Liu reported a problem, without further details
> http://article.gmane.org/gmane.comp.file-systems.btrfs/14628
>
> so I still might be missing something.

Maybe this was all before delayed inodes were introduced, where
updating inode items always implied touching the btrees.



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
