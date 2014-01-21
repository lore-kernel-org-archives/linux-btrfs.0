Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaAUUAO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 15:00:14 -0500
Message-ID: <52DED1C2.60103@friedels.name>
Date: Tue, 21 Jan 2014 21:00:02 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>
In-Reply-To: <6210673.6TYUkLGl6b@merkaba>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>> Yes. Here I mount the three subvolumes:
>
> Does scrubbing the volume give any errors?

Last time I did (that was after I discovered the first errors in 
btrfsck) scrub, it found no error. But I will re-check asap.


> As to the error messages: I do not know how critical those are.
>
> I usually just scrub my filesystems once in a while and would only try btrfs
> check on one that fails the scrubbing or has problems mounting or (in some
> cases) yields strange messages in dmesg.

Ok.
I think, I do/did have some symptoms, but I cannot exclude other reasons..
-High Load without high cpu-usage (io was the bottleneck)
-Just now: transfer from one directory to the other on the same 
subvolume (from /mnt/subvol/A/B to /mnt/subvol/A) I get 1.2MB/s instead 
of > 60.
-For some of the files I even got a "no space left on device" error.

This is without any messages in dmesg or syslog related to btrfs.

Greetings,
Hendrik
