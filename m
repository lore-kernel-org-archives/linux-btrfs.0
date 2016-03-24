Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34550 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbcCXHIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 03:08:55 -0400
Received: by mail-yw0-f176.google.com with SMTP id h129so48643929ywb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 00:08:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
Date: Thu, 24 Mar 2016 18:08:54 +1100
Message-ID: <CALxwgb5BDvuZ4MORsp6i2=34iD0N6uK9=ifZ3bsqR=dT+SBRAA@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Andrew Vaughan <andrewjvaughan@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Brad Templeton <bradtem@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Brad

Just a user here, not a dev.

I think I might have run into a similar bug about 6 months ago.

At the time I was running Debian stable.  (iirc that is kernel 3.16
and probably btrfs-progs of a similar vintage).

The filesystem was originally a 2 x 6TB array with a 4TB drive added
later when space began to get low.  I'm pretty sure I must have done
at least a partial balance after adding the 4TB drive, but something
like 1TB free on each of the two 6GB drives, and 2GB on the 4TB would
have been 'good enough for me'.

It was nearly full again when a copy unexpectedly reported
out-of-space.  Balance didn't fix it.  In retrospect btrfs had
probably run out of chunks on both 6TB drives.

I'm not sure what actually fixed it.  I upgraded to Debian testing
(something I was going to do soon anyway).  I might have also
temporarily added another drive.   (I have since had a 6TB drive fail,
and btrfs is running happily on 2x4TB, and 1x6TB).

More inline below.

On 24 March 2016 at 05:34, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Mar 23, 2016 at 10:51 AM, Brad Templeton <bradtem@gmail.com> wrote:
>> Thanks for assist.  To reiterate what I said in private:
>>
>> a) I am fairly sure I swapped drives by adding the 6TB drive and then
>> removing the 2TB drive, which would not have made the 6TB think it was
>> only 2TB.    The btrfs statistics commands have shown from the beginning
>> the size of the device as 6TB, and that after the remove, it haad 4TB
>> unallocated.
>
> I agree this seems to be consistent with what's been reported.
>

<snip>

>>
>> Some options remaining open to me:
>>
>> a) I could re-add the 2TB device, which is still there.  Then balance
>> again, which hopefully would move a lot of stuff.   Then remove it again
>> and hopefully the new stuff would distribute mostly to the large drive.
>>  Then I could try balance again.
>
> Yeah, to do this will require -f to wipe the signature info from that
> drive when you add it. But I don't think this is a case of needing
> more free space, I think it might be due to the odd number of drives
> that are also fairly different in size.
>
If I recall correctly, when I did a device delete, I thought device
delete did remove the btrfs signature.  But I could be wrong

> But then what happens when you delete the 2TB drive after the balance?
> Do you end up right back in this same situation?
>

If balance manages to get the data properly distributed across the
drives, then the 2TB should be mostly empty, and device delete should
be able to remove the 2TB disk.   I successfully added a 4TB disk, did
a balance, and then removed a failing 6TB from the 3 drive array
above.

>
>>
>> b) It was suggested I could (with a good backup) convert the drive to
>> non-RAID1 to free up tons of space and then re-convert.  What's the
>> precise procedure for that?  Perhaps I can do it with a limit to see how
>> it works as an experiment?   Any way to specifically target the blocks
>> that have their two copies on the 2 smaller drives for conversion?
>
> btrfs balance -dconvert=single -mconvert=single -f   ## you have to
> use -f to force reduction in redundancy
> btrfs balance -dconvert=raid1 -mconvert=raid1

I would probably try upgrading to a newer kernel + btrfs-progs first.
Before converting back to raid1, I would also run btrfs device usage
and check to see whether the all devices have approximately the same
amount of unallocated space.  If they don't, maybe try running a full
balance again.

<snip>

Andrew
