Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaagj.dreamhost.com ([208.113.200.69]:34286 "EHLO
	homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045AbaBJQvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 11:51:41 -0500
Message-ID: <52F903D9.7030309@navitsky.org>
Date: Mon, 10 Feb 2014 08:52:41 -0800
From: John Navitsky <john@navitsky.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: system stuck with flush-btrfs-4 at 100% after filesystem resize
References: <52F67926.7060209@navitsky.org> <52F901AE.1080908@fb.com>
In-Reply-To: <52F901AE.1080908@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/10/2014 8:43 AM, Josef Bacik wrote:
> On 02/08/2014 01:36 PM, John Navitsky wrote:

>> romulus:/home/users/johnn # cat /etc/SuSE-release
>> openSUSE 12.3 (x86_64)
>> VERSION = 12.3
>> CODENAME = Dartmouth
>> romulus:/home/users/johnn # uname -a
>> Linux romulus.us.redacted.com 3.7.10-1.16-desktop #1 SMP PREEMPT Fri May
>> 31 20:21:23 UTC 2013 (97c14ba) x86_64 x86_64 x86_64 GNU/Linux
>> romulus:/home/users/johnn #
>
> Found your problem!  Basically if you are going to run btrfs you should
> at the very least keep up with the stable kernels.  3.11.whatever is
> fine, 3.12.whatever is better.  Thanks,
>
> Josef

Thanks for the feedback.

-john

