From: Olivier Doucet <webmaster@ajeux.com>
Subject: BTRFS Benchmarking
Date: Fri, 4 May 2012 18:03:50 +0200
Message-ID: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello everyone,

I made an overall benchmark of BTRFS against EXT4 and XFS. I'm quite
unhappy with BTRFS results, so maybe tuning was not perfect.

http://www.slideshare.net/ezameku/btrfs-benchmark

All data is vectorial, so download the PDF and you can zoom ;)

If you have any feedback on how to improve BTRFS results (and others
fs too !), I would be glad to update my data.

Test protocol
Server : dual CPU Intel L5640 with HT enabled
Operating system : CentOS 6.2 (64bits version) with custom tools/kernels
Kernel : 3.3.0
Btrfs progs: version 0.19
Drive : Seagate 3TB drive (ST33000652SS) SAS attached via an LSI HBA.
Drive was accessed through LVM ;

MKFS options
BTRFS    : none
XFS         : none
EXT4       : none

Mount options
BTRFS          : "noatime,nodiratime"
BTRFS compress : "noatime,nodiratime,compress=lzo"
EXT4           : "noatime,nodiratime"
XFS            : "noatime,nodiratime"

Benchmark is done with Sysbench (fileio test).
Each benchmark was done for 60 seconds, and generated one point on the
graph each second (to see variations).
Right scale is block size.

Data read / written is from /dev/urandom, so cannot be compressed much
(that was expected behaviour).

All second pages has no legend, I'm sorry for that :
- data is 95 percentile aggregate.
- colours are the same.


Overview of results

On sequential read, there is no variations between FS.
On sequential write, BTRFS has lower values than EXT4/XFS. On random
write also.


Olivier
