Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:53076 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbbGJTDh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 15:03:37 -0400
Received: from smtp8.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp8.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 187A480490
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:03:35 -0400 (EDT)
Received: from smtp8.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp8.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id C81538047C
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:03:35 -0400 (EDT)
Received: by smtp8.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 269F980464
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 15:03:31 -0400 (EDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Subject: Re: Send/Receive Use Case
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <E737B6C9-CC16-490A-B14C-E2D364BA2805@up4.com>
Date: Fri, 10 Jul 2015 15:03:27 -0400
Message-Id: <5A05A6DE-A405-4C88-9F7D-C7510048E067@up4.com>
References: <F2771637-3D78-4332-AB96-993069114030@up4.com> <20150627142132.GI16065@carfax.org.uk> <E737B6C9-CC16-490A-B14C-E2D364BA2805@up4.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

actually I have another question : is it posssible for a RAID0 fs to “receive” from a “sending” RAID10 ? or do they need to be of the same replication scheme too ?



> On Jun 27, 2015, at 10:34 AM, Vincent Olivier <vincent@up4.com> wrote:
> 
> ok i’ll go home and rethink my life then ;)
> 
>> On Jun 27, 2015, at 10:21 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> 
>> On Sat, Jun 27, 2015 at 10:04:28AM -0400, Vincent Olivier wrote:
>>> Hi,
>>> 
>>> There are 4 things I’m not sure about re:send/receive.
>>> 
>>> 1) Is it possible to first copy things on a file system using rsync and then use send-receive ? And to subsequently mix rsync and send-receive ? Provided that snapshots are made accordingly.
>> 
>>  Probably. It depends on exctly how you want to use them.
>> 
>>> 2) Is possible to “send" a snapshot diff to disk and then “receive" it from the said disk into a remote filesystem ? I have two very large and physically distant btrfs filesystems. It would be more economical to juste dump snapshot diffs to disk for transport instead of the network.
>> 
>>  Yes, that's perfectly possible.
>> 
>>> 3) How are “conflicts” handled by send-receive if at all ?
>> 
>>  There are no conflicts possible, due to the requirement of all the
>> subvolumes involved in the send/receive process being read-only.
>> (Actually, that's not quite true -- you can make a subvolume
>> read/write, and then read-only again. In that case, the receive will
>> probably fail, leaving the received subvolume in a partially-created
>> state).
>> 
>>> 4) If a file is created, modified and then deleted in-between two
>>> snapshots is it ignored by send/receive or does send/receive
>>> "re-enacts” the journal exactly ?
>> 
>>  It'll be ignored. The FS doesn't keep track of how it reached a
>> particular state -- only what that state is.
>> 
>>  Hugo.
>> 
>> -- 
>> Hugo Mills             | IMPROVE YOUR ORGANISMS!!
>> hugo@... carfax.org.uk |
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |                            Subject line of spam email
> 

