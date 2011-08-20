From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] BTRFS: Free inode mutex on lseek error
Date: Sat, 20 Aug 2011 08:08:25 -0400
Message-ID: <4E4FA3B9.6000203@redhat.com>
References: <1313798858-10938-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>, chris.mason@oracle.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1313798858-10938-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2011 08:07 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Introduced with b26751575a9aa55fd6dbf3febde3ff06dfadc44f
> 

This has already been fixed by

9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

Thanks,

Josef
