Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:58782 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbJaU4Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 16:56:16 -0400
Received: from smtp-auth.rrz.uni-koeln.de (smtp-auth.rrz.uni-koeln.de [134.95.19.93])
	by smtp-out.rrz.uni-koeln.de (8.14.4/8.14.4) with ESMTP id t9VKuDfK029253
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 21:56:14 +0100
Received: from linux-va3e.site ([176.0.113.210])
	(authenticated as user sking using CRAM-MD5 bits=0)
	by smtp-auth.uni-koeln.de (8.13.8/8.13.8) with ESMTP id t9VKuBhw020971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 21:56:13 +0100
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
To: linux-btrfs@vger.kernel.org
References: <5634DD93.9050605@uni-koeln.de>
 <20151031164112.GF21103@carfax.org.uk> <5634FB01.9030602@uni-koeln.de>
 <20151031183337.GG21103@carfax.org.uk>
From: Simon King <simon.king@uni-koeln.de>
Message-ID: <56352AEA.7040907@uni-koeln.de>
Date: Sat, 31 Oct 2015 21:56:10 +0100
MIME-Version: 1.0
In-Reply-To: <20151031183337.GG21103@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Am 31.10.2015 um 19:33 schrieb Hugo Mills:
>> I combined the two, since -dlimit on its own won't work:
>>
>> linux-va3e:~ # btrfs balance start -dlimit=2 /
>> ERROR: error during balancing '/' - No space left on device
>> There may be more info in syslog - try dmesg | tail
> 
>    And this is with a filesystem that's not fully allocated?
> (i.e. btrfs fi show indicates that used and total are different for
> each device). If that's the case, then you may have hit a known but
> unfixed bug to do with space allocation.

linux-va3e:~ # btrfs fi show
Label: none  uuid: 656dc65f-240b-4137-a490-0175717dd7fa
        Total devices 1 FS bytes used 13.71GiB
        devid    1 size 20.00GiB used 16.88GiB path /dev/sda2

btrfs-progs v4.0+20150429

Is there a manual work-around?

>> Can I do this in the running system? Or would that only be an option
>> during upgrade of openSuse Harlequin to Tumbleweed/Leap? Or even worse:
>> Only an option after nuking the old installation and installing a new
>> one from scratch?
> 
>    You'd have to recreate the FS, so it's a matter of a reinstall, or
> nuking it and restoring from your backups.

OK. So, I'll try to find out whether it is better to move on to
Tumbleweed or to Leap (btw, I found out that the latter is based on the
4.1 kernel).

Best regards,
Simon

