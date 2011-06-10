From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] Btrfs: serialize flushers in reserve_metadata_bytes
Date: Fri, 10 Jun 2011 13:49:48 -0400
Message-ID: <4DF2593C.7040107@redhat.com>
References: <1307479449-14765-1-git-send-email-josef@redhat.com> <1307479449-14765-3-git-send-email-josef@redhat.com> <20110609094547.GK12709@twin.jikos.cz> <4DF0D20A.4040906@redhat.com> <20110609180015.GM12709@twin.jikos.cz> <20110610174759.GS12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110610174759.GS12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2011 01:47 PM, David Sterba wrote:
> On Thu, Jun 09, 2011 at 08:00:15PM +0200, David Sterba wrote:
>> On Thu, Jun 09, 2011 at 10:00:42AM -0400, Josef Bacik wrote:
>>> We're not trying to be perfect here, we're trying to be fast :).
>>
>> Be even faster with smp_rmb() :)
> 
> Arne made me think about this again. Let's analyze it in more detail:
> 
> The read side, if(delalloc_bytes), utilizes a full barrier, which will
> force all cpus to flush pending reads and writes. This will ensure 'if'
> will see a fresh value.
> 
> However, there is no pairing write barrier and the write flush will
> happen at some point in time, (delalloc_bytes += len), but completely
> unsynchronized with the read side.
> 
> The smp_mb barrier has no desired synchonization effect. Moreover, it
> has a performance hit.
> 
> 
> Doing it right with barriers would mean to add smp_rmb before the
> if(...) and smp_wmb after the "delalloc_bytes =", but only in the case
> the variable is solely synchronized via barriers. Not our case. There is
> the spinlock.
> 
> As strict correctness is not needed here, you admit that delalloc_bytes
> might not correspond to the state of fs_info->delalloc_inodes and this
> is not a problem. Fine. But then you do not need the smp_mb. The value
> of delalloc_bytes will be "random" (ie. unsynchronized), with or without
> the barrier. Please drop it from the patch.

I just used the spin lock.

Josef
