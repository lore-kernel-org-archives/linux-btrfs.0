From: David Nicol <davidnicol@gmail.com>
Subject: Re: Mark btrfsctl deprecated
Date: Mon, 25 Oct 2010 16:29:32 -0500
Message-ID: <AANLkTimiuTM02Dnue_3NdC+uLbCMP9hEjfrp_4efFbGe@mail.gmail.com>
References: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost>
List-ID: <linux-btrfs.vger.kernel.org>

I am certainly not in a position to answer for Chris Mason, but I am
happy to share my response to the question, coming from a perspective
of being somewhat obsessive about not breaking back-compat.

Let's not. As I am certainly within the "lot of people" in question,
having just done exactly that, I found the two programs -- with very
different styles -- to not be much of a block, and providing two
examples instead of one of code that invokes an ioctl seems fine.

Ideally, everyone who needs to use an ioctl will simply write and
compile a C program that does what they need -- ha ha.

I see no reason to break legacy code (such as it is) that uses
btrfsctl instead of btrfs for a user-space tool to invoke ioctls.
Calling the tool "btrfs" is actually a little confusing.



On Fri, Oct 22, 2010 at 7:02 AM, Goffredo Baroncelli
<kreijack@libero.it> <kreijack@libero.it> wrote:
> Hi Chris,
>
> what do you think about marking deprecate the "btrfsctl" program ?
>
> A lot of people make patch involving both btrfs command and btrfsctl command,
> spending a lot of effort.
>
> Initially we can put a warning in the btrfctl command which suggest to use the
> btrfs command. and after XX month (six ?) we could remouve the command at all.
> The same for the other utilities like btrfs-show, btrfs-vol....
>
> Of course this is applicable if there is no evidence of regression of btrfs vs
> btrfsctl.
>
> Regards
> G.Baroncelli
