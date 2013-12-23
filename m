Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60876 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752324Ab3LWS6i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 13:58:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: list_del corruption
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52B80DFA.5060409@cn.fujitsu.com>
Date: Mon, 23 Dec 2013 11:58:33 -0700
Cc: Geert Jansen <geertj@gmail.com>
Message-Id: <88D27FA4-B055-4336-ACE7-EBE548F082DC@colorremedies.com>
References: <CADbA=FVN5juGTxFZKdj_gqmJ5aGSyzikXMW9HDUAciBX1mUWzg@mail.gmail.com> <52B80DFA.5060409@cn.fujitsu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 23, 2013, at 3:18 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:

> On 	mon, 23 Dec 2013 09:49:16 +0100, Geert Jansen wrote:
>> Hi,
>> 
>> myself, and some other Fedora users, are experiencing a crash in
>> btrfs. I am using Fedora 20 with its stock kernel (3.12.5 based). The
>> call trace is here:
>> 
>>  https://retrace.fedoraproject.org/faf/reports/226666/
>> 
>> I have no way to reproduce unfortunately. The crash happens about once a week.
>> 
>> There is also a Red Hat bugzilla here:
>> 
>>  https://bugzilla.redhat.com/show_bug.cgi?id=1028750
>> 
>> The Red Hat bugzilla contains a patch for 3.13 that is claimed to fix
>> the issue. However the patch does not apply cleanly, and the comment
>> in the patch indicate that it fixes a different, more recently
>> introduced bug.
>> 
>> Any help is appreciated.
> 
> It should be fixed by:
> 
> commit 93858769172c4e3678917810e9d5de360eb991cc
> Author: Josef Bacik <jbacik@fusionio.com>
> Date:   Mon Oct 28 09:13:25 2013 -0400
> 
>    Btrfs: take ordered root lock when removing ordered operations inode

According to changelog this is in kernel 3.12.6. The Fedora 19 and 20 version of this kernel are building in koji today. The F20 one will be found at: http://koji.fedoraproject.org/koji/buildinfo?buildID=486644 And also via the updates-testing repo within a day or two.


Chris Murphy