Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33989 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbGKQkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 12:40:32 -0400
Received: by lbnk3 with SMTP id k3so106449820lbn.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2015 09:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3753681.2HYhjf7Zfa@merkaba>
References: <CAPQXdDRKpp43M+by8wMGiMZa9VPD5XKs8CGpNLT=J41Q96E1Ug@mail.gmail.com>
	<3753681.2HYhjf7Zfa@merkaba>
Date: Sat, 11 Jul 2015 10:40:29 -0600
Message-ID: <CAPQXdDTT5E3f3VqAuQYKp3FwHjU45CfGW35du3HxRCHdyuz5gA@mail.gmail.com>
Subject: Re: Defrag operations sometimes don't work.
From: "erpo41@gmail.com" <erpo41@gmail.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 11, 2015 at 4:12 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Always do "sync" after a "btrfs fi defrag" and before measuring with
> "filefrag". The kernel may not have written everything. I have seen this
> repeatedly that the extent count drops further after a "sync", following
> "btrfs fi defrag".

First of all, thank you for your help. This fixed the problem for
defragging individual files.

I'm now seeing that recursive defragging doesn't work the way I expect. Running

$ btrfs fi defrag -r /path/to

returns almost immediately and does not reduce the number of fragments
in /path/to/file. However, running

$ btrfs fi defrag /path/to/file

does reduce the number of fragments.


Transcript:
eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ sync

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ filefrag
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-:
1567 extents found

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ time btrfs fi defrag
-r /home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--

real    0m0.006s
user    0m0.000s
sys    0m0.004s

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ sync

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ filefrag
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-:
1567 extents found

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ btrfs fi defrag
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ sync

eric@europa:~/filefrag/2015-07-11 09:53:32-06:00$ filefrag
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-
/home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1MzDigXwKSteYI4y1XLf7qE--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1YygQLPowcpLwoNE.bCX4a---/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1rvNb.zifeXTwNQmAhQdkpU--/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1oFfB25Ypui-NUlhLrvnCu---/ECRYPTFS_FNEK_ENCRYPTED.FXbZ4j3re5lQYkQsG5UhAnMElrqSQB7o7Dt1e.GaDiBl08xl5bZAxYj09kaLyAQQuN1NY-zCYqLw21g-:
15 extents found

>> btrfs --version: Btrfs v3.17
>
> I recommend to update both :), but for the defragging it should not matter.

As long as it doesn't affect defragging, I think I'll stick with what
I've got. There isn't any critical data on this machine that I would
miss.

> […]
>> Terminal Transcript
>> -------------------
>>
>> eric@europa:~/filefrag/2015-07-09$ filefrag
>> /home/.ecryptfs/eric/.Private/ECRYPTFS_FNEK_ENCRYPTED.FWbZ4j3re5lQYkQsG5Uh
> […]
>
> Nice, someone like me searching the correspondending file name in ecryptfs
> for defragmenting :)

I was kind of surprised that ecryptfs-find uses inode numbers and the
find command to locate the encrypted name of a file. It seems like
there should be a better, much faster way to do this.

Thanks,
Eric
