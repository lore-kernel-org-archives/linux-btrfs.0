Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:46492 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaAERyq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 12:54:46 -0500
Message-ID: <52C99C64.2010209@jrs-s.net>
Date: Sun, 05 Jan 2014 12:54:44 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <20140103172506.GA10021@merlins.org> <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net> <20140105063957.GF11749@merlins.org> <8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com>
In-Reply-To: <8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/05/2014 12:09 PM, Chris Murphy wrote:
> I haven't read anything so far indicating defrag applies to the VM 
> container use case, rather nodatacow via xattr +C is the way to go. At 
> least for now. 

Can you elaborate on the rationale behind database or VM binaries being 
set nodatacow? I experimented with this*, and found no significant (to 
me, anyway) performance enhancement with nodatacow on - maybe 10% at 
best, and if I understand correctly, that implies losing the live 
per-block checksumming of the data that's set nodatacow, meaning you 
won't get automatic correction if you're on a redundant array.

All I've heard so far is "better performance" without any more detailed 
explanation, and if the only benefit is an added MAYBE 10%ish 
performance... I'd rather take the hit, personally.

* "experimented with this" == set up a Win2008R2 test VM and ran 
HDTunePro for several runs on binaries stored with and without nodatacow 
set, 5G of random and sequential read and write access per run.
