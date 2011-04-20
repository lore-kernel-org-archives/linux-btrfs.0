From: Gregory L Shomo <greg@techsquare.com>
Subject: Re: parent transid troubles
Date: Wed, 20 Apr 2011 08:56:02 -0400
Message-ID: <sa2mxjl84kd.fsf@techsquare.com>
References: <1303241529-sup-4244@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303241529-sup-4244@think> (message from Chris Mason on Tue, 19 Apr 2011 15:34:43 -0400)
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> Excerpts from Gregory L Shomo's message of 2011-04-19 15:08:13 -0400:
>> Hello list-
>> 
>> Under heavy load (i/o), one of our fileservers lost two drives
>> in a raid6 configuration. After the drives were synchronized,
>> we can no longer mount the multiple-device btrfs filesystem
>> due to (at least) parent transid verification.
>> 
>> btrfsck built from git commit 1b444cd2e6ab8dcafdd47dbaeaae369dd1517c17
>> runs for a while and then aborts on 'failed to find block number'.
>> Sample output includes :
>
> Looks like the rebuild gave you older copies of some of the blocks.
> btrfsck will exit out pretty early when it sees problems, but I'd say
> most of your FS is there.
>
> Can you please do a btrfs-debug-tree /dev/xxx > out, I'd like to see how
> far we get.
>
> What errors do you get when trying to mount the FS?
>
> -chris

I'm not sure how far we will get, but btrfs-debug-tree
has been running for over 12h now and the screenlog is
at 80Gb. This may not be surprising, as the filesystem 
is large (60T) and has millions of files. 

>From the logs at boottime, we have

  btrfs: failed to read the system array on sdd1
  btrfs: open_ctree failed

Should we wait for the btrfs-debug-tree to finish
before executing an other mount command ? 

- greg


>>   parent transid verify failed on 22569952096256 wanted 176066 found
>>   176064
>>   parent transid verify failed on 22569952096256 wanted 176066 found
>>   176064
>>   parent transid verify failed on 20403515183104 wanted 176066 found
>>   174710
>>   parent transid verify failed on 20403515183104 wanted 176066 found
>>   174710
>>   parent transid verify failed on 1265784008704 wanted 176066 found
>>   175341
>>   !-- snip
>>   bad block 1099696562176
>>   leaf parent key incorrect 1117248647168
>>   !-- snip
>>   Extent back ref already exists for 1130294538240 parent 0 root 2
>>   Extent back ref already exists for 1130295001088 parent 0 root 2
>>   !-- snip
>>   fs uuid d8464857-db87-412e-9d57-ece6c2054f40
>>   chunk uuid 52a652a3-650d-4dd7-aaa2-6f096a714bbf
>>           item 0 key (20407857930240 EXTENT_ITEM 4096) itemoff 3944
>>   itemsize 51
>>                   extent refs 1 gen 165193 flags 2
>>                   tree block key (257306671 1 0) level 0
>>                   tree block backref root 5
>>           item 1 key (20407857934336 EXTENT_ITEM 4096) itemoff 3893
>>   itemsize 51
>>                   extent refs 1 gen 165308 flags 2
>>                   tree block key (257585950 1 0) level 0
>>                   tree block backref root 5
>>   !-- snip
>>   failed to find block number 20407858008064
>>   Aborted
>> 
>> Output is exactly the same when run against both devices, even
>> when using 'btrfsck -s1'.
>> 
>> Should we light a candle and say 'goodbye' to the data or is
>> there some hope that btrfsck will be able to help us mount the
>> filesystem ?
>> 
>> Is there any additional information that is useful to the developers ?
>> 
>> The system is based on fedora-14, btrfs-progs-0.19-12.fc14.x86_64,
>> and the arcmsr module (built from the 1.20.0X.15-100729 sources).
>> 
>> - greg
