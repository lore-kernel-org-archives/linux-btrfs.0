From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs lock-up on copying files
Date: Thu, 30 Jun 2011 10:37:51 -0400
Message-ID: <4E0C8A3F.2060202@redhat.com>
References: <20110630123738.6042e563@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630123738.6042e563@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2011 02:37 AM, Roman Mamedov wrote:
> Hello,
> 
> I was copying a set of files to a btrfs filesystem, and the copy process locked-up with the following messages in dmesg.
> 
> The kernel version is 2.6.39.1; the filesystem was recently resized from 3 to 4TB (if that matters).
> 
> It is mounted remotely via AoE but the remote host is up and no errors regarding block devices are registered on it.
> The network is fine and the AoE device with btrfs continues to be accessible normally on the client.
> 

Can you do sysrq+w when this happens?  The caching kthread should still
be able to make progress, which is what we seem to be waiting on.  Does
it eventually unhang and continue on?  Thanks,

Josef
