Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58534 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab2GBOe6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 10:34:58 -0400
Date: Mon, 2 Jul 2012 16:34:53 +0200
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: xfstests/224 lockup/slowdown (was: Please hammer my for-linus
 branch)
Message-ID: <20120702143453.GD5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120701012259.GM17638@shiny>
 <20120702141052.GC5326@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120702141052.GC5326@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2012 at 04:10:52PM +0200, David Sterba wrote:
> Finishing this report anyway, and will redo the tests again.
> 
> Looking again into the logs, the first process snapshot (only D-state
> processes) is much longer than process snapshot of containing all,
> unfortuntelly I don't have timestamps recorded, but this suggests that it's
> very slowly going on, so slowly that I considered it stalled looking at the
> io graphs.

Fresh build, reboot, and single xfstests/224 run:

during first ~20 seconds, there's high write activity, ie. file setup,
then it goes to a "few tens-to-hundreds of KB every 4 seconds". Cpu is idle,
sample output from dstat:

----total-cpu-usage---- --dsk/sda9- ---system--
usr sys idl wai hiq siq| read  writ| int   csw
  1   1  99   0   0   0|   0     0 | 923  1856
  0   1  98   0   1   0|   0  8192B| 904  2796
  0   1  99   0   0   0|   0     0 | 945  1914
  1   1  98   0   0   0|   0     0 | 899  1849
  1   1  98   0   0   1|   0     0 | 906  1848
  0   3  97   0   0   0|   0    20k| 901  3740
  0   0 100   0   0   0|   0     0 | 905  1851
  1   1  98   0   0   1|   0     0 | 946  1917
  0   1  99   0   0   0|   0     0 | 904  1858
  0   1  99   0   0   0|   0  8192B| 907  2805
  1   1  98   0   0   1|   0     0 | 891  1836
  0   1  99   0   0   0|   0     0 | 900  1847
  0   1  99   0   0   0|   0     0 | 940  1905
  1   4  95   0   0   0|   0    32k| 904  5153
  1   2  97   0   0   0|   0    36k| 913  4240
  0   1  99   0   0   0|   0     0 | 907  1849
  0   1  99   0   0   0|   0     0 | 908  1852
  1   1  98   0   0   1|   0     0 | 933  1901
  1   2  98   0   0   0|   0  8192B| 916  2808
  0   1  99   0   0   0|   0     0 | 917  1843
  0   1  99   0   0   1|   0     0 | 908  1844
  1   1  99   0   0   0|   0     0 | 905  1860
  0   5  95   0   0   0|   0    36k| 943  7565
  1   1  99   0   0   0|   0     0 | 911  1861
  0   1  99   0   0   0|   0     0 | 910  1852
  1   1  98   0   0   0|   0     0 | 944  1878
  1   2  97   0   0   1|   0    16k| 898  3753
  0   9  87   4   0   1|   0  1020k|1035    11k
  0  19  74   7   0   1|   0  2092k|3052    24k
  0   1  99   0   0   0|   0     0 | 909  1851
  1   1  98   0   0   1|   0     0 | 915  1856
  1   1  99   0   0   0|   0     0 | 896  1847
  0   2  98   0   0   0|   0  8192B| 931  2847
  0   1  99   0   0   0|   0     0 | 899  1850
  1   1  98   0   0   1|   0     0 | 896  1861
  0   1  99   0   0   0|   0     0 | 911  1855
  1   5  94   0   0   0|   0    28k| 891  6521
  0   9  87   3   0   1|   0  1100k| 963    11k
  0   1  99   0   0   0|   0     0 | 905  1857
  1   1  99   0   0   0|   0     0 | 895  1851
  1   1  98   0   0   0|   0     0 | 911  1852
  0   7  88   4   0   1|   0   700k| 911  8533
  0   1  99   0   0   0|   0     0 | 940  1905
  1   1  99   0   0   0|   0     0 | 912  1851
  1   1  99   0   0   0|   0     0 | 895  1851
  0  10  89   0   0   1|   0   100k| 912    13k

and repeats more or less the same.

Bisection in progress.


david
