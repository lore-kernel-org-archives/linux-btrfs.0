From: dima <dolenin@parallels.com>
Subject: Re: Unable to mount btrfs partition
Date: Mon, 31 Oct 2011 13:19:11 +0900
Message-ID: <4EAE21BF.9010701@parallels.com>
References: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de> <20111028210947.GM29548@carfax.org.uk> <df08964cfb0f7e20f039e7fdbb970f35@joachim-neu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: <email@joachim-neu.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <df08964cfb0f7e20f039e7fdbb970f35@joachim-neu.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/29/2011 08:45 AM, email@joachim-neu.de wrote:
>
> On Fri, 28 Oct 2011 22:09:47 +0100, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Oct 28, 2011 at 08:36:28PM +0000, email@joachim-neu.de wrote:
>>> Today I downgraded from Ubuntu's APT repo "oneiric-proposed" (which
>>> brings some kernel 3.0.0-13) back to the standard repo "oneiric".
>>
>> It's odd that switching from one 3.0.0 to another would cause
>> something bad to happen. Did something else happen in the process,
>> like a reboot without a clean shutdown? (This includes power loss,
>> suspend and failure to resume, and Alt-SysRq-b).
>
> I agree, but there was no power loss or anything. Maybe the fs didn't
> unmount correctly or fast enough when rebooting?
>
>>> Now I'm not able to mount my btrfs / and /home (both on the same
>>> partition) anymore:
>>>
>>> device fsid SOME-UUID devid 1 transid 84229 /dev/dm-0
>>> parent transid verify failed on 77078528 wanted 83774 found 84226
>>> parent transid verify failed on 77078528 wanted 83774 found 84226
>>> parent transid verify failed on 77078528 wanted 83774 found 84226
>>> parent transid verify failed on 77078528 wanted 83774 found 84226
>>> btrfs: open_ctree failed
>>>
>>> The boot process drops to the initramfs shell with no btrfsck
>>> available.
>>
>> It wouldn't make any difference if it were -- btrfsck doesn't
>> actually fix anything, I'm afraid. This error message is regrettably
>> generic, and covers a whole range of evils. It's possible that 3.1 may
>> be able to deal swith the breakage ufficiently well to allow you to
>> boot and copy your files.
>
> I'll give the 3.1 kernel a try right after "restore" finished which is
> running right now and doing quite a good job so far (as far as my / is
> concerned, lets wait for the /home).

You should definitely try 3.1. There are many improvements for btrfs.
What errors are you getting on the screen and in your logs when you try 
to mount your subvolumes manually when booting from a live CD? Are / and 
/home in different subvolumes by the way?


> What do the above error messages indicate?

Try to google it. It looks like pretty common error that can be caused 
by a bunch of things as Hugo mentioned.


> Is there an incrementing
> number for every transaction and the number of the most recent
> transaction is stored somewhere and those messages occur once those
> numbers are out of sync somehow? Is it possible to "just" discard the
> last transactions? I would not mind, better loose a day than a month...
> Why is the message there three times? Is this information stored in a
> couple of backups? If so: can't I use any of the other backups
> temporarily? "restore" opens the fs in a ro recovery mode somehow where
> it ignores those errors. Is it possible to "force" the btrfs driver to
> load the fs in this recovery mode as readonly, too?


I don't think anything of this is possible.

~d
