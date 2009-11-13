From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS: unreachable code found
Date: Fri, 13 Nov 2009 16:36:02 -0500
Message-ID: <20091113213602.GF11332@think>
References: <4AFD35DB.6050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zheng.yan@oracle.com, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AFD35DB.6050604@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2009 at 11:32:59AM +0100, Jiri Slaby wrote:
> Hi,
> 
> Stanse found unreachable code in btrfs_insert_some_items below (don't
> look at the line numbers, they are on preprocessed code). I would fix
> that if I knew how.

It turns out the entire function isn't used anymore.  We can safely
delete it.

-chris
