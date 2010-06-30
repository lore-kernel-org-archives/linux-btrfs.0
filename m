From: Edward Shishkin <edward@redhat.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Wed, 30 Jun 2010 22:05:21 +0200
Message-ID: <4C2BA381.7040808__8927.31681601635$1277928466$gmane$org@redhat.com>
References: <20100618155653.GC10919@shareable.org> <4C1BC924.30604@redhat.com> <20100618193555.GV27466@think> <4C1BED56.9010300@redhat.com> <20100621131528.GA17979@think> <20100621180013.GD17979@think> <4C20C4E9.60203@redhat.com> <20100622142006.GT23009@think> <4C221049.501@gmail.com> <20100623233759.GE7058@shareable.org> <20100624130601.GW23009@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>,
	Jamie Lokier <jamie@shareable.org>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100624130601.GW23009@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
[...]
>>> 1. the balancing condition n <= number_of_keys <= 2n+1
>>>   is not satisfied (indeed, when number_of_keys is 1
>>>   we have 1 <= 2n+1 -- false);
>>>       
>> That doesn't matter.  It is not necessary (or desirable) to follow the
>> classical B-tree algorithms to the letter to get sufficiently good
>> properties. 

sure, but we need something instead of classic balancing condition.
We can not just refuse it: this is your lifejacket during performing
tree operations. How will you proof utilization bounds without any
balancing conditions?


>>  B-trees are quite robust to changing the details, as long
>> as you follow the generalised principles which make them work.
>>     
>
> There are lots of different perspectives here,

I wouldn't be so optimistic here (see below)

>  but it is important to
> step back and look at what we're using the btree for.  We're making an
> index to filesystem metadata.  The index is there so that we can find
> that metadata with a reasonable number of IOs and in a reasonable amount
> of time.
>
> Because btrfs is COW, and because of the reference counted COW used to
> maintain snapshots, the cost of updating the btree is different from
> traditional btrees.  We do try to avoid balancing more and
> intentionally allow the btree leaves to be less compact simply because
> it allows us to avoid the higher cost of those operations.
>   

I can understand reducing low bound, say, from 1/2 to 1/3 for performance
reasons, but again, bound 0.00 is unacceptable.. So, please, make sure you
have a sane proved bound for every such "compromise".

> The btree nodes are fairly strict.  They contain fixed records and are
> balanced in a simple fashion.  When we are inserting a new key into a
> node, if the node is completely full we split it.  When we are deleting
> a key, if the node is less than half full we balance it.

This works only if insertion/deletion on the leaf level won't result in
insertion/deletion more then one key on upper levels.

>   Calculating
> full on the btree nodes is a factor of the number of keys in them.
>
> The leaves have fixed length keys that describe items of variable size.
> On deletion merging is done when we're less than 1/3rd full and on
> insertion we split when the item we're trying to shove in doesn't fit.
> Calculating full on the btree leaves is a factor of the total size of
> the items stored.
>
> So, with all of that said, the nodes point to leaves and the leaves
> contain inodes, directory entries and sometimes file data.
>
> The most important part of the index is the higher levels of the tree.
> The index of most filesystems points to but does not contain
> inodes and file data, and so the higher levels of the btrfs btree are
> more like a traditional FS index.
>
> There's a knob here for the max inline item size and if someone wants to
> fill their whole FS with 2K files, the default settings are not at all
> suitable.  Filling with 3K files actually works better because we end
> up with inode and file data in the same block much of the time.
>   

Chris, thanks for the description.

I think that such balancing is totally incorrect. In accordance with
your strategy insertions can spawn shallow leaves, and deletions will
result in shallow leaves (because of merging with shallow leaves).
This will lead to unbound utilization slump.

In particular, your patch is just a workaround, which doesn't fix the
core problem. Knobs for cases is a nonsense. Are you kidding? Ext4,
xfs, reiserfs don't use any knobs, so why should we accept this
regress on the background of common progress? Everything should be
packed fine without any knobs...

Your strategy slightly resembles balancing in Reiserfs file system,
so I have two comments here.

