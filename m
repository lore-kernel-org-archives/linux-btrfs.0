From: Peter Niemayer <niemayer@isg.de>
Subject: Poor performance (1/4 that of XFS) when appending to lots of files
Date: Mon, 07 Jun 2010 18:54:18 +0200
Message-ID: <huj87q$8ov$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we ran a benchmark using btrfs on a server that essentially does
the equivalent of the following:

Open one large (25GB) test-set file for reading, which consists of many
small randomly generated messages. Each message consists of a
primary key (an integer in the range of 0 to 1,000,000) and a random
number of arbitrary data bytes (length in the range from 10 to 1000 byte).

For each message, the server opens the file that is determined by the
primary key with O_APPEND, write()s the random data bytes to the file.
Then it closes the file.
The server runs 4 threads in parallel to spread the above action
over 4 CPU cores, each thread processes a quarter of the primary keys
(primary_key & 0x03).

The server does so until the whole 25GB test-set is processed (it
does not do any sync or fsync operation. The machine has 4GB memory,
so it has to actually write out most of the data).

This test, when run on a fast SSD (attached to a SAS channel), took us ~ 
30min to complete using XFS (mounted with "nobarrier", data security is 
not an issue in this scenario).

When using btrfs on the same hardware (same SSD, same system),
it took us ~ 120min.

The filesystem was mounted using the following options:
> mount -t btrfs -o nodatasum,nodatacow,nobarrier,ssd,noacl,notreelog,noatime,nodiratime  /dev/sdg /data-ssd3

(Both measurements done under linux-2.6.34).

Looks like btrfs is not really tuned to perform well in the above
scenario.

I would appreciate any advise on how to improve btrfs' performance for
the above scenario.

Regards,

Peter Niemayer

