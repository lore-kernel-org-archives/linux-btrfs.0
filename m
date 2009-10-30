From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Way to quickly "revert back" to a snapshot?
Date: Fri, 30 Oct 2009 15:52:16 +0900
Message-ID: <4AEA8D20.3020504@jp.fujitsu.com>
References: <4AD9FCDC.6060107@ubuntu.com> <20091026093842.GF5564@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, zheng.yan@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091026093842.GF5564@think>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to make this snapshots/subvolumes listing feature,
I wonder how the interface should be.

I tried to make this feature using ioctl interface, but I don't
know how to notify all subvolume informations because number
of subvolumes are not known before search.
(It may work, that we call number-notify ioctl before subvol-
 listing ioctl itself, or we call subvol-listing ioctl repeatedly
 to last subvolume. But both seem to be not good to me.)

Is there any other idea?

Chris Mason wrote:
> On Sat, Oct 17, 2009 at 01:20:28PM -0400, John Dong wrote:
>> Suppose I want to do test something insane (like a massive OS
>> update) to my system, and create a snapshot before doing so.
>> Afterwards, if I decide my system is hosed and I'd like to revert
>> back to the snapshot and forget any of this actually happened,
>> what's the quickest way of doing it. It seems like by btrfs's design
>> there should be a way to just "set the head" of the filesystem back
>> to the snapshot, like git-reset, right?
> 
> This is near the top of the list of features I want to add for 2.6.33.
> Basically all we need is a way to swap the default subvolume (which is
> just a directory entry) pointer with another subvolume.
> 
> We also want a way to find an snapshot all the subvolumes and snapshots
> underneath a given root.  That way the user won't have to do it
> manually (snapshotting isn't recursive by default).
> 
> If anyone is interested in a coding project, both are fairly easy, just
> let me know.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
taruisi

