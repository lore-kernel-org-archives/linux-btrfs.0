From: Chris Mason <chris.mason@oracle.com>
Subject: Re: umount oops
Date: Fri, 25 Jul 2008 10:08:10 -0400
Message-ID: <1216994890.7572.33.camel@think.oraclecorp.com>
References: <11129bee0807241413s4eb4a75fj90772b1711fc7e52@mail.gmail.com>
	 <11129bee0807250414p7f28a4daxa3cd49c1bcd983c2@mail.gmail.com>
	 <1216989813.7572.19.camel@think.oraclecorp.com>
	 <11129bee0807250654h8ea4601q3d9ce736370acafd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Lukas Vacek <pheeror@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <11129bee0807250654h8ea4601q3d9ce736370acafd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-25 at 15:54 +0200, Lukas Vacek wrote:
> the newest in the mercurial repo
> 
> changeset:   558:9da425337329
> tag:         tip

This should be fixed by the unstable tree, the transaction work queues
were not properly being torn down.

-chris


