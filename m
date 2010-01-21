From: Liuwenyi <qingshenlwy@gmail.com>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual address
 00000008
Date: Thu, 21 Jan 2010 18:53:56 +0800
Message-ID: <4B583244.40405@gmail.com>
References: <20100121060710.GA5301@cumulus> <20100121083849.GA7790@mother.pipebreaker.pl> <20100121085736.GB20543@cumulus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100121085736.GB20543@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

=E4=BA=8E 2010-1-21 16:57, Sander =E5=86=99=E9=81=93:
> Hello Tomasz,
>
> Tomasz Torcz wrote (ao):
>   =20
>> On Thu, Jan 21, 2010 at 07:07:10AM +0100, Sander wrote:
>>     =20
>>> [26678.568532] [<c026c294>] (btrfs_get_acl+0x60/0x250) from [<c026c=
494>] (btrfs_xattr_get_acl+0x10/0x70)
>>> [26678.577802] [<c026c494>] (btrfs_xattr_get_acl+0x10/0x70) from [<=
c019bb20>] (generic_getxattr+0x78/0x7c)
>>> [26678.587243] [<c019bb20>] (generic_getxattr+0x78/0x7c) from [<c01=
9c01c>] (vfs_getxattr+0x58/0x5c)
>>> [26678.596074] [<c019c01c>] (vfs_getxattr+0x58/0x5c) from [<c019c0c=
4>] (getxattr+0xa4/0x11c)
>>> [26678.604298] [<c019c0c4>] (getxattr+0xa4/0x11c) from [<c019c220>]=
 (sys_getxattr+0x44/0x58)
>>> [26678.612525] [<c019c220>] (sys_getxattr+0x44/0x58) from [<c0122e2=
0>] (ret_fast_syscall+0x0/0x28)
>>>       =20
>>    Although your oops is in btrfs_get_acl(), you may need similar fi=
x
>> as done for btrfs_set_acl() in this commit:
>>
>>    http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.=
git;a=3Dcommitdiff;h=3Da9cc71a60c29a09174bee2fcef8f924c529fd4b7
>>     =20
> Thanks, that makes sense.
>
> Unfortunately I'm no kernel hacker so I can't provide a patch. I'm mo=
re
> than happy to test patches of course.
>
> 	With kind regards, Sander
>
>   =20

I remember that the lastest git pull had fixed this bug, it was Chris=20
Mason's patch.

--=20
Best Regards,
Liuwenyi

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
