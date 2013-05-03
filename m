Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:51115 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934019Ab3ECSBC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 14:01:02 -0400
Message-ID: <5183FB67.8000202@sgi.com>
Date: Fri, 3 May 2013 13:01:11 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com> <5183AD53.7030403@sgi.com> <20130503173001.GC12414@localhost.localdomain>
In-Reply-To: <20130503173001.GC12414@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2013 12:30 PM, Josef Bacik wrote:
> On Fri, May 03, 2013 at 06:28:03AM -0600, Rich Johnston wrote:
>> Josef,
>>
>> The patch does not compile on older kernels (i.e. SLES11 SP2).
>>
>> fsync-tester.c: In function 'test_three':
>> fsync-tester.c:133: warning: implicit declaration of function 'syncfs'
>> /tmp/cciHR6Gb.o: In function `test_three':
>> /data/lwork/gulag1c/rjohnston/xfstests/src/fsync-tester.c:133: undefined
>> reference to `syncfs'
>> collect2: ld returned 1 exit status
>> gmake[3]: *** [fsync-tester] Error 1
>> gmake[2]: *** [src] Error 2
>> make[1]: *** [default] Error 2
>> make: *** [default] Error 2
>>
>>
>> src/fsync-tester.c
>> 133                                 syncfs(test_fd);
>> Typo ?????                          ^^^^^^
>> Did you mean fsync?
>>
>
> Argh crap I should have noticed this in the manpage
>
> syncfs() first appeared in Linux 2.6.39
>
> You can just replace it with sync(), or do you want me to resend the patch with
> that change?  Thanks,
>
> Josef
>
No need to repost I will change it to sync() at commit time ;-)

--Rich
