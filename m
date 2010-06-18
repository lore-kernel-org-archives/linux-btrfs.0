From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Btrfs: broken file system design (was Unbound(?) internal fragmentation
 in Btrfs)
Date: Fri, 18 Jun 2010 15:32:16 +0200
Message-ID: <4C1B7560.1000806@gmail.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Mat <jackdachef@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mat wrote:
> On Thu, Jun 3, 2010 at 4:58 PM, Edward Shishkin <edward@redhat.com> wrote:
>   
>> Hello everyone.
>>
>> I was asked to review/evaluate Btrfs for using in enterprise
>> systems and the below are my first impressions (linux-2.6.33).
>>
>> The first test I have made was filling an empty 659M (/dev/sdb2)
>> btrfs partition (mounted to /mnt) with 2K files:
>>
>> # for i in $(seq 1000000); \
>> do dd if=/dev/zero of=/mnt/file_$i bs=2048 count=1; done
>> (terminated after getting "No space left on device" reports).
>>
>> # ls /mnt | wc -l
>> 59480
>>
>> So, I got the "dirty" utilization 59480*2048 / (659*1024*1024) = 0.17,
>> and the first obvious question is "hey, where are other 83% of my
>> disk space???" I looked at the btrfs storage tree (fs_tree) and was
>> shocked with the situation on the leaf level. The Appendix B shows
>> 5 adjacent btrfs leafs, which have the same parent.
>>
>> For example, look at the leaf 29425664: "items 1 free space 3892"
>> (of 4096!!). Note, that this "free" space (3892) is _dead_: any
>> attempts to write to the file system will result in "No space left
>> on device".
>>
>> Internal fragmentation (see Appendix A) of those 5 leafs is
>> (1572+3892+1901+3666+1675)/4096*5 = 0.62. This is even worse then
>> ext4 and xfs: The last ones in this example will show fragmentation
>> near zero with blocksize <= 2K. Even with 4K blocksize they will
>> show better utilization 0.50 (against 0.38 in btrfs)!
>>
>> I have a small question for btrfs developers: Why do you folks put
>> "inline extents", xattr, etc items of variable size to the B-tree
>> in spite of the fact that B-tree is a data structure NOT for variable
>> sized records? This disadvantage of B-trees was widely discussed.
>> For example, maestro D. Knuth warned about this issue long time
>> ago (see Appendix C).
>>
>> It is a well known fact that internal fragmentation of classic Bayer's
>> B-trees is restricted by the value 0.50 (see Appendix C). However it
>> takes place only if your tree contains records of the _same_ length
>> (for example, extent pointers). Once you put to your B-tree records
>> of variable length (restricted only by leaf size, like btrfs "inline
>> extents"), your tree LOSES this boundary. Moreover, even worse:
>> it is clear, that in this case utilization of B-tree scales as zero(!).
>> That said, for every small E and for every amount of data N we
>> can construct a consistent B-tree, which contains data N and has
>> utilization worse then E. I.e. from the standpoint of utilization
>> such trees can be completely degenerated.
>>
>> That said, the very important property of B-trees, which guarantees
>> non-zero utilization, has been lost, and I don't see in Btrfs code any
>> substitution for this property. In other words, where is a formal
>> guarantee that all disk space of our users won't be eaten by internal
>> fragmentation? I consider such guarantee as a *necessary* condition
>> for putting a file system to production.
>>
>> Any technical comments are welcome.
>>
>> Thanks,
>> Edward.
>>
>>
>> Appendix A.
>> -----------
>> Glossary
>>
>> 1. Utilization of data and(or) metadata storage.
>>
>> The fraction A/B, where
>> A is total size in bytes of stored data and(or) metadata.
>> B = N * S, where
>> N is number of blocks occupied by stored data and(or) metadata.
>> S is block size in bytes.
>>
>> 2. Internal fragmentation of data and(or) metadata storage.
>>
>> difference (1 - U), where U is utilization.
>>
>>
>> Appendix B.
>> -----------
>> a "period" in the dump of the fs_tree (btrfs-debug-tree /dev/sdb2)
>>
>> ...
>>
>> leaf 29982720 items 4 free space 1572 generation 8 owner 5
>> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
>> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>>       item 0 key (319 XATTR_ITEM 3817753667) itemoff 3917 itemsize 78
>>               location key (0 UNKNOWN 0) type 8
>>               namelen 16 datalen 32 name: security.selinux
>>       item 1 key (319 EXTENT_DATA 0) itemoff 1848 itemsize 2069
>>               inline extent data size 2048 ram 2048 compress 0
>>       item 2 key (320 INODE_ITEM 0) itemoff 1688 itemsize 160
>>               inode generation 8 size 2048 block group 29360128 mode 100644
>> links 1
>>       item 3 key (320 INODE_REF 256) itemoff 1672 itemsize 16
>>               inode ref index 65 namelen 6 name: file64
>> leaf 29425664 items 1 free space 3892 generation 8 owner 5
>> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
>> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>>       item 0 key (320 XATTR_ITEM 3817753667) itemoff 3917 itemsize 78
>>               location key (0 UNKNOWN 0) type 8
>>               namelen 16 datalen 32 name: security.selinux
>> leaf 29990912 items 1 free space 1901 generation 8 owner 5
>> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
>> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>>       item 0 key (320 EXTENT_DATA 0) itemoff 1926 itemsize 2069
>>               inline extent data size 2048 ram 2048 compress 0
>> leaf 29986816 items 3 free space 3666 generation 8 owner 5
>> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
>> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>>       item 0 key (321 INODE_ITEM 0) itemoff 3835 itemsize 160
>>               inode generation 8 size 2048 block group 29360128 mode 100644
>> links 1
>>       item 1 key (321 INODE_REF 256) itemoff 3819 itemsize 16
>>               inode ref index 66 namelen 6 name: file65
>>       item 2 key (321 XATTR_ITEM 3817753667) itemoff 3741 itemsize 78
>>               location key (0 UNKNOWN 0) type 8
>>               namelen 16 datalen 32 name: security.selinux
>> leaf 29995008 items 3 free space 1675 generation 8 owner 5
>> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
>> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>>       item 0 key (321 EXTENT_DATA 0) itemoff 1926 itemsize 2069
>>               inline extent data size 2048 ram 2048 compress 0
>>       item 1 key (322 INODE_ITEM 0) itemoff 1766 itemsize 160
>>               inode generation 8 size 2048 block group 29360128 mode 100644
>> links 1
>>       item 2 key (322 INODE_REF 256) itemoff 1750 itemsize 16
>>               inode ref index 67 namelen 6 name: file66
>> ...
>>
>> Appendix C.
>> -----------
>>
>> D.E. Knuth, The Art of Computer Programming, vol. 3 (Sorting and Searching),
>> Addison-Wesley, Reading, MA, 1973.
>>
>> --
>> Edward O. Shishkin
>> Principal Software Engineer
>> Red Hat Czech
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
> Hi to all,
>
> First of let me say: Btrfs really has matured a lot in the last months
> and this is thanks to you guys (the developers !)
>
> More and more people are making it their dedicated filesystem (MeeGo)
> or an option (Ubuntu, Fedora)
>
> So thank you very very much for your on-going efforts on making this
> more and more a viable (and usable !) alternative/competition to zfs
> :)
>
> The problems Edward mentioned sound like some very important points
> (issues ?) to investigate
>
> I find it somewhat surprising that none of you guys commented on his mail
>   

