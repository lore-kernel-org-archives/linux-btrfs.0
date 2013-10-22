Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12b.wadns.net ([196.220.39.31]:26060 "EHLO fw12a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752822Ab3JVRsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:48:43 -0400
Message-ID: <5266B87D.9080202@swiftspirit.co.za>
Date: Tue, 22 Oct 2013 19:40:13 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com> <pan$59a02$8231ca78$f5d54bfb$30812437@cox.net> <or7gd59qcf.fsf@livre.home>
In-Reply-To: <or7gd59qcf.fsf@livre.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/10/22 07:18 PM, Alexandre Oliva wrote:
> ... and
> it is surely an improvement over the current state of raid56 in btrfs,
> so it might be a good idea to put it in.
I suspect the issue is that, while it sortof works, we don't really want 
to push people to use it half-baked. This is reassuring work, however. 
Maybe it would be nice to have some half-baked code *anyway*, even if 
Chris doesn't put it in his pull requests juuust yet. ;)
> So far, I've put more than
> 1TB of data on that failing disk with 16 partitions on raid6, and
> somehow I got all the data back successfully: every file passed an
> md5sum check, in spite of tons of I/O errors in the process.
Is this all on a single disk? If so it must be seeking like mad! haha

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

