From: Chris Mason <chris.mason@ORACLE.COM>
Subject: Re: Broken btrfs; btrfsck and btrfs-debug-tree core dumps
Date: Wed, 17 Feb 2010 09:11:12 -0500
Message-ID: <20100217141112.GG29430@think>
References: <20100216101543.GA11570@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100216101543.GA11570@alea.gnuu.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 16, 2010 at 11:15:44AM +0100, J=F6rg Sommer wrote:
> Hi,
>=20
> I've an utterly broken btrfs that makes btrfsck and btrfs-debug-tree
> (version 0.19) die with a core dump. Are you interested in this
> filesystem? Unfortunely, it has a size of 1TB and contains the backup=
s of
> our customers. Hence, I can't publish it. How can we come together?

I'm most interested in how it got corrupted.  Was there a specific even=
t
that you think caused this?

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
