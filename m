Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:42085 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab3ESOtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 10:49:41 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4JEncrX031576
	for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 10:49:38 -0400
Message-ID: <5198E688.30402@chinilu.com>
Date: Sun, 19 May 2013 07:49:44 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support
References: <518CFE3A.3080900@chinilu.com> <knabiu$akg$1@ger.gmane.org>
In-Reply-To: <knabiu$akg$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In reply to both of these comments in one message, let me give you an 
example.

I use shell scripts to mount and unmount btrfs volumes for backup 
purposes.  Most of these volumes are not listed in fstab simply because 
I do not want to have to clutter my fstab with volumes that are used 
only for backup.  So the only way I can mount them is either by LABEL or 
by UUID.  But I can't unmount them by either LABEL or UUID because that 
is not supported by util-linux and they have no intention of supporting 
it in the future.  So I have to resort to unmounting by directory and it 
becomes back and forth between LABEL and directory which becomes very 
confusing when you are dealing with complex shell scripts.  This is 
intolerable for me so I use a kludge that allows me to first translate 
from LABEL to device and then unmount by device.  To me it just seems 
klutzy that one has to resort to these sorts of games to use a file 
system that is supposed to be an improvement on what we already have.  A 
simple virtual volume identifier would resolve that. Doing the same for 
subvolumes would be nice, but I could live without it with no problem.  
I have worked with nixes for 30 years beginning with AT&T pre-SRV on 
DEC-1170s and have seen a lot of changes since those days, most of them 
for the better.  But, while functionality is mandatory, convenience is 
always appreciated and can help avoid costly mistakes and save time.  As 
I stated in my original post, I KNOW and appreciate that all of you are 
working hard on things that matter far more than this trivial item.  But 
it is a major convenience and clarity issue for me and I am sure it will 
be for others as well.  It is only rational that one should be able to 
expect to mount by LABEL and unmount by LABEL, but that doesn't work, 
and a major part of the reason that doesn't work is that btrfs does not 
conform to the pattern of just about every other file system on the 
planet in regards to how it treats mount points.  And this is not even 
to mention all the other issues involved like a large number of 
utilities that have no way of knowing that a given partition is mounted, 
which would also be resolved by virtual mount points since many if not 
most of those utilities understand and process virtual volume identifiers.

Please just do me a favor and think about this a bit before you just 
write it off.

- George



On 05/19/2013 04:04 AM, Martin wrote:
> On 10/05/13 15:03, George Mitchell wrote:
>> One the things that is frustrating me the most at this point from a user
>> perspective ...  The current method of simply using a
>> random member device or a LABEL or a UUID is just not working well for
>> me.  Having a well thought out virtual device infrastructure would...
> Sorry, I'm a bit lost for your comments...
>
> What is your use case and what are you hoping/expecting to see?
>
>
> I've been following development of btrfs for a while and I'm looking
> forward to use it to efficiently replace some of the very useful
> features of LVM2, drbd, and md-raid that I'm using at present...
>
> OK, so the way of managing all that is going to be a little different.
>
> How would you want that?
>
>
> Regards,
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

On 05/19/2013 04:15 AM, Roman Mamedov wrote:
> On Fri, 10 May 2013 07:03:38 -0700
> George Mitchell <george@chinilu.com> wrote:
>
>> One the things that is frustrating me the most at this point from a user
>> perspective regarding btrfs is the current lack of virtual devices to
>> describe volumes and subvolumes.
>  From a user perspective btrfs subvolumes have a lot in common with just
> regular directories aka folders, and nothing in common with (block)devices.
> "Describing them with virtual devices" does not seem to make a whole lot of
> sense.
>
