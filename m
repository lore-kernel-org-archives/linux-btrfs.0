From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/3] btrfs: Update directory link count correctly while
 creation
Date: Sat, 23 Jan 2010 19:30:18 -0500
Message-ID: <20100124003018.GO23006@think>
References: <1264279089-14913-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1264279089-14913-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264279089-14913-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2010 at 02:08:08AM +0530, Aneesh Kumar K.V wrote:
> This patch make sure we update directory link count correctly
> during mkdir and rename

Directories always have a link count of 1, this is the widely accepted
way of saying: we don't count subdirs via the link count.

-chris
