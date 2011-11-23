From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: btrfs and load (sys)
Date: Wed, 23 Nov 2011 12:01:36 -0500
Message-ID: <4ECD26F0.501@cfl.rr.com>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/2011 9:43 AM, krzf83@gmail.com wrote:
> What all those btrfs benchmark does not tell you that its performance
> decreases (sys load increases) with growing size of btree. Creating
> btrfs filesystem is instantaneous because initial tree is just
> nothing...

While something is clearly wrong, this isn't it.  Each snapshot is its 
own btree, and you said there is little churn each day, so they aren't 
getting significantly larger over time.  Each snapshot is tracked in the 
tree of tree roots, so technically it is growing each time you take a 
snapshot, but 60 items is nothing.

