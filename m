From: Christian Stroetmann <stroetmann@ontolab.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation
 in Btrfs)
Date: Fri, 18 Jun 2010 20:15:34 +0200
Message-ID: <4C1BB7C6.40700@ontolab.com>
References: <4C07C321.8010000@redhat.com>	<AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>	<4C1B7560.1000806@gmail.com> <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel J Blueman wrote:
> On Fri, Jun 18, 2010 at 1:32 PM, Edward Shishkin
> <edward.shishkin@gmail.com>  wrote:
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
>>>> Internal fragmentation (see Appendix A) of those 5 leafs is
>>>> (1572+3892+1901+3666+1675)/4096*5 = 0.62. This is even worse then
>>>> ext4 and xfs: The last ones in this example will show fragmentation
>>>> near zero with blocksize<= 2K. Even with 4K blocksize they will
>>>> show better utilization 0.50 (against 0.38 in btrfs)!
>>>>
>>>> I have a small question for btrfs developers: Why do you folks put
>>>> "inline extents", xattr, etc items of variable size to the B-tree
>>>> in spite of the fact that B-tree is a data structure NOT for variable
>>>> sized records? This disadvantage of B-trees was widely discussed.
>>>> For example, maestro D. Knuth warned about this issue long time
>>>> ago (see Appendix C).
>>>>
>>>> It is a well known fact that internal fragmentation of classic Bayer's
>>>> B-trees is restricted by the value 0.50 (see Appendix C). However it
>>>> takes place only if your tree contains records of the _same_ length
>>>> (for example, extent pointers). Once you put to your B-tree records
>>>> of variable length (restricted only by leaf size, like btrfs "inline
>>>> extents"), your tree LOSES this boundary. Moreover, even worse:
>>>> it is clear, that in this case utilization of B-tree scales as zero(!).
>>>> That said, for every small E and for every amount of data N we
>>>> can construct a consistent B-tree, which contains data N and has
>>>> utilization worse then E. I.e. from the standpoint of utilization
>>>> such trees can be completely degenerated.
>>>>
>>>> That said, the very important property of B-trees, which guarantees
>>>> non-zero utilization, has been lost, and I don't see in Btrfs code any
>>>> substitution for this property. In other words, where is a formal
>>>> guarantee that all disk space of our users won't be eaten by internal
>>>> fragmentation? I consider such guarantee as a *necessary* condition
>>>> for putting a file system to production.
>>>>          
> Wow...a small part of me says 'well said', on the basis that your
> assertions are true, but I do think there needs to be more
> constructivity in such critique; it is almost impossible to be a great
> engineer and a great academic at once in a time-pressured environment.
>    
I find this is somehow off-topic, but:
For sure, it isn't impossible. History showed and present shows that 
there are exceptions.
> If you can produce some specific and suggestions with code references,
> I'm sure we'll get some good discussion with potential to improve from
> where we are.
>
> Thanks,
>    Daniel
>    
Have fun
Christian Stroetmann
