From: Christian Stroetmann <stroetmann@ontolab.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation
 in Btrfs)
Date: Fri, 18 Jun 2010 17:21:21 +0200
Message-ID: <4C1B8EF1.7080602@ontolab.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <20100618134755.GG27466@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100618134755.GG27466@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, Jun 18, 2010 at 03:32:16PM +0200, Edward Shishkin wrote:
>    
>> Mat wrote:
>>      
>>> On Thu, Jun 3, 2010 at 4:58 PM, Edward Shishkin<edward@redhat.com>  wrote:
>>>        
>>>> Hello everyone.
>>>>
>>>> I was asked to review/evaluate Btrfs for using in enterprise
>>>> systems and the below are my first impressions (linux-2.6.33).
>>>>
>>>> The first test I have made was filling an empty 659M (/dev/sdb2)
>>>> btrfs partition (mounted to /mnt) with 2K files:
>>>>
>>>> # for i in $(seq 1000000); \
>>>> do dd if=/dev/zero of=/mnt/file_$i bs=2048 count=1; done
>>>> (terminated after getting "No space left on device" reports).
>>>>
>>>> # ls /mnt | wc -l
>>>> 59480
>>>>
>>>> So, I got the "dirty" utilization 59480*2048 / (659*1024*1024) = 0.17,
>>>> and the first obvious question is "hey, where are other 83% of my
>>>> disk space???" I looked at the btrfs storage tree (fs_tree) and was
>>>> shocked with the situation on the leaf level. The Appendix B shows
>>>> 5 adjacent btrfs leafs, which have the same parent.
>>>>
>>>> For example, look at the leaf 29425664: "items 1 free space 3892"
>>>> (of 4096!!). Note, that this "free" space (3892) is _dead_: any
>>>> attempts to write to the file system will result in "No space left
>>>> on device".
>>>>          
> There are two easy ways to fix this problem.  Turn off the inline
> extents (max_inline=0) or allow splitting of the inline extents.  I
> didn't put in the splitting simply because the complexity was high while
> the benefits were low (in comparison with just turning off the inline
> extents).
>    
But then the benefits of splitting must be high, because it solves this 
problem if inline extents are turned on.
>    
>> It must be a highly unexpected and difficult question for file system
>> developers: "how efficiently does your file system manage disk space"?
>>
>> In the meanwhile I confirm that Btrfs design is completely broken:
>> records stored in the B-tree differ greatly from each other (it is
>> unacceptable!), and the balancing algorithms have been modified in
>> insane manner. All these factors has led to loss of *all* boundaries
>> holding internal fragmentation and to exhaustive waste of disk space
>> (and memory!) in spite of the property "scaling in their ability to
>> address large storage".
>>
>> This is not a large storage, this is a "scalable sieve": you can not
>> rely on finding there some given amount of water even after infinite
>> increasing the size of the sieve (read escalating the pool of Btrfs
>> devices).
>>
>> It seems that nobody have reviewed Btrfs before its inclusion to the
>> mainline. I have only found a pair of recommendations with a common
>> idea that Btrfs maintainer is "not a crazy man". Plus a number of
>> papers which admire with the "Btrfs phenomena". Sigh.
>>
>> Well, let's decide what can we do in current situation..
>> The first obvious point here is that we *can not* put such file system
>> to production. Just because it doesn't provide any guarantees for our
>> users regarding disk space utilization.
>>      
> Are you basing all of this on inline extents?  The other extents of
> variable size are more flexible (taking up the room in the leaf), but
> they can also easy be split during balancing.
>    
If we have to split everywhere, hasn't it then some (dramatic) impact on 
the performance of the Btrfs filesystem?
As it was said above: splitting has a high complexity.
> -chris
> --
>    
Have fun
Christian Stroetmann
