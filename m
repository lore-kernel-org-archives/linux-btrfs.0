From: Markus Lindberg <marcuslindberk@gmail.com>
Subject: Re: [RFB] add LZ4 compression method to btrfs
Date: Tue, 14 Feb 2012 20:44:08 +0000 (UTC)
Message-ID: <loom.20120214T214105-102@post.gmane.org>
References: <20120213190325.GJ15350@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> Silesia corpus (avg of 10 runs), AMD bulldozer box, 12G ram, 1Ghz cpu:
> 
> lz4              =   739860 us ( 286 MB/s)   195930 us (1081 MB/s) 211957760
-> 101630873 47.9%
> snappy 1.0.4     =     1050 ms ( 201 MB/s)      248 ms ( 853 MB/s) 211957760
-> 104739310 49.4%
> snappy-c         =   940111 us ( 225 MB/s)   299690 us ( 707 MB/s) 211957760
-> 131060567 61.8%
> lzo 2.06 1x_1    =   739421 us ( 286 MB/s)   436542 us ( 485 MB/s) 211957760
-> 100576151 47.5%
> 
> Silesia corpus (avg of 10 runs), Nehalem X7560, 2.3Ghz cpu:
> 
> lz4              =   624170 us ( 339 MB/s)   200622 us (1056 MB/s) 211957760
-> 101630873 47.9%
> snappy 1.0.4     =     1047 ms ( 202 MB/s)      265 ms ( 797 MB/s) 211957760
-> 104739310 49.4%
> snappy-c         =   836415 us ( 253 MB/s)   300567 us ( 705 MB/s) 211957760
-> 131060567 61.8%
> lzo 2.06 1x_1    =   639305 us ( 331 MB/s)   470840 us ( 450 MB/s) 211957760
-> 100576151 47.5%
> 


Are you sure about these figures ? the difference seems too large. It's almost
unbelievable.


