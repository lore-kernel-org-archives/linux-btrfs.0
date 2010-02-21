From: James Cloos <cloos@jhcloos.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Sat, 20 Feb 2010 21:12:08 -0500
Message-ID: <m31vgfbalr.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	<21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	<m3wry8nbyl.fsf@lugabout.jhcloos.org>
	<21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
	(Dave Airlie's message of "Sat, 20 Feb 2010 08:03:57 +1000")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Dave" == Dave Airlie <airlied@gmail.com> writes:

Dave> I've just sent a pull req to Linus
Dave> http://bugzilla.kernel.org/show_bug.cgi?id=15328
Dave> this
Dave> http://bugzilla.kernel.org/attachment.cgi?id=25107
Dave> patch.

That patch does indeed fix the regression here.

Thanks!

It looks like my report is a dup of bug 15328.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
