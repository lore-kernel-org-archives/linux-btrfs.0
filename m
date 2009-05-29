From: Sumit Narayan <sumnaray@gmail.com>
Subject: Question on Btrfs Benchmarking results
Date: Fri, 29 May 2009 13:49:45 -0500
Message-ID: <a18f491d0905291149n26b7f5bdg6dbe0785d68cc34d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Can someone explain to me why performance of random writes without
checksum is worse compared to that with checksum enabled for 8 and 32
threads while good for single thread? Shouldn't it be better in all
cases (without checksum better than with checksum)?

1 thread - http://tinyurl.com/ksby5j
8 threads - http://tinyurl.com/nepcdt
32 threads - http://tinyurl.com/n2x3rt

Thanks,
Sumit.
