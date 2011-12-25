From: Evan LeCompte <evanlec@gmail.com>
Subject: Re: FS won't mount, open_ctree failed, Assertion !(path->slots[0]
 == 0) failed
Date: Sun, 25 Dec 2011 19:00:55 +0000
Message-ID: <4EF772E7.10905@gmail.com>
References: <CB041FF1.1FD66%dsmith@tgen.org> <loom.20111223T103108-120@post.gmane.org> <20111223181542.GU19266@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111223181542.GU19266@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/23/2011 06:15 PM, Chris Mason wrote:
> On Fri, Dec 23, 2011 at 09:37:28AM +0000, Evan LeCompte wrote:
>> I'm having the very same issue as you. I've tried all the latest btrfs tools,
>> btrfsck, btrfs-zero-log, restore, find-root etc etc.
>>
>> All to no avail. only err output is always
>>
>> "" btrfs_find_last_root: Assertion `!(path->slots[0] == 0)' failed. ""
>>
>> This is a very cryptic error that doesn't tell me anything. and it seems to be
>> the only error that is ever thrown when transaction id's get out of sync.
>>
>> Is there ANY way to even recover ANY files at all from these btrfs filesystems
>> that lose transid sync? mine occurred simply from a loose sata cable falling out
>> of one of my drives while the system was running.
>>
>> This is extremely frustrating, but I guess I have no one to blame but myself. I
>> do have a backup but its about a month old (my cron backup script died for some
>> reason and I didn't notice). So I'm faced with losing a months worth of work :(
>>
>> Please help us, anyone!
>
> Which kernel are you running?  If you're on a 3.2 kernel or you have a
> recent pull of my git tree, you can try mount -o recovery.
>
> My guess is that your machine went down pretty quickly after the loose
> sata cable fell out?  In that case mount -o recovery should work.
>
> Otherwise we can work through the copy out recovery tools.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I'm running on a ubuntu 11.10 livecd (kernel 3.0.0) but I did clone your 
git repo and make && make install it.

however

mount -t btrfs -o recovery /dev/sda4 /mnt  failed
same error , bad superblock

also, this was a btrfs raid0 setup so it could be mounted via
/dev/sda4 or /dev/sdb, however after that sata cable came loose
I cannot mount either.

Is there anything else we can do? I've screwed myself twice now using 
btrfs raid0 so I think its time to call it quits and use something else
for a while. but I'd really like to at least get my old data off this
because my last backup is a month behind :(

-- 
--
Evan LeCompte

