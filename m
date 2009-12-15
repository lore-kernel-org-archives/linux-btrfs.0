From: David Nicol <davidnicol@gmail.com>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
	link
Date: Tue, 15 Dec 2009 11:31:51 -0600
Message-ID: <934f64a20912150931q46aea2eer12bc907ecb0137fc@mail.gmail.com>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com>
	<4B23E378.1090905@mit.edu> <4B257BF4.5060807@jp.fujitsu.com>
	<cb0375e10912141043u476619bey766cfa366a8aac46@mail.gmail.com>
	<4B26D504.3080201@jp.fujitsu.com> <4B270ABE.5090109@myrealbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B270ABE.5090109@myrealbox.com>
List-ID: <linux-btrfs.vger.kernel.org>

how about supporting the operation, as a feature, and allowing a file
to be in two different subvolumes at the same time? Would that make
the link semantics too confusing?

-- 
Is it the time when there isn't time to discuss but there is time to act yet?
