From: Chris Mason <chris.mason@oracle.com>
Subject: Re: dereferencing freed variable in "add basic DIO read/write
 support"
Date: Fri, 28 May 2010 08:54:00 -0400
Message-ID: <20100528125400.GI3389@think>
References: <20100528103359.GW22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100528103359.GW22515@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 28, 2010 at 12:33:59PM +0200, Dan Carpenter wrote:
> Hello,
> 
> Smatch complains about a possible freed pointer deref introduced by:
> 4b46fce2334 "Btrfs: add basic DIO read/write support".  Could you take a
> look?

Thanks Dan, I'll patch this up.

-chris
