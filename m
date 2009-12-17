From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
 	link
Date: Thu, 17 Dec 2009 09:00:04 +0900
Message-ID: <4B297484.8010408@jp.fujitsu.com>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com> 	<4B23E378.1090905@mit.edu> <4B257BF4.5060807@jp.fujitsu.com> 	<cb0375e10912141043u476619bey766cfa366a8aac46@mail.gmail.com> 	<4B26D504.3080201@jp.fujitsu.com> <4B270ABE.5090109@myrealbox.com> <934f64a20912150931q46aea2eer12bc907ecb0137fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: davidnicol@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <934f64a20912150931q46aea2eer12bc907ecb0137fc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Supporting it may be not so confusing, but it may need
a little format change to record tree and inode number.
I think it's not so acceptable.

Regards,
taruisi

(2009/12/16 2:31), David Nicol wrote:
> how about supporting the operation, as a feature, and allowing a file
> to be in two different subvolumes at the same time? Would that make
> the link semantics too confusing?
> 

