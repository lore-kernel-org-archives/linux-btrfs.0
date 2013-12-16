Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57011 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735Ab3LPSQ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 13:16:57 -0500
From: Chris Mason <clm@fb.com>
To: "hkbakke@gmail.com" <hkbakke@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Blocket for more than 120 seconds
Date: Mon, 16 Dec 2013 18:16:53 +0000
Message-ID: <1387217823.18897.14.camel@ret.masoncoding.com>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	 <46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	 <CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	 <337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	 <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	 <840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	 <CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	 <1387207097.18897.6.camel@ret.masoncoding.com>
	 <CAD_cGvGjkqPXp8guiBR4UsGCQti6rFgRN4Qg+fXLgfE-WkTtEg@mail.gmail.com>
In-Reply-To: <CAD_cGvGjkqPXp8guiBR4UsGCQti6rFgRN4Qg+fXLgfE-WkTtEg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-16 at 17:32 +0100, Hans-Kristian Bakke wrote:
> Ok, I guess the essence have been lost in the meta discussion.
> 
> Basically I get blocking for more than 120 seconds during these workloads:
> - defragmenting several large fragmentet files in succession (leaving
> time for btrfs to finish writing each file). This have *always*
> happened in my array, even when it just consisted of 4x4TB drives.
> or
> - rsyncing *to* the btrfs array from another internal array (rsync -a
> <source_on_ext4_mdadm_array> <dest_on_btrfs_raid10_array>)
> 

Ok, and do you have autodefrag enabled on the btrfs FS you are copying
to?  Also, how much ram do you have?

-chris

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
