From: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 07 Aug 2008 08:58:57 -0600
Message-ID: <489B0DB1.30407@nortel.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100139.8625.7.camel@twins> <1218105242.15342.184.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754082AbYHGO72@vger.kernel.org>
In-Reply-To: <1218105242.15342.184.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:

> I haven't done any real single cpu testing, it may make sense in those
> workloads to checksum and submit directly in the calling context.  But
> real single cpu boxes are harder to come by these days.

They're still pretty common in the embedded/low power space.  I could 
see something like a settop box wanting to use btrfs with massive disks.

Chris
