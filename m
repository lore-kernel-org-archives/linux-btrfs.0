Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10147 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbaCNSva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 14:51:30 -0400
Message-ID: <53234FAA.5060204@fb.com>
Date: Fri, 14 Mar 2014 14:51:22 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove transaction from send
References: <1394739733-500-1-git-send-email-jbacik@fb.com> <20140313221628.GF6151@carfax.org.uk>
In-Reply-To: <20140313221628.GF6151@carfax.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/13/2014 06:16 PM, Hugo Mills wrote:
> On Thu, Mar 13, 2014 at 03:42:13PM -0400, Josef Bacik wrote:
>> Lets try this again.  We can deadlock the box if we send on a box and try to
>> write onto the same fs with the app that is trying to listen to the send pipe.
>> This is because the writer could get stuck waiting for a transaction commit
>> which is being blocked by the send.  So fix this by making sure looking at the
>> commit roots is always going to be consistent.  We do this by keeping track of
>> which roots need to have their commit roots swapped during commit, and then
>> taking the commit_root_sem and swapping them all at once.  Then make sure we
>> take a read lock on the commit_root_sem in cases where we search the commit root
>> to make sure we're always looking at a consistent view of the commit roots.
>> Previously we had problems with this because we would swap a fs tree commit root
>> and then swap the extent tree commit root independently which would cause the
>> backref walking code to screw up sometimes.  With this patch we no longer
>> deadlock and pass all the weird send/receive corner cases.  Thanks,
>
>     There's something still going on here. I managed to get about twice
> as far through my test as I had before, but I again got an "unexpected
> EOF in stream", with btrfs send returning 1. As before, I have this in
> syslog:
>
> Mar 13 22:09:12 s_src@amelia kernel: BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040\x0a
>

I just noticed that the offset you have there is freaking gigantic, like 
700mb, which is way larger than what an extent should be.  Here is a 
newer debug patch, just chuck the old on and put this instead and re-run

http://paste.fedoraproject.org/85486/39482301

thanks,

Josef
