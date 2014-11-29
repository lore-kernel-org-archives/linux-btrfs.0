Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:52665 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbaK2RHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 12:07:08 -0500
Message-ID: <5479FD39.6030208@pobox.com>
Date: Sat, 29 Nov 2014 09:07:05 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving contents from one subvol to another
References: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com> <20141129142813.GD32735@carfax.org.uk> <CAH-HCWWh02invDCdx4-bPORdg4r39efsW=buKXTVtfspSQ9sVA@mail.gmail.com>
In-Reply-To: <CAH-HCWWh02invDCdx4-bPORdg4r39efsW=buKXTVtfspSQ9sVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/29/2014 07:15 AM, Shriramana Sharma wrote:
> On Sat, Nov 29, 2014 at 7:58 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>     The latest version of mv should be able to use CoW copies to make
>> it more efficient. It has a --reflink option, the same as cp. Note
>> that you can't make reflinks crossing a mount boundary, but you can do
>> so crossing a subvolume boundary (as you're doing here).

One thing to keep in mind is that mv, when crossing any of these 
boundaries degenerates to a copy-and-remove operation and _none_ of the 
source files will be removed until _all_ of the files have been copied. 
If any of the copy operations fail the removes will not take place at 
all. It would only take a couple large NOCOW files to put you over a 
limit somewhere.

So if you get to an out-of-space condition mid-move you are going to 
have to disentangle your stuff by hand anyway.

If you are consolidating sub-volumes (as per the original question) on a 
"nearly full" drive you may want to do it all long-hand with a script 
moving various chunks or something instead of just trying a move/copy of 
"cp --reflinks /vol1/* /vol2/" (same for mv when you get that --reflinks 
revision).

ASIDE: Also be aware that such a moment would be the perfect time to 
consider compression and so on. A regular copy (non reflinks) will apply 
the currently selected compress= regime (and reconsider sparsity etc) in 
a way that the move will not.  e.g. once you decide to do intrusive 
maintenance you might be well served by taking the extra time to 
restructure your storage. 8-)


