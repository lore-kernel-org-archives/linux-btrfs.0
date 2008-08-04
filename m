From: Chris Mason <chris.mason@oracle.com>
Subject: Re: crash when mounting
Date: Mon, 04 Aug 2008 09:08:15 -0400
Message-ID: <1217855295.29139.66.camel@think.oraclecorp.com>
References: <3da3b5b40808021612q1ec112c2jae0769b0abdcceb5@mail.gmail.com>
	 <1217854042.29139.41.camel@think.oraclecorp.com>
	 <3da3b5b40808040559h75d03539mbd408bd81a058844@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40808040559h75d03539mbd408bd81a058844@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-04 at 15:59 +0300, Ahmed Kamal wrote:
> Well, yeah sure. But I was kind of hoping my playing/testing is going
> to help you guys fix it. So, does that traceback help you pin point
> the problem ? If not, is there anything I can do, to help with that ?
> I believe this crash should be re-producible .. haven't tested that
> though
> 

Yes, it shows which part is broken ;)  This one won't be hard to trigger
or fix, it is just part of a larger effort to fixup handling bad data on
disk.

-chris


