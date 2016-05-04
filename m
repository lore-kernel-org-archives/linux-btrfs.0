Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:51548
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbcEDTAQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 15:00:16 -0400
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
To: Chris Murphy <lists@colorremedies.com>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
 <20160503095515.GM7228@carfax.org.uk>
 <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
 <CAJCQCtQ3TRcQb4CBoxG1z5X4=ivP+22_RzECx9DM18cCJvvWgQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Message-ID: <ba85d2fe-f780-3597-ec37-7bb64176088e@hagenjohansen.dk>
Date: Wed, 4 May 2016 21:00:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ3TRcQb4CBoxG1z5X4=ivP+22_RzECx9DM18cCJvvWgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Den 04/05/16 kl. 20:12 skrev Chris Murphy:
> On Tue, May 3, 2016 at 4:24 AM, Hasse Hagen Johansen
> <hasse@hagenjohansen.dk> wrote:
>> Ok.  I can mount it manually just fine now using this command : sudo mount -t btrfs -o subvol=music /dev/sde /mnt/temp
>>
>> But somehow I cannot mount it at /music anymore(and I just found out that is what has been tricking me)
>>
>> I have also tried with this in fstab
>>
>> /dev/sde  /music          btrfs device=/dev/sdd,device=/dev/sde,subvol=music          0       2
> 
> I suggest you use volume UUID, and not /dev/ designation for anything,
> it's not reliable so for all we know you're forcing systemd to
> explicitly mount the wrong devices because their /dev/ letters are
> different. Then you can drop device= and then you can also make
> fs_passno 0 instead of 2, since it doesn't apply and just makes
> systemd run fsck.btrfs which then does nothing.
> 
> If that doesn't work then you should add boot parameter
> systemd.log_level=debug and then after startup put the output from
> 'journalctl -b -o short-monotonic > journal.log' up somewhere for
> others to look at. It will be much larger than usual and will make it
> easier to find out where things are getting confused.
> 
> 
> 
Hi

Actually I did change it back from using the UUID to /dev/sde when it
didn't work. The problem was systemd unmounting right after manually
mounting because it does that when you have changed devices used for the
mountpoint - because it only reads /etc/fstab at boot to recreate its
unit files (ex. the music.mount unit).

I also removed the device= entries, but this was a configuration I knew
worked earlier so I reverted to it when I had problems mounting(or
actually problems with systemd unmounting it right after I manually
mounted it)

So the problem has been solved and is somewhat a misbehaviour in
systemd. I agree that the fs_passno 2 doesn't make sense with btrfs. It
is a leftover from the ext4 which was mountet earlier on that mountpoint
