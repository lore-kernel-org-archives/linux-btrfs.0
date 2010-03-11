From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:22:44 -0500
Message-ID: <yq1k4ti6d63.fsf@sermon.lab.mkp.net>
References: <4B97F7CE.4030405@bobich.net> <4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
	<7832455d62f27d8fb89a7c40ac3cd386@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7832455d62f27d8fb89a7c40ac3cd386@localhost> (Gordan Bobic's
	message of "Thu, 11 Mar 2010 12:09:29 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Gordan" == Gordan Bobic <gordan@bobich.net> writes:

Gordan> I fully agree that it's important for wear leveling on flash
Gordan> media, but from the security point of view, I think TRIM would
Gordan> be a useful feature on all storage media. If the erased blocks
Gordan> were trimmed it would provide a potentially useful feature of
Gordan> securely erasing the sectors that are no longer used. It would
Gordan> be useful and much more transparent than the secure erase
Gordan> features that only operate on the entire disk. Just MHO.

Except there are no guarantees that TRIM does anything, even if the
drive claims to support it.

There are a couple of IDENTIFY DEVICE knobs that indicate whether the
drive deterministically returns data after a TRIM.  And whether the
resulting data is zeroes.  We query these values and report them to the
filesystem.

However, testing revealed several devices that reported the right thing
but which did in fact return the old data afterwards.

-- 
Martin K. Petersen	Oracle Linux Engineering