1. Algorithms used in Reiserfs are "precise" (or "minimal"). That
means there is no "superfluous" balancing there. It is impossible to
save on balancing operations and slightly decrease utilization bound:
you will lose everything (this is unacceptable). Only classic Bayer's
B-trees allow to reduce bound 1/2 via replacing usual balancing
condition q <= N <= 2q with more liberal one (say, q <= N <= 3q).

2. If you want to base on COW-friendly Reiserfs, then it's algorithms
should be properly modified for the case of top-down balancing and
reviewed (better by the authors of the original algorithms).
I recommend to consider the following approach:


Balancing the leaf level


A. Inserting a key of length I(*)


01    Suppose we traversed the tree and have arrived to the position
02    pos in the leaf A.
03
04    At first we try to make space by shifting all possible items at the
05    left and right from the pos to the neighbors B and C respectively:
06
07            B   A   C
08       
09    Let's denote via L and R total length of items on leaf A at left
10    and right from the pos respectively.
11
12    If after shifting there is enough space in A, then we perform
13        insertion to A. After the insertion pairs (BA) and (AC) are
14        incompressible for obvious reasons.
15
16    Else if there is no enough space in A, we make space via inserting
17        a new empty leaf D and shift all items at the right side of pos
18        to D:
19
20            B   A   D   C
21
22        If there is enough space in A, then we perform insertion to A.
23            After insertion (AD) is incompressible, because there wasn't
24            enough space at (16), i.e. I+L+R > N, hence I+L > N-R,
25            i.e there is no enough space in D for all items of A
26            (N is capacity of empty leaf).
27
28        Else if there is enough space in D, then we perform insertion
29            to D. Pair (DC) is incompressible, because at the point (4)
30            we have shifted right all possible items at the right side
31            of pos. Pair (AD) is incompressible, because we didn't jump
32            to (22), i.e. I is larger then free space in A.
33
34        Else (there is no space in A and D for insertion), we make
35            space via insertion of a new empty leaf E, shift all items
36            from A to E, and perform insertion to the empty node A:
37
38            B   E   A   D   C
39
40            In this case (BE) is incompressible, because at the point (4)
41            we have shifted left all possible items. Pair (EA) is
42            incompressible, because there wasn't enough space in A at
43            (34).

(*) Variable length key is an abstraction. In real life this usually
means a record which includes a key of fixed length and some payload
of variable length.
 


B. Deleting a key


01    Suppose we traversed the tree and have arrived to the position
02    pos in the leaf A:
03
04            B   A   C
05
06    At first we perform deletion from A.
07    If A is empty, then
08        remove leaf A:
09
10            B   C
11
12        If the pair (BC) compressible, then shift everything from B
13        to C and remove leaf B:
14
15            C
16
17        At this point leaf C is pairwise incompressible with its left
18        and right neighbors for obvious reasons.
19
20    Else
21        if the pair (BA) compressible, then shift everything from B
22        to A and remove leaf B:
23
24            A   C
25
26        If the pair (AC) compressible, then shift everything from A to
27        C and remove leaf A:
28
29            C
30
31        Here leaf C is pairwise incompressible with its left and right
32        neighbors for obvious reasons.


Balancing the upper levels


Thus, insertion/deletion on the leaf level can lead to insertion/deletion
of not more then 2 leaves, and hence 2 keys on the upper levels. So, we
modify the classic balancing condition and top-down balancing strategy
by the following way:

Every non-root node of upper (non-leaf) levels may contain between
q and 2(q+1) entries (q>=2).

A. Inserting a key

If a node with 2q+2 (2q+1) entries is encountered while traversing the
tree, it is split into two nodes with q and q+2 (q and q+1) entries.


B. Deleting a key

If a node with q (q+1) entries in encountered while traversing the
tree, it is fixed. Fixing means either moving keys into it, or merging
it with a neighbor, so it will contain not less then q+2 keys.

Conclusion.

So with my strategy we have S1-condition satisfied on the leaf level,
and S0 on the upper levels, and, hence, we can rely on the low bound
0.5 as I mentioned here:
http://marc.info/?l=linux-btrfs&m=127690584607800&w=2

Thanks.

-- 
Edward O. Shishkin
Principal Software Engineer
Red Hat Czech

