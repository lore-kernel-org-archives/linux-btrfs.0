From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: machine gets unresponsive during btrfs balance
Date: Thu, 26 Aug 2010 18:38:30 +0200
Message-ID: <201008261838.30509.johannes.hirte@fem.tu-ilmenau.de>
References: <4C639F42.3050206@gmail.com> <201008261527.54056.johannes.hirte@fem.tu-ilmenau.de> <4C766E8D.7000103@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C766E8D.7000103@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 26 August 2010 15:39:25 Andreas Philipp wrote:
> On 26.08.2010 15:27, Johannes Hirte wrote:
> > Looks like another manifestation of the csum bug. Are you able to read all
> > files from the affected volume? Did you tried a balance with an 2.6.34 kernel
> > after the test with 2.6.35?
> >
> Till now I did not see any unreadable files but I did not do a
> complete test. No, I did not try to balance with an 2.6.34 kernel. If
> it helps I can switch back and try.

I hope it helps to localize the error. It's still not clear where this starts 
an what kernels are affected.

regards,
  Johannes
