Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36588 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbcFMCFt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 22:05:49 -0400
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
To: Andrew Armenia <andrew@asquaredlabs.com>, linux-btrfs@vger.kernel.org
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9d614f8f-f4c6-ac68-bfaa-abc29dd6b1d5@oracle.com>
Date: Mon, 13 Jun 2016 10:06:24 +0800
MIME-Version: 1.0
In-Reply-To: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/2016 09:50 AM, Andrew Armenia wrote:
> This patch adds mount option 'chunk_width_limit=X', which when set forces
> the chunk allocator to use only up to X devices when allocating a chunk.
> This may help reduce the seek penalties seen in filesystems with large
> numbers of devices.

Have you reviewed implementations like device allocation grouping?
Some info is in the btrfs project ideas..

https://btrfs.wiki.kernel.org/index.php/Project_ideas
  Chunk allocation groups
  Limits on number of stripes (stripe width)
  Linear chunk allocation mode

(Device allocation grouping is important for enterprise storage solutions).

Thanks, Anand
