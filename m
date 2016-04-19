Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37382 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcDSFpn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 01:45:43 -0400
Received: by mail-wm0-f48.google.com with SMTP id n3so10327877wmn.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 22:45:42 -0700 (PDT)
Received: from [192.168.1.85] (77-173-215-182.ip.telfort.nl. [77.173.215.182])
        by smtp.googlemail.com with ESMTPSA id gk4sm67223980wjd.7.2016.04.18.22.45.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 18 Apr 2016 22:45:41 -0700 (PDT)
Subject: Re: Kernel crash if both devices in raid1 are failing
References: <570FFDFE.3050305@gmail.com>
 <CAJCQCtSDUVDVZ=JfkhOhwn-OTM3iA=cNXc9w=zLcsEatA4xU5Q@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Dmitry Katsubo <dmitry.katsubo@gmail.com>
Message-ID: <5715C604.2070200@gmail.com>
Date: Tue, 19 Apr 2016 07:45:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSDUVDVZ=JfkhOhwn-OTM3iA=cNXc9w=zLcsEatA4xU5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-18 02:19, Chris Murphy wrote:
> With two device failure on raid1 volume, the file system is actually
> broken. There's a big hole in the metadata, not just missing data,
> because there are only two copies of metadata, distributed across
> three drives.

Thanks, I understand that. Well, the drive has not completely failed,
it has accidental read-write errors. I still wonder what went wrong
and why the kernel has crashed - I think this should not happen, as it
does not allow me to operate with the data which still can be read.
I am happy to contribute more information if it would help.

> btrfs restore might be able to scrape off some files, but I don't
> expect it'll get very far. If there were n-way raid1, where every
> drive has a complete copy of 100% of the filesystem metadata, what you
> suggest would be possible.

Actually btrfs restore has recovered many files, however I was not
able to run in fully unattended mode as it complains about "looping a lot".
Does it mean that files are corrupted / not correctly restored?

> OK probably the worst thing you can do if you're trying to recover
> data from a degraded volume where a 2nd device is also having
> problems, is to mount it rw let alone write anything to it. *shrug*
> That's just going to make things much worse and more difficult to
> recover, assuming anything can be recovered at all. The least number
> of changes you make to such a volume, the better.

Another option I have thought about is to shrink the failing volume
up to some small value. This will cause chunks to be moved to another
location. How btrfs will behave if both copies cannot be read?
Would be nice to have a strategy to recover without "btrfs restore"
in such case. I wonder because "btrfs restore" assumes pausing of
normal system operation to do copying back and forth.

-- 
With best regards,
Dmitry
