Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:35083 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaJKH3P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 03:29:15 -0400
Message-ID: <5438DC47.7000901@inwind.it>
Date: Sat, 11 Oct 2014 09:29:11 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org>
In-Reply-To: <5437BAB2.1040605@shiftmail.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2014 12:53 PM, Bob Marley wrote:
>> 
>> If true, maybe the closest indication we'd get of btrfs stablity is
>> the default enabling of autorecovery.
> 
> No way! I wouldn't want a default like that.
> 
> If you think at distributed transactions: suppose a sync was issued
> on both sides of a distributed transaction, then power was lost on
> one side, than btrfs had corruption. When I remount it, definitely
> the worst thing that can happen is that it auto-rolls-back to a
> previous known-good state.

I cannot agree. I consider a sane default to have a consistent state with 
"the recently data written lost", instead of "require the user 
intervention to not lost anything".

To address your requirement, we need a "super sync" command which
ensure that the data are in the filesystem and not only
in the log (as sync should ensure).

BR

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
