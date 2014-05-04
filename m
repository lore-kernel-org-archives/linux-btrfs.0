Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:23586 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbaEDHy5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:54:57 -0400
Message-ID: <5365F23E.8070009@swiftspirit.co.za>
Date: Sun, 04 May 2014 09:54:38 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Copying related snapshots to another server with btrfs send/receive?
References: <20140504031231.GG9061@merlins.org> <5365E932.20602@swiftspirit.co.za> <20140504072829.GK9061@merlins.org>
In-Reply-To: <20140504072829.GK9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/04 09:28 AM, Marc MERLIN wrote:
> On Sun, May 04, 2014 at 09:16:02AM +0200, Brendan Hide wrote:
>> Sending one-at-a-time, the shared-data relationship will be kept by
>> using the -p (parent) parameter. Send will only send the differences
>> and receive will create a new snapshot, adjusting for those
>> differences, even when the receive is run on a remote server.
>>
>> $ btrfs send backup | btrfs receive $path/
>> $ btrfs send -p backup backup.sav1 | btrfs receive $path/
>> $ btrfs send -p backup.sav1 backup.sav2 | btrfs receive $path/
>> $ btrfs send -p backup.sav2 backup.sav3 | btrfs receive $path/
>> $ btrfs send -p backup.sav3 backup.sav4 | btrfs receive $path/
> So this is exactly the same than what I do incremental backups with
> brrfs send, but -p only works if the snapshot is read only, does it not?
> I do use that for my incremental syncs and don't mind read only
> snapshots there, but if I have read/write snapshots that are there for
> other reasons than btrfs send incrementals, can I still send them that
> way with -p?
> (I thought that wouldn't work)
>
> Thanks,
> Marc
Yes, -p (parent) and -c (clone source) are the only ways I'm aware of to 
push subvolumes across while ensuring data-sharing relationship remains 
intact. This will end up being much the same as doing incremental backups:
 From the man page section on -c:
     "You must not specify clone sources unless you guarantee that these 
snapshots are exactly in the same state on both sides, the sender and 
the receiver. It is allowed to omit the '-p <parent>' option when '-c 
<clone-src>' options are given, in which case 'btrfs send' will 
determine a suitable parent among the clone sources itself."

-p does require that the sources be read-only. I suspect -c does as 
well. This means that it won't be so simple as you want your sources to 
be read-write. Probably the only way then would be to make read-only 
snapshots whenever you want to sync these over while also ensuring that 
you keep at least one read-only snapshot intact - again, much like 
incremental backups.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

