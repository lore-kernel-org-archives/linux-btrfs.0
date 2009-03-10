From: Aaron Straus <aaron@merfinllc.com>
Subject: Re: Unable to create the previously deleted snapshot or subvolume
Date: Tue, 10 Mar 2009 09:20:09 -0700
Message-ID: <20090310162009.GA31499@merfinllc.com>
References: <d853ebb60903090614r57bc11cfpb446681a10c6f204@mail.gmail.com> <d853ebb60903100212h67282cfck99a097a4530c4e6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Siddhartha Swaroop <siddhartha.swaroop@greenturtles.in>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d853ebb60903100212h67282cfck99a097a4530c4e6a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Siddhartha,

On Mar 10 02:42 PM, Siddhartha Swaroop wrote:
> So from about test case the problem I faced is when ever I try to
> create a snapshot or subvolume of same name which previously deleted
> it says file exists.But when I do "$ ls " that file will not be
> present in that directory.  But once in a while am able to create it
> as u can see in the about test steps  7,8,9.

Thanks.  That patch is certainly dangerous and meant more as a request
for help!  :)

That said, the most important thing I still don't understand is the tree
root forward and back refs.  

In particular I don't think BTRFS is adding all the forward and back
refs in the snapshot of snapshot case.

The will make snapshot deletion difficult because one cannot tell if the
tree root is still being referenced by another tree root (or not)...

Anyway, I think that's still the first thing to be cleaned up.

				Regards,
				=a=




-- 
===================
Aaron Straus
aaron@merfinllc.com
