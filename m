From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel oops when trying to compile kernel on btrfs part
Date: Mon, 23 Nov 2009 20:23:53 -0500
Message-ID: <20091124012353.GE24068@think>
References: <3fa5c0870911190516q227a65cau20716cc3b425a5f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: pragnesh radadia <pragnesh.radadia@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3fa5c0870911190516q227a65cau20716cc3b425a5f1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2009 at 06:46:58PM +0530, pragnesh radadia wrote:
> I got following kernel oops when trying to compile kernel on btrfs
> partation on my laptop.

This is probably running out of space.  Could you please send along the
lines around line number 735 in fs/btrfs/inode.c?

-chris
