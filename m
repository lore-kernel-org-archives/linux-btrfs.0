Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37387 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcDTWCz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 18:02:55 -0400
Received: by mail-wm0-f52.google.com with SMTP id n3so103675081wmn.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Apr 2016 15:02:55 -0700 (PDT)
Received: from [192.168.1.85] (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.googlemail.com with ESMTPSA id u145sm21095wmu.17.2016.04.20.15.02.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 20 Apr 2016 15:02:52 -0700 (PDT)
Subject: Re: Kernel crash if both devices in raid1 are failing
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <570FFDFE.3050305@gmail.com>
 <CAJCQCtSDUVDVZ=JfkhOhwn-OTM3iA=cNXc9w=zLcsEatA4xU5Q@mail.gmail.com>
 <5715C604.2070200@gmail.com> <pan$4b158$295907b$46fdde88$24c8df73@cox.net>
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Message-ID: <5717FC8C.5090006@gmail.com>
Date: Thu, 21 Apr 2016 00:02:52 +0200
MIME-Version: 1.0
In-Reply-To: <pan$4b158$295907b$46fdde88$24c8df73@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-19 09:58, Duncan wrote:
> Dmitry Katsubo posted on Tue, 19 Apr 2016 07:45:40 +0200 as excerpted:
> 
>> Actually btrfs restore has recovered many files, however I was not able
>> to run in fully unattended mode as it complains about "looping a lot".
>> Does it mean that files are corrupted / not correctly restored?
> 
> As long as you tell it to keep going each time, the loop complaints 
> shouldn't be an issue.  The problem is that the loop counter is measuring 
> loops on a particular directory, because that's what it has available to 
> measure.  But if you had a whole bunch of files in that dir, it's /going/ 
> to loop a lot, to restore all of them.
> 
> I have one cache directory with over 200K files in it.  They're all text 
> messages from various technical lists and newsgroups (like this list, 
> which I view as a newsgroup using gmane.org's list2news service) so 
> they're quite small, about 5 KiB on average by my quick calculation, but 
> that's still a LOT of files for a single dir, even if they're only using 
> just over a GiB of space.
> 
> I ended up doing a btrfs restore on that filesystem (/home), because 
> while I had a backup, restore was getting more recent copies of stuff 
> back, and that dir looped a *LOT* the first time it happened, now several 
> years ago, before they actually added the always option.

I have the same situation here: there is a backup, but the most recent
modifications in files are preferable.

> The second time it happened, about a year ago, restore worked much 
> better, and I was able to use the always option.  But AFAIK, always only 
> applies to that dir.  If you have multiple dirs with the problem, you'll 
> still get asked for the next one.  But it did vastly improve the 
> situation for me, giving me only a handful of prompts instead of the very 
> many I had before the option was there.

Yes, this is exactly the problem discussed a while ago. Would be nice if
"btrfs restore -i" applies "(a)lways" option to all questions or there is
a separate option for that ("-y").

For me personally "looping" is too low-level problem. System administrators
(that are going to use this utility) should operate with some more reasonable
terms. If "looping" is some analogy of "time consumption" then I would say
that during restore time does not matter so much: I am ready to wait for 1
minute until a specific file is restored. So I think not the number of loops
but number of time spent should be measured.

Also I have difficulties in finding out what files have not been restored
due to uncorrectable errors. As I cannot redirect the output of
"btrfs restore" and it does not print the final stats, I cannot tell what
files have to be restored from backup.

> (The main problem triggering the need to run restore for me, turned out 
> to be hardware.  I've had no issues since I replaced that failing ssd, 
> and with a bit of luck, won't be running restore again for a few years, 
> now.)

I would be happy if I am able to replace the failing drive on the fly, without
stopping the system. Unfortunately I cannot do that due to kernel crashes :(
btrfs is still not resistant to these corner cases.

-- 
With best regards,
Dmitry
