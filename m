From: email@joachim-neu.de
Subject: Re: Unable to mount btrfs partition
Date: Sat, 29 Oct 2011 01:45:32 +0200
Message-ID: <df08964cfb0f7e20f039e7fdbb970f35@joachim-neu.de>
References: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de>
 <20111028210947.GM29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111028210947.GM29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


 On Fri, 28 Oct 2011 22:09:47 +0100, Hugo Mills <hugo@carfax.org.uk> 
 wrote:
> On Fri, Oct 28, 2011 at 08:36:28PM +0000, email@joachim-neu.de wrote:
>> Today I downgraded from Ubuntu's APT repo "oneiric-proposed" (which
>> brings some kernel 3.0.0-13) back to the standard repo "oneiric".
>
>    It's odd that switching from one 3.0.0 to another would cause
> something bad to happen. Did something else happen in the process,
> like a reboot without a clean shutdown? (This includes power loss,
> suspend and failure to resume, and Alt-SysRq-b).

 I agree, but there was no power loss or anything. Maybe the fs didn't 
 unmount correctly or fast enough when rebooting?

>> Now I'm not able to mount my btrfs / and /home (both on the same
>> partition) anymore:
>>
>> device fsid SOME-UUID devid 1 transid 84229 /dev/dm-0
>> parent transid verify failed on 77078528 wanted 83774 found 84226
>> parent transid verify failed on 77078528 wanted 83774 found 84226
>> parent transid verify failed on 77078528 wanted 83774 found 84226
>> parent transid verify failed on 77078528 wanted 83774 found 84226
>> btrfs: open_ctree failed
>>
>> The boot process drops to the initramfs shell with no btrfsck
>> available.
>
>    It wouldn't make any difference if it were -- btrfsck doesn't
> actually fix anything, I'm afraid. This error message is regrettably
> generic, and covers a whole range of evils. It's possible that 3.1 
> may
> be able to deal swith the breakage ufficiently well to allow you to
> boot and copy your files.

 I'll give the 3.1 kernel a try right after "restore" finished which is 
 running right now and doing quite a good job so far (as far as my / is 
 concerned, lets wait for the /home).

 What do the above error messages indicate? Is there an incrementing 
 number for every transaction and the number of the most recent 
 transaction is stored somewhere and those messages occur once those 
 numbers are out of sync somehow? Is it possible to "just" discard the 
 last transactions? I would not mind, better loose a day than a month... 
 Why is the message there three times? Is this information stored in a 
 couple of backups? If so: can't I use any of the other backups 
 temporarily? "restore" opens the fs in a ro recovery mode somehow where 
 it ignores those errors. Is it possible to "force" the btrfs driver to 
 load the fs in this recovery mode as readonly, too?

>> I tried to boot with both the "new" 3.0.0-13 kernel and
>> the old 3.0.0-12 and 3.0.0-11 kernels -- no success. I'm running a
>> live cd right now with 3.0.0-12 and I get the above error no matter
>> what I do: no mount, no fsck, no nothing.
>>
>> I really hope someone can help me get my data back...
>
>    You could try using a 3.1 kernel, as I suggested above. Failing
> that, in josef's git repository at [1], you will find a tool called
> "restore". This should allow you to copy any files that had been
> modified since your last backup. If you haven't got backups, you
> *really* should look into getting some before continuing to use a
> filesystem marked as EXPERIMENTAL...
>
>    Hugo.

 Thanks a lot for your help so far. I hope "restore" will do the trick, 
 if not I'll give kernel 3.1 a try.

 Joachim

>
> [1] https://github.com/josefbacik/btrfs-progs

