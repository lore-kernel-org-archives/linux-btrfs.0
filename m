Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38382 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbaGTSZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 14:25:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8vnE-0005G0-QP
	for linux-btrfs@vger.kernel.org; Sun, 20 Jul 2014 20:25:04 +0200
Received: from athedsl-372136.home.otenet.gr ([79.131.5.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 20:25:04 +0200
Received: from tmjuju by athedsl-372136.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 20:25:04 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Sun, 20 Jul 2014 18:23:29 +0000 (UTC)
Message-ID: <loom.20140720T202250-546@post.gmane.org>
References: <loom.20140720T102642-239@post.gmane.org>    <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net>    <20140720140044.GB7469@mother.pipebreaker.pl> <9781519da9ccf1c860a49d3b7954d00d.squirrel@webmail.wanet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 <ashford <at> whisperpc.com> writes:

> 
> Finally, TM didn't mention anything about other I/O activity on the array,
> which, regardless of the method of reconstruction, could have a
> significant impact on the speed of a reconstruction.
> 
> There are a LOT of parameters here that could impact throughput.  Some are
> designed in (the checksum computations), some are "temporary" (the single
> I/O path) and some are end-user issues (slow CPU and other activity on the
> array).  I'm sure that there are other parameters, possibly including soft
> read errors on the other disks, that could be impacting the overall
> throughput.
> 
> As all the information that could affect performance hasnt been provided
> yet, it is premature to make a blanket statement that the performance of a
> reconstruction is "unreasonable".  For the circumstances, it's possible
> that the performance is just fine.  We have not yet been provided with
> enough data to verify this, one way or another.
> 
> Peter Ashford



Hi Peter,

  I am monitoring closely, I do not have any 'soft-errors' or anything else.
No other users are using the raid10 array. No other compute/disk intensive
tasks etc. So I am providing data -  usual and typical data at least.

  To answer another question, yes I do have backups.

  So this I guess it the speed most users get, which is in my opinion very
slow. 
  And I guess that's around the speed most users will get in similar 4x 3TB
build with low power CPUs.

  Long recovery time, leads to higher risk of another disk failure or other
unexpected failures. 


TM


