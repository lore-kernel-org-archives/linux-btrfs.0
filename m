From: Josef Bacik <josef@redhat.com>
Subject: Re: Abysmal Performance
Date: Mon, 20 Jun 2011 20:12:16 -0400
Message-ID: <4DFFE1E0.4040601@redhat.com>
References: <7da312412980843ba746e4e8809060f8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Henning Rohlfs <x+btrfs@xehonk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7da312412980843ba746e4e8809060f8@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2011 05:51 PM, Henning Rohlfs wrote:
> Hello,
>
> I've migrated my system to btrfs (raid1) a few months ago. Since then
> the performance has been pretty bad, but recently it's gotten
> unbearable: a simple sync called while the system is idle can take 20 up
> to 60 seconds. Creating or deleting files often has several seconds
> latency, too.
>
> One curious - but maybe unrelated - observation is that even though I'm
> using a raid1 btrfs setup, the hdds are often being written to
> sequentially. One hard-drive sees some write activity and after it
> subsides, the other drive sees some activity. (See attached
> sequential-writes.txt.)
>

Can you do sysrq+w while this is happening so we can see who is doing 
the writing?  Thanks,

Josef
