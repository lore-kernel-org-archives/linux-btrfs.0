From: Josef Bacik <josef@redhat.com>
Subject: Re: 2.6.29-rc2 oops and assertion failure...
Date: Thu, 07 Apr 2011 12:23:14 -0400
Message-ID: <4D9DE4F2.1050909@redhat.com>
References: <BANLkTikJJFqEs0F_wPdTinct0k_4uLh1hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikJJFqEs0F_wPdTinct0k_4uLh1hQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2011 03:21 AM, Daniel J Blueman wrote:
> When running a practical stress-test on 2.6.29-rc2 trying to reproduce
> an older (extent refcounting) issue, I am consistently able to hit an
> oops [1] and an assertion failure [2].
>

Sorry about that, please apply the patch I just sent this morning

[PATCH] Btrfs: deal with the case that we run out of space in the cache

Thanks,

Josef
