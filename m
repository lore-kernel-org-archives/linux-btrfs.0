From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 04 May 2009 12:03:58 -0400
Message-ID: <49FF11EE.2060404@redhat.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090504151518.GA13777@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Glanzmann wrote:
> Hello Ric,
> 
>> (1) Block level or file level dedup?
> 
> what is the difference between the two?
> 
>> (2) Inband dedup (during a write) or background dedup?
> 
> I think inband dedup is way to intensive on ressources (memory) and also
> would kill every performance benchmark. So I think the offline dedup is
> the right way to go.

I would not categorize it as offline, but just not as inband (i.e., you can run 
a low priority background process to handle dedup).  Offline windows are 
extremely rare in production sites these days and it could take a very long time 
to do dedup at the block level over a large file system :-)

> 
>> (3) How reliably can you protect the pool of blocks? How reliably can
>> you protect the database that maps hashes to blocks?
> 
> You have to lock down the i/o requests for the blocks in question and
> compare them byte by byte anyway, just to make sure.

Yes, one advantage we had in centera was that the objects were read-only and 
whole files, so this was not an issue for us.

> 
>> (4) Can you give users who are somewhat jaded confidence in your
>> solution (this is where stats come in very handy!)
> 
> For virtual machines you can reduce the used data by 1/3. Of course it
> can blow in your face when you don't watch your physical resources
> closely.
> 
>         Thomas

1/3 is not sufficient for dedup in my opinion - you can get that with normal 
compression at the block level.

Put another way, if the baseline is bzip2 levels of compression for the block 
device, when is the complexity of dedup going to pay off?

I think that Chris already mentioned that you can (for virt OS images) also 
imagine using copy on write snapshots (of something that is mostly read-only 
like the OS system partitions).  Make 50 copy-on-write snapshots of "/" 
(excluding /home) and you have an effective compression of 98% until someone 
rudely starts writing at least :-)

ric


