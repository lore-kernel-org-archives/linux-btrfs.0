Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53]:52968 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591AbaBKSUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:20:33 -0500
Message-ID: <52FA69EC.8010704@kingswood-consulting.co.uk>
Date: Tue, 11 Feb 2014 18:20:28 +0000
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs send runs out of memory and file handles
References: <52F8D406.7000207@kingswood-consulting.co.uk> <20140210134748.GI6490@carfax.org.uk> <52F8DB2B.6090902@kingswood-consulting.co.uk> <20140211181159.GJ16073@twin.jikos.cz>
In-Reply-To: <20140211181159.GJ16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/14 18:11, David Sterba wrote:
> On Mon, Feb 10, 2014 at 01:59:07PM +0000, Frank Kingswood wrote:
>> On 10/02/14 13:47, Hugo Mills wrote:
>>> On Mon, Feb 10, 2014 at 01:28:38PM +0000, Frank Kingswood wrote:
>>>> I'm attempting to back up a btrfs subvolume
>>>> [...]
>>>> Doing so runs out of file descriptors on the sending machine (having
>>>> over 100k files open) and eventually runs out of memory and gets
>>>> killed by the OOM killer.
>>>
>>>     This sounds like a known bug, and I think it was fixed in 3.13.
>>> What kernel version are you using?
>>
>> This is on 3.12.5.
>
> The fix went into 3.12.6 stable

Just missed getting the fix then.

>> I can build and install 3.13.2 and test it again.
>
> And it's in 3.13.x as well.

I built and booted into 3.13.2 and the btrfs send seems to be working - 
it's rate limited to 10MB/s and so far has managed to send about 40% of 
the snapshot.
Memory and CPU usage are low on both the sending and receiving end.

Thanks for your help,

Frank

