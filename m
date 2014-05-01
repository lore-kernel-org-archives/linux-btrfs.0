Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD97.btc-net.bg ([212.39.90.97]:47582 "HELO sd97.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751786AbaEAU2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 16:28:18 -0400
From: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Chris Mason'" <clm@fb.com>, "'Chris Murphy'" <lists@colorremedies.com>,
        "'Marc MERLIN'" <marc@merlins.org>,
        "=?utf-8?Q?'Johannes_L=C3=B6thberg'?=" <johannes@kyriasis.com>,
        "'Duncan'" <1i5t5.duncan@cox.net>, "'Martin'" <m_btrfs@ml1.co.uk>
Cc: <linux-btrfs@vger.kernel.org>
References: 
In-Reply-To: 
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer? - RESOLVED
Date: Thu, 1 May 2014 23:27:54 +0300
Message-ID: <000301cf657b$d51ca200$7f55e600$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>On 27/04/14 13:00, Пламен Петров wrote:
>> The problem reported in this thread has been RESOLVED.
>> 
>> It's not BTRFS's fault.
>> 
>> Debugging on my part led to the actual problem in do_mounts.c - some
>> filesystems mount routines return error codes other than 0, EACCES
>> and EINVAL and such return codes result in the kernel panicking
>> without trying to mount root with all of the available filesystems.
>> 
>> Patch is available as attachment to bug 74901 -
>> https://bugzilla.kernel.org/show_bug.cgi?id=74901 . The bugentry
>> documents how I managed to find the problem.
>
>Well deduced and that looks to be a good natural clean fix.
>
>My only question is: What was the original intent to deliberately fail
>if something other than EACCES or EINVAL were reported?
>

This one beats me as well: I looked up current git history for init/do_mounts.c - it turns out that it came in git this way, with 2.6.12-rc2. The actual reasoning behind its behavior - I do not know... and did not bother looking it up further.

>> Also, the patch has been sent to the linux kernel mailing list - see
>> http://news.gmane.org/find-root.php?group=gmane.linux.kernel&article=1691881
>> Hopefully, it will find its way into the kernel, and later on - in
>> stable releases.
>
>>That all looks very good and very thorough.
>>
>> Thanks to you all! ------------------------------ Plamen Petrov
>
>Thanks to you for chasing it through!
>
>AND for posting the "Resolved" to let everyone know. 
>
>Regards,
>Martin

You are welcome!

Regards,
---------------------------------
Plamen Petrov

