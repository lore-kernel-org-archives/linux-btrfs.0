From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: add better -ENOSPC handling VERSION 3
Date: Thu, 19 Feb 2009 08:30:30 -0500
Message-ID: <20090219133030.GA24890@unused.rdu.redhat.com>
References: <1234557604-28769-1-git-send-email-jbacik@redhat.com> <20090217182110.00bdb9e3.ytakahashi@miraclelinux.com> <20090217134219.GA2882@unused.rdu.redhat.com> <20090219174554.490a9a0b.ytakahashi@miraclelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090219174554.490a9a0b.ytakahashi@miraclelinux.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 19, 2009 at 05:45:54PM +0900, Yoshihiro Takahashi wrote:
> Hi Josef.
> 
> > Thank you, what tool are you using to create these files and such?
> 
> I use an original tool.
> I do not make the document.
> 
> ex.
> ./mkfbmt -d /btrfs -f 10000000 -x 10000
> This makes a file under 10,000 directories with 10,000,000 files in /btrfs.
> 
> make 10,000 files under 100 directories each.
> 100dir * 10000files = 10000000
> 
> /btrfs/0/0
> /btrfs/0/1
>  ...
> /btrfs/0/9998
> /btrfs/0/9999
> /btrfs/1/0
>  ...
> /btrfs/99/9999
> 
> defaults file size is zero byte.
> When make a file of 4,096 bytes, please appoint -w 4096.
> defaults option is all test.
> -m mkdir
> -c open(O_CREAT | O_EXCL | O_WRONLY) test
> -o open test
> -p utime test
> -s stat test
> -u unlink test
> -r rmdir
> 
> # ./mkfbmt -d /btrfs/ -f 1000000 -x 10000
> ## __linuxfs_init(91) [0x401fc8]
> mkfbmt 100 directry 1000000 files , one directry 10000 files
> make files for /btrfs
> 
> mkdir : 0.004923 sec , 1 file mkdir  for 0.000000 sec
> creat : 179.155566 sec , 1 file creat  for 0.000179 sec
> open  : 26.696062 sec , 1 file open   for 0.000027 sec
> utime : 55.143818 sec , 1 file utime   for 0.000055 sec
> stat  : 4.692097 sec , 1 file stat   for 0.000005 sec
> unlink: 210.624820 sec , 1 file unlink for 0.000211 sec
> rmdir : 0.806472 sec , 1 file rmdir  for 0.000001 sec
> file        creat       open        utime       stat        unlink
>      50000       4.08       1.18       2.17       0.13      14.18
>     100000      10.70       1.86       4.78       0.25      22.57
>     150000      55.87       2.42       7.57       0.37      30.99
>     200000      63.74       3.23       9.81       0.49      42.35
>     250000      69.72       4.93      12.16       0.60      55.71
>     300000      76.37       7.16      14.56       0.72      64.03
>     350000      83.60      10.34      17.01       0.83      91.18
>     400000      90.23      15.36      19.60       0.94     103.36
>     450000      97.47      20.07      22.17       1.06     111.07
>     500000     103.99      22.14      24.56       1.38     118.84
>     550000     110.85      22.36      26.93       1.88     126.66
>     600000     118.49      22.58      29.70       2.30     136.47
>     650000     125.26      23.08      32.05       2.50     148.96
>     700000     132.34      23.65      34.28       3.01     156.62
>     750000     138.89      24.22      36.80       3.54     164.49
>     800000     146.38      24.78      44.05       4.05     172.23
>     850000     155.14      25.34      46.81       4.28     180.48
>     900000     163.21      26.25      49.85       4.41     195.99
>     950000     171.81      26.47      52.22       4.55     203.47
>    1000000     179.16      26.70      55.14       4.69     210.62
> 
> Best regards,
>

That is perfect thank you, I will add it to my enospc tests.  I'm working on a
patch which should fix your problems, I will send it out later today after I run
your tests on it.  Thanks,

Josef
 
