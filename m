From: Mat <jackdachef@gmail.com>
Subject: Re: [mount] commit intervall for metadata and btrfs - is it planned ?
Date: Tue, 23 Feb 2010 13:49:04 +0100
Message-ID: <e85b9d31002230449p2f6b62ccg16d6d4029ba1b6ae@mail.gmail.com>
References: <loom.20100210T190536-373@post.gmane.org>
	 <20100210185537.GA20133@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100210185537.GA20133@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 10, 2010 at 7:55 PM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Feb 10, 2010 at 06:15:26PM +0000, Mat wrote:
>> Hi guys,
>>
>> First off: you guys are doing amazing work !
>>
>> btrfs "Better-FS" gets more and more stable, fast and space-efficien=
t than
>> all/most of the other filesystems :)
>>
>>
>> It being able to survive compiling of openoffice, chromium webbrowse=
r and other
>> stressful stuff is a testament to its ever growing maturity
>>
>>
>> Now on to my question:
>>
>> Since I'm using btrfs on more and more test-partitions on my system =
and also am
>> into energy saving:
>>
>> is the following mount-option which exists for reiserfs, ext2-4 and =
reiser4
>> (tmgr.atom_max_age) also planned to be implemented for btrfs ?
>>
>> =A0 =A0 =A0 =A0commit=3Dnrsec
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Sync all data and metadata =A0every =A0n=
rsec =A0seconds. =A0The =A0default
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 value is 5 seconds. Zero means default.
>>
>> (in this case ext3)
>>
>> if yes, when will it be added ?
>>
>>
>
> It would be simple enough to do, but keep in mind that btrfs doesnt a=
ct like
> ext2/3 does, so the commit doesn't necessarily mean _all_ data will g=
o down to
> disk, just data thats been allocated and writeout has been started on=
, which is
> mostly controlled by the vm's dirty writeback stuff or if the apps yo=
u use have
> been using fsync(). =A0Any metadata thats been dirtied will be sync'e=
d every 30
> seconds. =A0Doing much more than that is just widening the window for=
 you to lose
> new files and stuff (again, if they've not been fsync()'ed). =A0Perso=
nally 30
> seconds is a good balance between being safe and saving battery life,=
 but I'm
> sure at some point we'll expose the commit interval via a mount optio=
n. =A0Thanks,
>
> Josef
>

Thanks for your answer Josef !

I'll tweak /proc/sys/vm/dirty_writeback_centisecs, the other
/proc/sys/vm/dirty* knobs for now
and stick to the limit of 30 seconds

Regards

Mat
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
