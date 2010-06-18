From: Christian Stroetmann <stroetmann@ontolab.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation
 in Btrfs)
Date: Fri, 18 Jun 2010 21:25:38 +0200
Message-ID: <4C1BC832.4080809@ontolab.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <20100618155653.GC10919@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100618155653.GC10919@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jamie Lokier wrote:
> Edward Shishkin wrote:
>    
>> If you decide to base your file system on some algorithms then please
>> use the original ones from proper academic papers. DO NOT modify the
>> algorithms in solitude: this is very fragile thing! All such
>> modifications must be reviewed by specialists in the theory of
>> algorithms. Such review can be done in various scientific magazines of
>> proper level.
>>
>> Personally I don't see any way to improve the situation with Btrfs
>> except full redesigning the last one. If you want to base your file
>> system on the paper of Ohad Rodeh, then please, use *exactly* the
>> Bayer's B-trees that he refers to. That said, make sure that all
>> records you put to the tree has equal length and all non-root nodes of
>> your tree are at least half filled.
>>      
> First, thanks Edward for identifying a specific problem with the
> current btrfs implementation.
>
> I've studied modified B-trees quite a lot and know enough to be sure
> that they are quite robust when you modify them in all sorts of ways.
>    

This is the point: Which kind of modified B-tree data structure is best 
suited?

> Moreover, you are incorrect to say there's an intrinsic algorithmic
> problem with variable-length records.  It is not true; if Knuth said
> so, Knuth was mistaken.
>
> This is easily shown by modelling variable-length records (key ->
> string) as a range of fixed length records ([key,index] ->  byte) and
> apply the standard B-tree algorithms to that, which guarantees
> algorithm properties such as space utilisation and time; then you can
> substitute a "compressed" representation of contiguous index runs,
> which amounts to nothing more than just storing the strings (split
> where the algorithm says to do so) and endpoint indexes , and because
> this compression does not expand (in any way that matters), classic
> algorithmic properties are still guaranteed.
>
> Variable-length keys are a different business.  Those are trickier,
> but as far as I know, btrfs doesn't use them.
>
>    
>> As to current Btrfs code: *NOT ACK*!!! I don't think we need such
>> "file systems".
>>      
> Btrfs provides many useful features that other filesystems don't.  We
> definitely need it, or something like it.  You have identified a bug.
> It's not a corruption bug, but it's definitely a bug, and probably
> affects performance as well as space utilisation.
>
> It is not deep design bug; it is just a result of the packing and
> balancing heuristics.
>    

I think this is the most important design question in relation with 
filesystems that use some kind of B-trees, which means, if the wrong 
modified B-tree as the fundamental data structure was chosen, then this 
is a deep design bug.

> If you are still interested, please apply your knowledge of B-tree
> algorithms to understanding why btrfs fails to balance the tree
> sufficiently well, and then propose a fix.
>    

This is a general problem of filesystem design, especially the packing 
and balancing heurisitcs, and a special problem of the Btrfs filesystem. 
You can't simply say do it in this or that way. That's why another 
filesystem uses something exotic like a B*-tree in conjunction with 
dancing trees as fundamental data structure, which leads back to the 
deep design question/problem/decision/bug/.... And after I followed the 
explanations of this exotic B-tree version by the main developer I knew 
just right from the start of the development of the Btrfs filesystem 
that it wasn't chosen the right modified B-tree data structure, because 
it was too simple and too general. And since some days I have the 
impression that there wasn't made a design decision at all with the only 
exception that there has to be some kind of a B-tree algorithm/data 
structure in the Btrfs filesystem.

And I also think that such a deep desgin decision can't simply be 
corrected in general (subjective opinion).

> Note that it's not necessarily a problem to have a few nodes with low
> utilisation.  Deliberate violation of the classic balancing heuristic
> is often useful for performance.[*]  The problem you've found is only a
> real problem when there are _too many_ nodes with low utilisation.
>    

The found problem is the first problem with the chosen modified B-tree 
data structure. I wouldn't call it only a problem in a special case.

> [*] For example when filling a tree by inserting contiguously
> ascending keys, the classic "split into two when full" heuristic gives
> the worst possible results (50% lost space), and deliberately
> underfilling the most actively updated nodes, which is not permitted
> at all by the classic algorithm, gives denser packing in the end
> (almost zero lost space).  It's also faster.  The trick is to make
> sure there's just the right number of underfilled nodes...
>    

Yes, but ....
Firstly, maybe you are too focused on the classic B-tree algorithm here.
Secondly, a trick here, a split there, turning off a feature and then? 
Then we have complexity at then end, which brings us back to the start, 
the design decision.

But if you say there are no deep problems, then I will believe you for now.

> -- Jamie
>    
With all the best
Christian Stroetmann
