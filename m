Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78462C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 14:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3271B206B7
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 14:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3271B206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbeLCO0a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 09:26:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:58622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725918AbeLCO0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 09:26:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00CBAACD1
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 14:25:15 +0000 (UTC)
Subject: Re: [RFC PATCH] btrfs: Remove __extent_readpages
To:     linux-btrfs@vger.kernel.org
References: <20181203102532.13945-1-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <51be8fe3-e319-6666-2511-342446297f61@suse.com>
Date:   Mon, 3 Dec 2018 16:25:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203102532.13945-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 12:25 ч., Nikolay Borisov wrote:
> When extent_readpages is called from the generic readahead code it first
> builds a batch of 16 pages (which might or might not be consecutive,
> depending on whether add_to_page_cache_lru failed) and submits them to
> __extent_readpages. The latter ensures that the range of pages (in the
> batch of 16) that is passed to __do_contiguous_readpages is consecutive.
> 
> If add_to_page_cache_lru does't fail then __extent_readpages will call
> __do_contiguous_readpages only once with the whole batch of 16.
> Alternatively, if add_to_page_cache_lru fails once on the 8th page (as an example)
> then the contigous page read code will be called twice.
> 
> All of this can be simplified by exploiting the fact that all pages passed
> to extent_readpages are consecutive, thus when the batch is built in
> that function it is already consecutive (barring add_to_page_cache_lru
> failures) so are ready to be submitted directly to __do_contiguous_readpages.
> Also simplify the name of the function to contiguous_readpages. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> So this patch looks like a very nice cleanup, however when doing performance 
> measurements with fio I was shocked to see that it actually is detrimental to 
> performance. Here are the results: 
> 
> The command line used for fio: 
> fio --name=/media/scratch/seqread --rw=read --direct=0 --ioengine=sync --bs=4k
>  --numjobs=1 --size=1G --runtime=600  --group_reporting --loop 10
> 
> This was tested on a vm with 4g of ram so the size of the test is smaller than 
> the memory, so pages should have been nicely readahead. 
> 
> PATCHED: 
> 
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=519MiB/s][r=133k IOPS][eta 00m:00s] 
> /media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=3722: Mon Dec  3 09:57:17 2018
>   read: IOPS=78.4k, BW=306MiB/s (321MB/s)(10.0GiB/33444msec)
>     clat (nsec): min=1703, max=9042.7k, avg=5463.97, stdev=121068.28
>      lat (usec): min=2, max=9043, avg= 6.00, stdev=121.07
>     clat percentiles (nsec):
>      |  1.00th=[   1848],  5.00th=[   1896], 10.00th=[   1912],
>      | 20.00th=[   1960], 30.00th=[   2024], 40.00th=[   2160],
>      | 50.00th=[   2384], 60.00th=[   2576], 70.00th=[   2800],
>      | 80.00th=[   3120], 90.00th=[   3824], 95.00th=[   4768],
>      | 99.00th=[   7968], 99.50th=[  14912], 99.90th=[  50944],
>      | 99.95th=[ 667648], 99.99th=[5931008]
>    bw (  KiB/s): min= 2768, max=544542, per=100.00%, avg=409912.68, stdev=162333.72, samples=50
>    iops        : min=  692, max=136135, avg=102478.08, stdev=40583.47, samples=50
>   lat (usec)   : 2=25.93%, 4=65.58%, 10=7.69%, 20=0.57%, 50=0.13%
>   lat (usec)   : 100=0.04%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.05%
>   cpu          : usr=7.20%, sys=92.55%, ctx=396, majf=0, minf=9
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=306MiB/s (321MB/s), 306MiB/s-306MiB/s (321MB/s-321MB/s), io=10.0GiB (10.7GB), run=33444-33444msec
> 
> 
> UNPATCHED:
> 
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=568MiB/s][r=145k IOPS][eta 00m:00s] 
> /media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=640: Mon Dec  3 10:07:38 2018
>   read: IOPS=90.4k, BW=353MiB/s (370MB/s)(10.0GiB/29008msec)
>     clat (nsec): min=1418, max=12374k, avg=4816.38, stdev=109448.00
>      lat (nsec): min=1836, max=12374k, avg=5284.46, stdev=109451.36
>     clat percentiles (nsec):
>      |  1.00th=[   1576],  5.00th=[   1608], 10.00th=[   1640],
>      | 20.00th=[   1672], 30.00th=[   1720], 40.00th=[   1832],
>      | 50.00th=[   2096], 60.00th=[   2288], 70.00th=[   2480],
>      | 80.00th=[   2736], 90.00th=[   3248], 95.00th=[   3952],
>      | 99.00th=[   6368], 99.50th=[  12736], 99.90th=[  43776],
>      | 99.95th=[ 798720], 99.99th=[5341184]
>    bw (  KiB/s): min=34144, max=606208, per=100.00%, avg=465737.56, stdev=177637.57, samples=45
>    iops        : min= 8536, max=151552, avg=116434.33, stdev=44409.46, samples=45
>   lat (usec)   : 2=45.74%, 4=49.50%, 10=4.13%, 20=0.45%, 50=0.08%
>   lat (usec)   : 100=0.03%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.05%, 20=0.01%
>   cpu          : usr=7.14%, sys=92.39%, ctx=1059, majf=0, minf=9
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=353MiB/s (370MB/s), 353MiB/s-353MiB/s (370MB/s-370MB/s), io=10.0GiB (10.7GB), run=29008-29008msec
> 
> Clearly both bandwidth and iops are worse. However I'm puzzled as to why this is 
> the case, given that I don't see how this patch affects the submission of 
> readahead io. 
> 

