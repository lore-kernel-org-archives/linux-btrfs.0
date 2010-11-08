From: Chris Samuel <chris@csamuel.org>
Subject: Re: Questions regarding COW-related behaviors
Date: Tue, 09 Nov 2010 10:05:51 +1100
Message-ID: <4CD8824F.6020206@csamuel.org>
References: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com> <20101108224537.GA8950@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101108224537.GA8950@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/10 09:45, Sean Bartell wrote:

> No, unless the user request a snapshot. I'm assuming you're not talking
> about tools like PhotoRec, that try to reassemble files from whatever
> disk data looks valid.

It may be that he has confused it with nilfs which does have
automatic periodic checkpointing (and expiry thereof) based on
a user configurable policy.  These can be converted to persistent
snapshots from the command line.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
