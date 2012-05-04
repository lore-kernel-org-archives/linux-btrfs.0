From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS Benchmarking
Date: Fri, 4 May 2012 12:07:49 -0400
Message-ID: <20120504160749.GA1915@localhost.localdomain>
References: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Olivier Doucet <webmaster@ajeux.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 06:03:50PM +0200, Olivier Doucet wrote:
> hello everyone,
> 
> I made an overall benchmark of BTRFS against EXT4 and XFS. I'm quite
> unhappy with BTRFS results, so maybe tuning was not perfect.
> 
> http://www.slideshare.net/ezameku/btrfs-benchmark
> 
> All data is vectorial, so download the PDF and you can zoom ;)
> 
> If you have any feedback on how to improve BTRFS results (and others
> fs too !), I would be glad to update my data.
> 
> Test protocol
> Server : dual CPU Intel L5640 with HT enabled
> Operating system : CentOS 6.2 (64bits version) with custom tools/kernels
> Kernel : 3.3.0
> Btrfs progs: version 0.19
> Drive : Seagate 3TB drive (ST33000652SS) SAS attached via an LSI HBA.
> Drive was accessed through LVM ;
> 
> MKFS options
> BTRFS    : none
> XFS         : none
> EXT4       : none
> 
> Mount options
> BTRFS          : "noatime,nodiratime"
> BTRFS compress : "noatime,nodiratime,compress=lzo"
> EXT4           : "noatime,nodiratime"
> XFS            : "noatime,nodiratime"
> 
> Benchmark is done with Sysbench (fileio test).
> Each benchmark was done for 60 seconds, and generated one point on the
> graph each second (to see variations).
> Right scale is block size.
> 
> Data read / written is from /dev/urandom, so cannot be compressed much
> (that was expected behaviour).
> 
> All second pages has no legend, I'm sorry for that :
> - data is 95 percentile aggregate.
> - colours are the same.
> 
> 
> Overview of results
> 
> On sequential read, there is no variations between FS.
> On sequential write, BTRFS has lower values than EXT4/XFS. On random
> write also.
> 

Not what I've been seeing at all, but we've been working a lot in this area
recently.  Please retest with btrfs-next.  Thanks,

Josef
