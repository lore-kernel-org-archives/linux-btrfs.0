Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49298 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965226Ab2JZQVn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 12:21:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TRmfM-0001W3-Ks
	for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2012 18:21:48 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 18:21:48 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 18:21:48 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [RFC] Systemcall for offline deduplication
Date: Fri, 26 Oct 2012 16:21:29 +0000 (UTC)
Message-ID: <k6eda8$1ad$2@ger.gmane.org>
References: <507C4343.6060305@shiftmail.org>
	<20121015201516.GB10679@twin.jikos.cz> <k5m5du$keo$1@ger.gmane.org>
	<20121026062614.GA19617@blackbox.djwong.org> <k6ec1a$1ad$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> As for online dedupe (which seems useful for reducing writes), would it
>> be useful if one could, given a write request, compare each of the
>> dirty pages in that request against whatever else the fs has loaded in
>> the page cache, and try to dedupe against that?  We could probably
>> speed up the search by storing hashes of whatever we have in the page
>> cache and using that to find candidates for the memcmp() test.  This of
>> course is not a comprehensive solution, but (a)
>> we combine it with offline dedupe later and (b) we don't make a disk
>> write out data that we've recently read or written.  Obviously you'd
>> want to be able to opt-in to this sort of thing with an inode flag or
>> something.
> 
> That's another kettle of fish, and will require an entirely different
> approach. ZFS has some experience doing that. While their implementation
> may reduce writes it is at the cost of storing hashes of every block in
> RAM.

Though your proposal is quite different from the ZFS thing, and might 
actually be useful for a larger public, so forget I said anything about 
it.


