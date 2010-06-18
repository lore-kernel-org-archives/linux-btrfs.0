From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Fri, 18 Jun 2010 18:16:46 -0400
Message-ID: <4C1BF04E.2040803@redhat.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <20100618155653.GC10919@shareable.org> <4C1BC924.30604@redhat.com> <20100618193555.GV27466@think> <4C1BED56.9010300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Jamie Lokier <jamie@shareable.org>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1BED56.9010300@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2010 06:04 PM, Edward Shishkin wrote:
> Chris Mason wrote:
>> On Fri, Jun 18, 2010 at 09:29:40PM +0200, Edward Shishkin wrote:
>>> Jamie Lokier wrote:
>>>> Edward Shishkin wrote:
>>>>> If you decide to base your file system on some algorithms then please
>>>>> use the original ones from proper academic papers. DO NOT modify the
>>>>> algorithms in solitude: this is very fragile thing! All such
>>>>> modifications must be reviewed by specialists in the theory of
>>>>> algorithms. Such review can be done in various scientific magazines of
>>>>> proper level.
>>>>>
>>>>> Personally I don't see any way to improve the situation with Btrfs
>>>>> except full redesigning the last one. If you want to base your file
>>>>> system on the paper of Ohad Rodeh, then please, use *exactly* the
>>>>> Bayer's B-trees that he refers to. That said, make sure that all
>>>>> records you put to the tree has equal length and all non-root nodes of
>>>>> your tree are at least half filled.
>>>> First, thanks Edward for identifying a specific problem with the
>>>> current btrfs implementation.
>>> Hello Jamie.
>>>
>>>> I've studied modified B-trees quite a lot and know enough to be sure
>>>> that they are quite robust when you modify them in all sorts of ways.
>>> Which property is robust?
>>>
>>>> Moreover, you are incorrect to say there's an intrinsic algorithmic
>>>> problem with variable-length records. It is not true; if Knuth said
>>>> so, Knuth was mistaken.
>>> I didn't say about intrinsic algorithmic problems :)
>>> I just repeat (after Knuth et al) that B-trees with variable-length
>>> records don't
>>> have any sane boundary for internal fragmentation. The common idea
>>> is that if we
>>> don't want Btrfs to be in infinite development stage, then we should
>>> choose some
>>> *sane* strategy (for example the paper of Ohad Rodeh) and strictly
>>> adhere this in
>>> future.
>>
>> Again, other than the inline file data, what exactly do you believe
>> needs to change?
>
> 1. getting rid of inline extents;
> 2. new formats for directory and xattr items to not look like a train,
> which is able to occupy the whole leaf;
> 3. make sure we do pro-active balancing like it is described in the paper.
>
> Sorry, I don't see other ways for now..
>
>> Top down balancing vs balancing on insertion doesn't
>> impact our ability to maintain full leaves. The current code is clearly
>> choosing not to merge two leaves that it should have merged, which is
>> just a plain old bug.
>
> How are you going to balance leaves when walking from top to down?
> Suppose 1) and 2) above are not satisfied and having arrived to the leaf
> level we see a number of items of variable length. What will we do to
> keep leaves full?
>
> Could you please provide a sketch of the algorithm?
>
> Thanks!
>

Hi Edward,

Is it really a requirement to have 100% full leaves? Most DB's (assuming I 
remember correctly) have deliberate strategies around this kind of thing. You 
might want to leave room in leaf nodes so that future insertions can be 
contiguous on the media with older data.

Regards,

Ric
