Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22064 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932796AbaCTPam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 11:30:42 -0400
Message-ID: <532B0999.3060605@fb.com>
Date: Thu, 20 Mar 2014 11:30:33 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jakub_Klinkovsk=FD?= <j.l.k@gmx.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub process prevents system suspend
References: <20140320152131.GA1172@asusntb.lan>
In-Reply-To: <20140320152131.GA1172@asusntb.lan>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/20/2014 11:21 AM, Jakub Klinkovský wrote:
> Today I accidentally discovered that it is not possible to suspend (hibernate)
> the system while the btrfs scrub process is running (see the attached log).
> Could this be considered a bug, or did I miss something?
>
> Some more info:
>
> $ uname -a
> Linux asusntb 3.13.6-1-ARCH #1 SMP PREEMPT Fri Mar 7 22:47:48 CET 2014 x86_64 GNU/Linux
>
> and btrfs-progs-3.12 is installed.
>

Yeah there's a way to make suspend run commands while it goes down, 
you'll want to make it do btrfs scrub cancel on your btrfs fses.  If you 
search the archives you'll see we've covered this recently and the guy 
posted the script he was using.  Thanks,

Josef

