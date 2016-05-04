Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35609 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbcEDSM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 14:12:56 -0400
Received: by mail-oi0-f48.google.com with SMTP id x19so75224954oix.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 11:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
	<20160503095515.GM7228@carfax.org.uk>
	<B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
Date: Wed, 4 May 2016 12:12:55 -0600
Message-ID: <CAJCQCtQ3TRcQb4CBoxG1z5X4=ivP+22_RzECx9DM18cCJvvWgQ@mail.gmail.com>
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
From: Chris Murphy <lists@colorremedies.com>
To: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 3, 2016 at 4:24 AM, Hasse Hagen Johansen
<hasse@hagenjohansen.dk> wrote:
> Ok.  I can mount it manually just fine now using this command : sudo mount -t btrfs -o subvol=music /dev/sde /mnt/temp
>
> But somehow I cannot mount it at /music anymore(and I just found out that is what has been tricking me)
>
> I have also tried with this in fstab
>
> /dev/sde  /music          btrfs device=/dev/sdd,device=/dev/sde,subvol=music          0       2

I suggest you use volume UUID, and not /dev/ designation for anything,
it's not reliable so for all we know you're forcing systemd to
explicitly mount the wrong devices because their /dev/ letters are
different. Then you can drop device= and then you can also make
fs_passno 0 instead of 2, since it doesn't apply and just makes
systemd run fsck.btrfs which then does nothing.

If that doesn't work then you should add boot parameter
systemd.log_level=debug and then after startup put the output from
'journalctl -b -o short-monotonic > journal.log' up somewhere for
others to look at. It will be much larger than usual and will make it
easier to find out where things are getting confused.



-- 
Chris Murphy
