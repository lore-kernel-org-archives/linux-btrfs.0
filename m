Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-gabriella.wadns.net ([196.220.39.91]:36004 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbaEDHQM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:16:12 -0400
Message-ID: <5365E932.20602@swiftspirit.co.za>
Date: Sun, 04 May 2014 09:16:02 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Copying related snapshots to another server with btrfs send/receive?
References: <20140504031231.GG9061@merlins.org>
In-Reply-To: <20140504031231.GG9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/04 05:12 AM, Marc MERLIN wrote:
> Another question I just came up with.
>
> If I have historical snapshots like so:
> backup
> backup.sav1
> backup.sav2
> backup.sav3
>
> If I want to copy them up to another server, can btrfs send/receive
> let me copy all of the to another btrfs pool while keeping the
> duplicated block relationship between all of them?
> Note that the backup.sav dirs will never change, so I won't need
> incremental backups on those, just a one time send.
> I believe this is supposed to work, correct?
>
> The only part I'm not clear about is am I supposed to copy them all at
> once in the same send command, or one by one?
>
> If they had to be copied together and if I create a new snapshot of
> backup: backup.sav4
>
> If I use btrfs send to that same destination, is btrfs send/receive indeed
> able to keep the shared block relationship?
>
> Thanks,
> Marc
I'm not sure if they can be sent in one go. :-/

Sending one-at-a-time, the shared-data relationship will be kept by 
using the -p (parent) parameter. Send will only send the differences and 
receive will create a new snapshot, adjusting for those differences, 
even when the receive is run on a remote server.

$ btrfs send backup | btrfs receive $path/
$ btrfs send -p backup backup.sav1 | btrfs receive $path/
$ btrfs send -p backup.sav1 backup.sav2 | btrfs receive $path/
$ btrfs send -p backup.sav2 backup.sav3 | btrfs receive $path/
$ btrfs send -p backup.sav3 backup.sav4 | btrfs receive $path/

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

