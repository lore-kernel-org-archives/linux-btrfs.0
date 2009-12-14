From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
	link
Date: Mon, 14 Dec 2009 13:43:20 -0500
Message-ID: <cb0375e10912141043u476619bey766cfa366a8aac46@mail.gmail.com>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com>
	<4B23E378.1090905@mit.edu> <4B257BF4.5060807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B257BF4.5060807@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

[cc: Chris -- This, or something like it, should probably go to
stable, but it needs to make it to upstream somewhere first.]

On Sun, Dec 13, 2009 at 6:42 PM, TARUISI Hiroaki
<taruishi.hiroak@jp.fujitsu.com> wrote:
> Hi,
>
> We can see the patch in ML archive or at 'Patchwork' site.
>
> =A0http://patchwork.kernel.org/patch/59519/

That fixes the bug, but shouldn't the error be EXDEV?  It has nothing
to do with permissions.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
