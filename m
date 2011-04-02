From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: 2.6.39-rc1: kernel BUG at fs/btrfs/extent-tree.c:5479!
Date: Sat, 02 Apr 2011 19:30:40 +0800
Message-ID: <4D9708E0.6030206@cn.fujitsu.com>
References: <20110402121946.6bf27f80@sf.home>	<4D96EE76.5040208@cn.fujitsu.com> <20110402134132.0391f4fd@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402134132.0391f4fd@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2011 06:41 PM, Sergei Trofimovich wrote:
> On Sat, 02 Apr 2011 17:37:58 +0800
> liubo <liubo2009@cn.fujitsu.com> wrote:
> 
>> On 04/02/2011 05:19 PM, Sergei Trofimovich wrote:
>>> The partition is a physical ~5GB --mixed lzo compressed partition.
>>>
>>> The kernel 2.6.39-rc1 + reverted commit c59021f846881a957ac5afe456d0f59d6a517b61.
>>> (see http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09083.html)
>>>
>> Hi, Sergei,
>>
>> I'm digging this...
>>
>> Can u show me steps to reproduce this?
> 
> I use the filesystem as a storage of large CVS tree and
> as temp storage for large compilations, so I can roughly
> describe what I did and when it failed.
> 
> I've formatter btrfs 5G partition as --mixed and mounter it with lzo compression
> on the kernel of version 'v2.6.38-4148-g054cfaa', then checked out there
> large CVS tree (~170K files, weights 177MB), copied there linux source (not built)
> and copied my '/var/'. I ran compiles there and started to get -ENOSPC
> OOpses when 'df -h' reported 3.5G free.
> 
> As Linus pulled josef's changes, so I've updated to v2.6.38-6555-ga44f99c
> and kernel started to OOps right after mount (added assert started to trigger earlier).
> I've reported it to this ML (link above). josef and sensille helped me to debug what's
> going wrong [both CCed]. sensille pointed to the commit, which is guilty to miscomputing
> available space. As I understood they know what exactly screwed up.
> 

Great thanks for these details.

I did not consider the "mix" case when making the guilty patch, sorry.
Frankly, I'm still trying to reproduce your first bug, and on my box "mix + lzo" does not cause bug...

Seems that you are using opensuse's kernel.

> The second case (this one):
> I still use the same filesystem (didn't reformat, so it might carry some corruption
> after debugging patches).
> I've reverted your change c59021f846881a957ac5afe456d0f59d6a517b61
> and made sure it stops OOpsing for me, then updated to 2.6.39-rc1
> and reverted only this commit. Filesystem became usable until I've decided
> to run large compile on it (clang debug source).
> 
> I think at the time of OOps the following things did happen simultaneously:
> 
> 1. one process was splitting debug symbols of some binary:
>   - opened original binary for read
>   - write to new file (stripped binary)
>   - write debug symbols to separate file
> 
> 2. another process logged that action to log file
> 
> 3. the filesystem filled-up and OOpsed. At the time of OOps
>    'df -h' showed 200M free.
> 
> I'm trying to reproduce this second case ATM (build takes
> more, that an hour).
> 

All right, thanks for the work.

thanks,
liubo
