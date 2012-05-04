From: Olivier Doucet <webmaster@ajeux.com>
Subject: Re: BTRFS Benchmarking
Date: Sat, 5 May 2012 01:15:39 +0200
Message-ID: <CAPPqfY2aQO_y_TcFwUHUtJEOxZ6QP3XCPk5c86SUMpF31HwHCg@mail.gmail.com>
References: <CAPPqfY0iGPjRDC0YG814uiv4+9jLU54w6D5Yh=okTqG7VtwXOA@mail.gmail.com>
	<20120504223905.GH9860@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Olivier Doucet <webmaster@ajeux.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120504223905.GH9860@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I uploaded the PDF on Dropbox that does not require login
https://www.dropbox.com/s/5i8l0kmdutxj6pb/sysbench-sas3t-btrfs1.pdf


> =A0 Can you tell us what the unit of the Y-axis is? Is it MB/s or IOP=
s
> or time for a fixed amount data or... ?
Unit is MB/s ;
=46or each test, I gather speed every second.
So for a particular test, there is 60 dots (for example, speed for
BTRFS on 1 thread, blocksize=3D512b, sequential read).
As 60 dots are not easy to read, I created second pages with one
aggregated value as 95 percentile.

Sequential read results seems heavily altered by Linux pagecache. I
wondered what would be the exact methodology to disable this
optimization.
But all FS were run in the exact same behaviour (bash scripted with
umount / mount after each session).


I provided access to the bash script I used and R script to create nice=
 PDF.
=46eel free to give me any feedback on how I could get results more acc=
urate.

https://github.com/odoucet/fs-benchs


> =A0 For example, in the seqwr/512 test, is btrfs doing really well at
> small numbers of threads, getting steadily worse, or is it doing
> really badly, and improves hugely as the number of threads goes up?

It is doing badly but improves when number of threads goes up.


I'll improve my benchmark results by adding self-explainable legends.
I will be happy to discuss my methodology if you think something is
wrong.


Olivier
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
