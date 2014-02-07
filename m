Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60428 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbaBGVbs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 16:31:48 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56588 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WBt1X-001WzT-Ur
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 14:31:48 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Are nocow files snapshot-aware
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <qhufsa-27u.ln1@hurikhan77.spdns.de>
Date: Fri, 7 Feb 2014 14:31:45 -0700
Message-Id: <D3E4553E-C9D8-4D94-A124-506961946360@colorremedies.com>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com> <6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com> <qhufsa-27u.ln1@hurikhan77.spdns.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 7, 2014, at 2:07 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> Chris Murphy <lists@colorremedies.com> schrieb:
> 
>>> If the database/virtual machine/whatever is crash safe, then the
>>> atomic state that a snapshot grabs will be useful.
>> 
>> How fast is this state fixed on disk from the time of the snapshot
>> command? Loosely speaking. I'm curious if this is < 1 second; a few
>> seconds; or possibly up to the 30 second default commit interval? And also
>> if it's even related to the commit interval time at all?
> 
> Such constructs can only be crash-safe if write-barriers are passed down 
> through the cow logic of btrfs to the storage layer. That won't probably 
> ever happen. Atomic and transactional updates cannot happen without write-
> barriers or synchronous writes. To make it work, you need to design the 
> storage-layers from the ground up to work without write-barriers, like 
> having battery-backed write-caches, synchronous logical file-system layers 
> etc. Otherwise, database/vm/whatever transactional/atomic writes are just 
> having undefined status down at the lowest storage layer.

This explanation makes sense. But I failed to qualify the "state fixed on disk". I'm not concerned about when bits actually arrive on disk. I'm wondering what state they describe. So assume no crash or power failure, and assume writes eventually make it onto the media without a problem. What I'm wondering is, what state of the subvolume I'm snapshotting do I end up with? Is there a delay and how long is it, or is it pretty much instant? The command completes really quickly even when the file system is actively being used, so the feedback is that the snapshot state is established very fast but I'm not sure what bearing that has in reality.


Chris Murphy

