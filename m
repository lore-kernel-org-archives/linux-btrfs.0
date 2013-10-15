Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:13812 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759855Ab3JOT4T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 15:56:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAOMFOmWOwdkwpuiEQbWYRoUDXEKGy_JqM0BtN2AhSF7JHDq69Q@mail.gmail.com>
Date: Tue, 15 Oct 2013 13:56:18 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <B9392C0E-30F1-499D-ADE1-324A32AFA442@colorremedies.com>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com> <CAOMFOmX95ebV=myVO1yDf5yPs7DfmvHDKDFwNNfT0CajDQ=W4Q@mail.gmail.com> <20131008071232.GA1402@localhost.localdomain> <CAOMFOmWOwdkwpuiEQbWYRoUDXEKGy_JqM0BtN2AhSF7JHDq69Q@mail.gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wrote:
> On Oct 11, 2013, at 8:22 PM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
> 
>> Hi,
>> 
>> Kernel 3.12-rc built from HEAD has the same issue as 3.10 and 3.11
>> 
>> Ok, I was able to "fix" my problem by booting from an old kernel
>> (3.8.7) and it allowed me to mount the fs.
> 
> Interesting.

It could be angels dancing on headpins territory, but I'm curious if successful mount is reproducible with either 3.4.66 or 3.9.11. The 3.5 through 3.8 kernels are neither listed as stable nor longterm.


Chris Murphy