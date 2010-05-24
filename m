From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 04/10] btrfs: Add error check for add_to_page_cache_lru
Date: Mon, 24 May 2010 10:34:19 +0800
Message-ID: <4BF9E5AB.8050506@cn.fujitsu.com>
References: <4BF4E23D.6080405@cn.fujitsu.com> <AANLkTiktY-iDvlEZZGFjarYFUB97SD6DDAkudo02hthL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: miaox@cn.fujitsu.com, Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTiktY-iDvlEZZGFjarYFUB97SD6DDAkudo02hthL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2010 04:43 PM, Mike Fedyk wrote:
> Shouldn't this use a pre-processor label instead of hard coding
> compression sensitivity or readahead tuning?  this way it'll be set in
> one place.
>
>   

All right.

Since Adding a macro may make the whole code harder to read, I add a
"goto" to avoid this kind of hard coding style instead.

Thanks.

-- 
Liubo 


