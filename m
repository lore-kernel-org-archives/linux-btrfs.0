From: Tobias <tracer@robotech.de>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 18:45:46 +0100
Message-ID: <4EEB83CA.5050904@robotech.de>
References: <4EEA4124.20907@robotech.de> <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com> <CAAE6i0jL=mD=HU0GtfpJPLu__7NtV6WAuGb25CAWtV6N4f33wQ@mail.gmail.com> <4EEAC5D7.80707@gmail.com> <4EEB0ABA.5050202@robotech.de> <20111216091959.GA4051@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111216091959.GA4051@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.12.2011 10:19, schrieb Sander:
> Tobias wrote (ao):
>>>>> On Fri, Dec 16, 2011 at 1:49 AM, Tobias<tracer@robotech.de>   wrote:
>>>>>> My BTRFS-FS ist getting really slow. Reading is ok, writing is
>>>>>> slow and deleting is horrible slow.
>>>>>>
>>>>>> There are many files and many links on the FS.
> Do you happen to have (many) snapshots? Are btrfs kernel threads using a
> lot of cpu?
>
No Snapshots at all. Only compress-force=lzo, nothing else special.

The CPU is almost idle, IOwait is at 100%; looks likes the discs are 
accessing many small blocks. (seeking like hell...)

Output from iostat (average each over 120 seconds)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.42  195.31  190.44   781.23  1657.90    
12.65    64.91  168.90    3.42  338.60   2.51  96.64
sdb               0.00     0.50   75.00  336.57   300.00  2028.60    
11.32   105.41  255.83    3.16  312.14   2.24  92.38
sdb               0.00     0.62   72.03  441.72   288.11  2164.88     
9.55   116.39  226.27    4.20  262.48   1.89  97.29
sdb               0.00     0.20    1.07  468.74     4.26  2604.99    
11.11   145.07  308.91  581.30  308.29   2.13 100.00
sdb               0.00     0.00   20.00  326.97    80.00  2114.03    
12.65    38.56  111.41   58.02  114.67   2.83  98.28
sdb               0.00     0.00    5.02  563.35    20.08  3102.45    
10.99   137.71  242.26    6.44  244.36   1.70  96.62

Tobias




