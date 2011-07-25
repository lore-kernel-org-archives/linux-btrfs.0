From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH v6 2/8] btrfs scrub: added unverified_errors
Date: Mon, 25 Jul 2011 09:38:31 +0200
Message-ID: <4E2D1D77.9030601@jan-o-sch.net>
References: <cover.1311332399.git.list.btrfs@jan-o-sch.net> <a0d21041d2cdeb4960e800fa015c616cd9853790.1311332399.git.list.btrfs@jan-o-sch.net> <4E2D173B.4040302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2D173B.4040302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.07.2011 09:11, Li Zefan wrote:
>> +	spin_lock(&sdev->stat_lock);
>> +	++sdev->stat.read_errors;
>> +	spin_unlock(&sdev->stat_lock);
> 
> Normally we write "i++" instead of "++i" if the return value is
> ignored.

Checkpatch didn't say so, it can't be too wrong. For the next time I can
do it the other way round if it makes people happier.

-Jan
