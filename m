From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH 02/12] Btrfs: Kill allocate_wait in space_info
Date: Mon, 19 Apr 2010 22:46:12 +0800
Message-ID: <s2o3d0408631004190746wcc55e7bdp572e9cce8a36fcd6@mail.gmail.com>
References: <4BCC3458.5030600@oracle.com>
	 <20100419135713.GA2352@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100419135713.GA2352@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 19, 2010 at 9:57 PM, Josef Bacik <josef@redhat.com> wrote:
> The purpose of maybe_allocate_chunk was that there is no way to know =
if some
> other CPU is currently trying to allocate a chunk for the given space=
 info. =A0We
> could have two cpu's come inot do_chunk_alloc at relatively the same =
time and
> end up allocating twice the amount of space, which is why I did the w=
aitqueue
> thing. =A0It seems like this is still a possibility with your patch. =
=A0Thanks,
>
This is impossible because the very first thing do_chunk_alloc does is
lock the chunk_mutex.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
