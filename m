From: David Nicol <davidnicol@gmail.com>
Subject: Re: the idea for improving the performance of b-tree search
Date: Wed, 13 Oct 2010 10:22:30 -0500
Message-ID: <AANLkTimC=HXPBMxcCL5dx0edN-Z+XzcHpe+G5Bi1hqoX@mail.gmail.com>
References: <4CB57548.7000304@cn.fujitsu.com> <20101013112445.GP22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101013112445.GP22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 13, 2010 at 6:24 AM, Chris Mason <chris.mason@oracle.com> w=
rote:

> 3) Do delayed inode deletion. =C2=A0See above, but change the word in=
sert
> with delete ;)

And the reserved-for-the-future-but-not-used-yet flags field in the
ioctl#21 control structure gets a use: bits to indicate for the
completion of which of the potential delayed things the caller is
waiting.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