It must be a highly unexpected and difficult question for file system
developers: "how efficiently does your file system manage disk space"?

In the meanwhile I confirm that Btrfs design is completely broken:
records stored in the B-tree differ greatly from each other (it is
unacceptable!), and the balancing algorithms have been modified in
insane manner. All these factors has led to loss of *all* boundaries
holding internal fragmentation and to exhaustive waste of disk space
(and memory!) in spite of the property "scaling in their ability to
address large storage".

This is not a large storage, this is a "scalable sieve": you can not
rely on finding there some given amount of water even after infinite
increasing the size of the sieve (read escalating the pool of Btrfs
devices).

It seems that nobody have reviewed Btrfs before its inclusion to the
mainline. I have only found a pair of recommendations with a common
idea that Btrfs maintainer is "not a crazy man". Plus a number of
papers which admire with the "Btrfs phenomena". Sigh.

Well, let's decide what can we do in current situation..
The first obvious point here is that we *can not* put such file system
to production. Just because it doesn't provide any guarantees for our
users regarding disk space utilization.

I'll explain on a simple example, why is it important. Think of a file
system as a bank, which deducts an interest q. I.e. amount of money N
that you put on your account can be reduced to (N - qN). That said,
in order to buy a suit which costs M you should put to your account
not less than M/(1-q). Now imagine that the bank deducts 100% (q=1).
Will you bring your money to such bank? No. Not just because you are
greedy, but also because you won't be able to schedule your purchases.
So why should we push our users to keep money in such bank?

I should remind for developers that we work for *users*. They want a
*good* environment to run programs. Our subsystems should provide
*efficient* management of user's resources (such as memory and disk
space). A subsystem which is going to send all user's resources to the
toilet is *bad*!!!

If you decide to base your file system on some algorithms then please
use the original ones from proper academic papers. DO NOT modify the
algorithms in solitude: this is very fragile thing! All such
modifications must be reviewed by specialists in the theory of
algorithms. Such review can be done in various scientific magazines of
proper level.

Personally I don't see any way to improve the situation with Btrfs
except full redesigning the last one. If you want to base your file
system on the paper of Ohad Rodeh, then please, use *exactly* the
Bayer's B-trees that he refers to. That said, make sure that all
records you put to the tree has equal length and all non-root nodes of
your tree are at least half filled.

As to current Btrfs code: *NOT ACK*!!! I don't think we need such
"file systems".

Thanks!
