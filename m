Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.ctyme.com ([184.105.182.179]:32976 "EHLO mail.ctyme.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbcCWQvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 12:51:31 -0400
Reply-To: bradtem@gmail.com
Subject: Re: RAID-1 refuses to balance large drive
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Brad Templeton <bradtem@gmail.com>
Message-ID: <56F2C991.9080500@gmail.com>
Date: Wed, 23 Mar 2016 09:51:29 -0700
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for assist.  To reiterate what I said in private:

a) I am fairly sure I swapped drives by adding the 6TB drive and then
removing the 2TB drive, which would not have made the 6TB think it was
only 2TB.    The btrfs statistics commands have shown from the beginning
the size of the device as 6TB, and that after the remove, it haad 4TB
unallocated.

b) Even if my memory is wrong and I did a replace (that's not even
documented in the wiki page on multiple device so I did not think I had
heard of it) I have since does a resize to "max" on all devices, and
still the balance moves nothing.   It says it processes almost all the
blocks it sees, but nothing changes.

So I am looking for other options, or if people have commands I might
execute to diagnose this (as it seems to be a flaw in balance) let me know.

Some options remaining open to me:

a) I could re-add the 2TB device, which is still there.  Then balance
again, which hopefully would move a lot of stuff.   Then remove it again
and hopefully the new stuff would distribute mostly to the large drive.
 Then I could try balance again.

b) It was suggested I could (with a good backup) convert the drive to
non-RAID1 to free up tons of space and then re-convert.  What's the
precise procedure for that?  Perhaps I can do it with a limit to see how
it works as an experiment?   Any way to specifically target the blocks
that have their two copies on the 2 smaller drives for conversion?

c) Finally, I could take a full-full backup (my normal backups don't
bother with cached stuff and certain other things that you can recover)
and take the system down for a while to just wipe and restore the
volumes.  That doesn't find the bug, however.

On 03/22/2016 11:17 PM, Chris Murphy wrote:
> On Tue, Mar 22, 2016 at 11:54 PM, Brad Templeton <bradtem@gmail.com> wrote:
>> Actually, the URL suggests that all the space will be used, which is
>> what I had read about btrfs, that it handled this.
> 
> It will. But it does this by dominating writes to the devices that
> have the most free space, until all devices have the same free space.
> 
> 
>> But again, how could it possibly know to restrict the new device to only
>> using 2TB?
> 
> In your case, before resizing it, it's just inheriting the size from
> the device being replaced.
> 
>>
>> Stage one:  Add the new 6TB device.  The 2TB device is still present.
>>
>> Stage two:  Remove the 2TB device.
> 
> OK this is confusing. In your first post you said replaced. That
> suggests you used 'btrfs replace start' rather than 'btrfs device add'
> followed by 'btrfs device remove'. So which did you do?
> 
> If you did the latter, then there's no resize necessary.
> 
> 
>> The system copies everything on it
>> to the device which has the most space, the empty 6TB device.  But you
>> are saying it decides to _shrink_ the 6TB device now that we know it is
>> a 2TB device being removed?
> 
> No I'm not. The source of confusion appears to be that you're
> unfamiliar with 'btrfs replace' so you mean 'dev add' followed by 'dev
> remove' to mean replaced.
> 
> This line:
>         devid    3 size 5.43TiB used 1.42TiB path /dev/sdg2
> 
> suggests it's using the entire 6TB of the newly added drive, it's
> already at max size.
> 
> 
>> We didn't know the 2TB would be removed
>> when we added the 6TB, so I just can't fathom why the code would do
>> that.  In addition, the stats I get back say it didn't do that.
> 
> I don't understand the first part. Whether you asked for 'dev remove'
> or you used 'replace' both of those mean removing some device. You
> have to specify the device to be removed.
> 
> Now might be a good time to actually write out the exact commands you've used.
> 
> 
>>
>> More to the point, after the resize, the balance is still not changing
>> any size numbers.  It should be moving blocks to the most empty device,
>> should it not?    There is almost no space on devids 1 and 2, so it
>> would not copy any chunks there.
>>
>> I'm starting to think this is a bug, but I'll keep plugging.
> 
> Could be a bug. Three drive raid1 of different sizes is somewhat
> uncommon so it's possible it's hit an edge case somehow. Qu will know
> more about how to find out why it's not allocating mostly to the
> larger drive. The eventual work around might end up being to convert
> data chunks to single, then convert back to raid1. But before doing
> that it'd be better to find out why it's not doing the right thing the
> normal way.
> 
> 
