From: Dennis Bergmann <d.bergmann@ftml.net>
Subject: Re: Damaged super block / fs root
Date: Mon, 30 May 2011 18:47:01 +0200
Message-ID: <4DE3CA05.6020709@ftml.net>
References: <4DE3BEFA.7080106@ftml.net> <20110530161216.GA8002@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110530161216.GA8002@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 30.05.2011 18:12, Hugo Mills wrote:
>     You can check whether it's likely to be of use by running "btrfsck
> -s 1" on your filesystem. If it passes OK, then btrfs-select-super
> should be useful.
>
>     Hugo.

Didn't work, unfortunately.

My btrfsck version is v0.19-35-g1b444cd-dirty and running
"btrfsck -s 1 /dev/sda5" quits with the following message:

using SB copy 1, bytenr 67108864
No valid Btrfs found on /dev/sda5







