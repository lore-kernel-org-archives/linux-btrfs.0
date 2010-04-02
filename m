From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH][BUGFIX] readahead: fix NULL filp dereference
Date: Fri, 2 Apr 2010 15:18:04 +0300
Message-ID: <r2gcc557aab1004020518u5329383eh2bfaaf404fc5d8e2@mail.gmail.com>
References: <cc557aab1003250606g6b4e3e7dgb1adfd46adc89124@mail.gmail.com>
	 <3d0408631003252040r70c54b2fm24d64b819c59c9c@mail.gmail.com>
	 <20100326040114.GA20717@localhost> <20100402072750.GA22952@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
	"Yan, Zheng" <yanzheng@21cn.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100402072750.GA22952@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 2, 2010 at 10:27 AM, Wu Fengguang <fengguang.wu@intel.com> =
wrote:
> The btrfs relocate_file_extent_cluster() calls us with NULL filp:
>
> =C2=A0[ 4005.426805] BUG: unable to handle kernel NULL pointer derefe=
rence at 00000021
> =C2=A0[ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/=
0x3e
>
> CC: Yan Zheng <yanzheng@21cn.com>
> Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>
> Andrew and Greg:
>
> This is an obvious correct bug fix for .34 and .33-stable,
> so I'm resending it directly to you without Kirill's confirmation.

Sorry.

Tested-by: Kirill A. Shutemov <kirill@shutemov.name>

> --- sound-2.6.orig/mm/readahead.c =C2=A0 =C2=A0 =C2=A0 2010-03-26 11:=
51:57.000000000 +0800
> +++ sound-2.6/mm/readahead.c =C2=A0 =C2=A02010-03-26 11:52:11.0000000=
00 +0800
> @@ -502,7 +502,7 @@ void page_cache_sync_readahead(struct ad
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* be dumb */
> - =C2=A0 =C2=A0 =C2=A0 if (filp->f_mode & FMODE_RANDOM) {
> + =C2=A0 =C2=A0 =C2=A0 if (filp && (filp->f_mode & FMODE_RANDOM)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_page_cac=
he_readahead(mapping, filp, offset, req_size);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
