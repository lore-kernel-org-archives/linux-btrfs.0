From: Chris Mason <chris.mason@oracle.com>
Subject: Re: umount oops
Date: Fri, 25 Jul 2008 08:43:33 -0400
Message-ID: <1216989813.7572.19.camel@think.oraclecorp.com>
References: <11129bee0807241413s4eb4a75fj90772b1711fc7e52@mail.gmail.com>
	 <11129bee0807250414p7f28a4daxa3cd49c1bcd983c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Lukas Vacek <pheeror@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <11129bee0807250414p7f28a4daxa3cd49c1bcd983c2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-25 at 13:14 +0200, Lukas Vacek wrote:
> sorry, I made a typo in the "testcase" (the second mount)
> Basically, it might be enough to mount two different btrfs filesystems
> to two different locations, umount one of them and watch
> /var/log/kern.log for the oops
> 

Thanks for this bug report, which Btrfs version was in use?

-chris


