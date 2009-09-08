From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] don't OOPs when we are not raid56
Date: Tue, 08 Sep 2009 10:15:29 +0100
Message-ID: <1252401329.4483.579.camel@macbook.infradead.org>
References: <1249553833.568.23.camel@macbook.infradead.org>
	 <774E55AE-1639-4537-B001-E8F96311F4CD@karlsbakk.net>
	 <1249658554.568.214.camel@macbook.infradead.org>  <4A9E9E00.5080608@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A9E9E00.5080608@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-09-02 at 12:32 -0400, jim owens wrote:
> @@ -2895,7 +2895,7 @@ again:
>                 multi->num_stripes = num_stripes;
>                 multi->max_errors = max_errors;
>         }
> -       if (raid_map_ret) {
> +       if (raid_map) {
>                 sort_parity_stripes(multi, raid_map);
>                 *raid_map_ret = raid_map;
>         }

Applied (manually, because I think your mail was whitespace-damaged).
Thanks.

Chris, where do we stand with getting this merged? You were going to
sort out the upper layers to handle the minimum write size, weren't you?

I'm also going to do RAID50/60 support, and with hpa's help I'll extend
it to do RAID7/70 too -- but you're not waiting for that, are you?
 
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

