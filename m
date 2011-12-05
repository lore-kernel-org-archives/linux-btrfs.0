From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Don't prevent removal of devices that break raid reqs
Date: Mon, 05 Dec 2011 16:20:51 -0500
Message-ID: <4EDD35B3.5050303@cfl.rr.com>
References: <orvcqrpycf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orvcqrpycf.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/2011 2:32 PM, Alexandre Oliva wrote:
> Instead of preventing the removal of devices that would render existing
> raid10 or raid1 impossible, warn but go ahead with it; the rebalancing
> code is smart enough to use different block group types.
>
> Should the refusal remain, so that we'd only proceed with a
> newly-introduced --force option or so?

I just thought of something.  When adding the second device, balance 
converts DUP to RAID1 automatically, and it is the RAID1 that prevents 
removing the second disk.  What if the chunks were left with both the 
DUP and RAID1 flags set?  That way if you explicitly requested raid1, 
then it won't let you accidentally drop below two disks, but if it were 
auto promoted from DUP, then going back to DUP is ok.

