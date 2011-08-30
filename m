From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Tue, 30 Aug 2011 14:02:37 -0400
Message-ID: <4E5D25BD.3020901@redhat.com>
References: <20110817185619.4660.78543.stgit@localhost6> <20110829063416.00f4652c@sf> <20110830195309.4882f478@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110830195309.4882f478@sf>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/2011 12:53 PM, Sergei Trofimovich wrote:
>> Running 'sync' program after the load does not finish and eats 
>> 100%CPU busy-waiting for something in kernel.
>> 
>> It's easy to reproduce hang with patch for me. I just run
>> liferea and sync after it. Without patch I haven't managed to
>> hang btrfs up.
> 
> And I think it's another btrfs bug. I've managed to reproduce it 
> _without_ your patch and _without_ autodefrag enabled by manually 
> running the following commands: $ btrfs fi defrag 
> file-with-20_000-extents $ sync
> 
> I think your patch just shuffles things a bit and forces
> autodefrag races to pop-up sooner (which is good! :])
> 

Sergei, can you do sysrq+w when this is happening, and maybe turn on
the softlockup detector so we can see where sync is getting stuck?
Thanks,

Josef
