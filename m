Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaAUUCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 15:02:05 -0500
Message-ID: <52DED234.4060305@friedels.name>
Date: Tue, 21 Jan 2014 21:01:56 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name>
In-Reply-To: <52DED1C2.60103@friedels.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again:

> I think, I do/did have some symptoms, but I cannot exclude other reasons..
> -High Load without high cpu-usage (io was the bottleneck)
> -Just now: transfer from one directory to the other on the same
> subvolume (from /mnt/subvol/A/B to /mnt/subvol/A) I get 1.2MB/s instead
> of > 60.
> -For some of the files I even got a "no space left on device" error.

And the first symptom is also there:
top - 21:00:58 up 22:19,  5 users,  load average: 1.08, 1.15, 1.09
Tasks: 204 total,   1 running, 203 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.5%us,  2.7%sy,  0.3%ni, 66.6%id, 28.6%wa,  0.3%hi,  0.0%si, 
0.0%st
Mem:   3795584k total,  3614088k used,   181496k free,   367820k buffers
Swap:  8293372k total,    45464k used,  8247908k free,  2337704k cached

Greetings,
Hendrik



-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
