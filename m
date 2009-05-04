From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 04 May 2009 10:45:46 -0400
Message-ID: <49FEFF9A.8060803@redhat.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Michael Tharp <gxti@partiallystapled.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FEFE27.5090804@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2009 10:39 AM, Tomasz Chmielewski wrote:
> Ric Wheeler schrieb:
>
>> One thing in the above scheme that would be really interesting for 
>> all possible hash functions is maintaining good stats on hash 
>> collisions, effectiveness of the hash, etc. There has been a lot of 
>> press about MD5 hash collisions for example - it would be really neat 
>> to be able to track real world data on those,
>
> See here ("The hashing function"):
>
> http://backuppc.sourceforge.net/faq/BackupPC.html#some_design_issues
>
> It's not "real world data", but it gives some overview which applies 
> here.
>
>

I have lots of first hand "real world" data from 5 years at EMC in the 
Centera group where we used various types of hashes to do single 
instancing at the file level, but those are unfortunately not public :-) 
Note that other parts of EMC do dedup at the block level (Avamar most 
notably).

The key to doing dedup at scale is answering a bunch of questions:

     (1) Block level or file level dedup?
     (2) Inband dedup (during a write) or background dedup?
     (3) How reliably can you protect the pool of blocks? How reliably 
can you protect the database that maps hashes to blocks?
     (4) Can you give users who are somewhat jaded confidence in your 
solution (this is where stats come in very handy!)
     (5) In the end, dedup is basically a data compression trick - how 
effective is it (including the costs of the metadata, etc) compared to 
less complex schemes? What does it costs in CPU, DRAM and impact on the 
foreground workload?

Dedup is a very active area in the storage world, but you need to be 
extremely robust in the face of failure since a single block failure 
could (worst case!) lose all stored data in the pool :-)

Regards,

Ric

