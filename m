From: Hugo Chevrain <hugochevrain@gmail.com>
Subject: Re: [RFB] add LZ4 compression method to btrfs
Date: Thu, 16 Feb 2012 13:07:29 +0000 (UTC)
Message-ID: <loom.20120216T135449-686@post.gmane.org>
References: <20120213190325.GJ15350@twin.jikos.cz> <loom.20120214T214105-102@post.gmane.org> <loom.20120214T224130-74@post.gmane.org> <CABsxX9J6G-MbTRorBuZTE1y5js5oziFNGFHgyAH2WUNKQnF3bQ@mail.gmail.com> <4F3BECE3.1080905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

You're right about the broken links, my bad.


The first link related to a few statements by Mark Ruijter, copy/pasted below :

> I just looked into it and it appears to be promising. 
> On average the speeds appear to be 48% faster then snappy.
> This is amazing since snappy has proved to be 30% faster then QuickLZ 
> which once was the fastest compression protocol.

==> http://www.lessfs.com/wordpress/?p=684#comments

> I did not test LZ4 on high end hardware yet. 
> However even on my laptop it is clear that LZ4 does outperform snappy. 
> With the hardware being the bottleneck 
> LZ4 still manages to speed things up by 2~5%. 
> Most likely the difference will be larger when fast hardware is used

==> http://www.lessfs.com/wordpress/?p=688

There is no precise benchmark though. Just this sentence :

> I will post the exact performance numbers on low and high end hardware 
> after testing has finished.

So maybe someone has to ask Mark about these results.


The second link initially linked to Hadoop, which recently decided to integrate
LZ4 compression :
==> https://issues.apache.org/jira/browse/HADOOP-7657

However, since then, i've discovered the website of the developper in charge of
this patch (Binglin Chang), and he has come nice comparison figures available.
The main summary is copy/pasted below :

> Perf.RawCompressionLZ4    Block size: 64K
> Compress:  428M/s Decompress:   681M/s( 1584M/s) ratio: 43.0% - Total

> Perf.RawCompressionSnappy Block size: 64K
> Compress:  400M/s Decompress:   442M/s(  979M/s) ratio: 45.2% - Total

==> https://github.com/decster/jnicompressions/blob/master/README.md


