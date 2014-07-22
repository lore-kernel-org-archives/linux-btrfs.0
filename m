Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33954 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755985AbaGVRNX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 13:13:23 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49925 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X9dcv-002wOO-1b
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 11:13:21 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$6f72e$34416d71$688a2a2$980c8acd@cox.net>
Date: Tue, 22 Jul 2014 11:13:19 -0600
Message-Id: <2C76C454-2B09-4E3B-92C2-4EE6A1ED7EA8@colorremedies.com>
References: <loom.20140720T102642-239@post.gmane.org> <53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu> <37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net> <pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net> <CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com> <pan$6f72e$34416d71$688a2a2$980c8acd@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 21, 2014, at 8:51 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> 
>> It does not matter at all what the average file size is.
> 
> … and the filesize /does/ matter.

I'm not sure how. A rebuild is replicating chunks, not doing the equivalent of cp or rsync on files. Copying chunks (or strips of chunks in the case of raid10) should be a rather sequential operation. So I'm not sure where the random write behavior would come from that could drop the write performance to ~5MB/s on drives that can read/write ~100MB/s.

>> Thus is is perfectly reasonabe to expect ~50MByte/second, per spindle,
>> when doing a raid rebuild.
> 
> ... And perfectly reasonable, at least at this point, to expect ~5 MiB/
> sec total thruput, one spindle at a time, for btrfs.

It's been a while since I did a rebuild on HDDs, but on SSDs the rebuilds have maxed out the replacement drive. Obviously the significant difference is rotational latency. If everyone with spinning disks and many small files is getting 5MB/s rebuilds, it suggests a rotational latency penalty if the performance is expected. I'm just not sure where that would be coming from. Random IO would incur the effect of rotational latency, but the rebuild shouldn't be random IO, rather sequential.


Chris Murphy