I took slightly different measurements, namely: call count of 
contiguous_readpages/__do_contiguous_readpages, latency histogram of calls 
to extent_readpages as well as the output from cachetop (from bcc tools). Also I 
switched qemu's cache settings to 'none' for the virtio device which fio is writing to! 
The vms still has 4g of ram and this time the fio cmd line is: 

fio --name=/media/scratch/seqread --rw=read --direct=0 --ioengine=sync --bs=4k --numjobs=1 --size=2G --runtime=600  --group_reporting --loop 10 (I've modified the file to be 2g rather than 1 as in the original patch)

So here are the results: 

UNPATCHED CASE: 

/media/scratch/seqread: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=sync, iodepth=1
fio-3.12
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=470MiB/s][r=120k IOPS][eta 00m:00s] 
/media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=643: Mon Dec  3 13:55:09 2018
  read: IOPS=82.5k, BW=322MiB/s (338MB/s)(20.0GiB/63559msec)
    clat (nsec): min=1427, max=38694k, avg=5613.13, stdev=126477.18
     lat (nsec): min=1819, max=38695k, avg=6061.95, stdev=126479.46
    clat percentiles (nsec):
     |  1.00th=[   1480],  5.00th=[   1512], 10.00th=[   1528],
     | 20.00th=[   1560], 30.00th=[   1576], 40.00th=[   1592],
     | 50.00th=[   1624], 60.00th=[   1656], 70.00th=[   1720],
     | 80.00th=[   1896], 90.00th=[   2640], 95.00th=[   3024],
     | 99.00th=[   4768], 99.50th=[  12352], 99.90th=[1003520],
     | 99.95th=[3817472], 99.99th=[4685824]
   bw (  KiB/s): min=45728, max=549616, per=100.00%, avg=460140.08, stdev=144985.90, samples=91
   iops        : min=11432, max=137404, avg=115035.09, stdev=36246.50, samples=91
  lat (usec)   : 2=82.15%, 4=16.25%, 10=1.01%, 20=0.34%, 50=0.10%
  lat (usec)   : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.02%
  lat (msec)   : 2=0.02%, 4=0.04%, 10=0.04%, 20=0.01%, 50=0.01%
  cpu          : usr=5.81%, sys=81.11%, ctx=5682, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%

FUNC                                    COUNT
__do_contiguous_readpages              327935

