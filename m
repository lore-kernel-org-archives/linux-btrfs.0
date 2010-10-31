From: Christian <gmane.20.ceed@spamgourmet.com>
Subject: Re: btrfs and apt package manager in ubuntu
Date: Sun, 31 Oct 2010 11:21:36 -0500
Message-ID: <1288542096.16108.34.camel@ceedasus>
References: <1288531046.3486.2.camel@home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288531046.3486.2.camel@home>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-10-31 at 16:17 +0300, Abdullah Ansari wrote:
> it's very slow in installtion with apt in ubuntu

I'm seeing the same thing. When installing using apt the disk grinds
"forever" before the installation completes. I have two identical
laptops running Linux Mint 10 (rc) with similar disk layout except that
one has two btrfs partitions while the other only has ext4. The one with
btrfs takes at least 10 times longer to install updates on than the ext4
one.

-- 
//Christian


