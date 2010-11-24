From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Wed, 24 Nov 2010 23:47:18 +0100
Message-ID: <4CED95F6.3030901@logtenberg.eu>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

It's not that i disagree per se, but I'd appreciate if you would explain
this statement a little. Personally, I was hoping for cross-subvolumes
hardlinks, so I'd like to know why this hope was apparently a bad idea.

Kind regards,

Erik.


On 11/24/2010 11:07 PM, David Nicol wrote:
> I've been thinking about this for a while, from a perspective of how
> to make it work by allocating i-node numbers from a global pool, but
> yesterday I realized that offering the feature would be a bad idea
> because it violates the semantics of file systems.
> 
> I will be happy to expand on that point if anyone disagrees with it.
> 
> dln
> 