Here is a histogram of latencies in microseconds

         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 10       |                                        |
        64 -> 127        : 20       |                                        |
       128 -> 255        : 6        |                                        |
       256 -> 511        : 13       |                                        |
       512 -> 1023       : 11       |                                        |
      1024 -> 2047       : 10       |                                        |
      2048 -> 4095       : 2516     |****************************************|
      4096 -> 8191       : 34       |                                        |

Output from cachetop for the duration of the test: 

   TOTAL   MISSES     HITS  DIRTIES   BUFFERS_MB  CACHED_MB
     354        1                       353        1           14       1063
  543360   524288    19072        0           14       2232
  379788   369092    10696        0           14       1956
  329056   316960    12096        0           14       1147
  377836   362181    15655        0           14        766
  543360   524288    19072        0           14       2036
  437191   423764    13427        0           14       2169
  327289   317440     9849        0           14       1361
  322175   307376    14799        0           14        513
  543352   524284    19068        0           14       1680
  481780   466852    14928        0           14       2338
  343440   331528    11912        0           14       1585
  344403   333824    10579        0           14        841
  564139   440492   123647        0           14       2160

total hits:294800                                                               
total misses: 5242370

PATCHED CASE: 

/media/scratch/seqread: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=sync, iodepth=1
fio-3.12
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=529MiB/s][r=135k IOPS][eta 00m:00s] 
/media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=620: Mon Dec  3 11:56:49 2018
  read: IOPS=81.2k, BW=317MiB/s (332MB/s)(10.0GiB/32302msec)
    clat (nsec): min=1428, max=152945k, avg=5927.07, stdev=246422.91
     lat (nsec): min=1837, max=152946k, avg=6427.46, stdev=246426.89
    clat percentiles (nsec):
     |  1.00th=[   1496],  5.00th=[   1528], 10.00th=[   1560],
     | 20.00th=[   1608], 30.00th=[   1672], 40.00th=[   1736],
     | 50.00th=[   1880], 60.00th=[   2192], 70.00th=[   2448],
     | 80.00th=[   2736], 90.00th=[   3280], 95.00th=[   4080],
     | 99.00th=[   7328], 99.50th=[  14528], 99.90th=[ 242688],
     | 99.95th=[3719168], 99.99th=[5013504]
   bw (  KiB/s): min= 1432, max=549808, per=100.00%, avg=396769.62, stdev=175814.08, samples=52
   iops        : min=  358, max=137452, avg=99192.48, stdev=43953.67, samples=52
  lat (usec)   : 2=53.85%, 4=40.84%, 10=4.54%, 20=0.47%, 50=0.15%
  lat (usec)   : 100=0.04%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.02%, 10=0.04%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%
  cpu          : usr=6.53%, sys=83.13%, ctx=2746, majf=0, minf=11
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=317MiB/s (332MB/s), 317MiB/s-317MiB/s (332MB/s-332MB/s), io=10.0GiB (10.7GB), run=32302-32302msec

FUNC                                    COUNT
contiguous_readpages                   327935

So the total number of times we call the low-level submission function is
identical across the 2 versions. This implies that the patch doesn't result 
in worse "merge" behavior i.e submitting more but smaller contiguous chunks via 
contiguous_readpages.

Cachetop: 
TOTAL   MISSES     HITS  DIRTIES   BUFFERS_MB  CACHED_MB                     
  475016   459690    15326        0           15       2313                     
  316483   309138     7345        2           15       1472                     
  326726   315393    11333        1           15        656                     
  508038   487596    20442        0           15       1710                     
  470487   456532    13955        0           15       2296                     
  329494   318160    11334        0           15       1492                     
  312000   300217    11783        0           15        617                     
  518013   497629    20384        0           15       1552                     
  518780   503636    15144        0           15       2480                     
  338471   325632    12839        0           15       1705                     
  325678   315328    10350        0           15        888                     
  447023   428204    18819        0           15       1127                     
  647182   524289   122893        0           15       2160                     
                                                                                
total hits: 291947<--- hits are negligibly smaller                                                    
total misses: 5241444<--- so are misses  



