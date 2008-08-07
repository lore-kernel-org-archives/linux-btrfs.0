From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 07 Aug 2008 10:06:20 -0400
Message-ID: <1218117980.15342.200.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <3da3b5b40808070703x4cf49471q6acc00351ba019d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40808070703x4cf49471q6acc00351ba019d7@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-07 at 17:03 +0300, Ahmed Kamal wrote:
> With csum errors, do we get warnings in logs ?

Yes

>  Does too many faults cause a device to be flagged as faulty ?

Not yet

>  is there any user-space application to monitor/scrub/re-silver btrfs
> volumes ?
> 
Not yet, but there definitely will be.

-chris


