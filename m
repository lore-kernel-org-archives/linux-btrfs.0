Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:54309 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdKDRZ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 13:25:26 -0400
Received: by mail-ot0-f172.google.com with SMTP id 96so5200244otw.11
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Nov 2017 10:25:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com> <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 4 Nov 2017 11:25:24 -0600
Message-ID: <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
Subject: Re: Problem with file system
To: Dave <davestechshop@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 4, 2017 at 1:26 AM, Dave <davestechshop@gmail.com> wrote:
> On Mon, Oct 30, 2017 at 5:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> That is not a general purpose file system. It's a file system for admins who understand where the bodies are buried.
>
> I'm not sure I understand your comment...
>
> Are you saying BTRFS is not a general purpose file system?

I'm suggesting that any file system that burdens the user with more
knowledge to stay out of trouble than the widely considered general
purpose file systems of the day, is not a general purpose file system.

And yes, I'm suggesting that Btrfs is at risk of being neither general
purpose, and not meeting its design goals as stated in Btrfs
documentation. It is not easy to admin *when things go wrong*. It's
great before then. It's a butt ton easier to resize, replace devices,
take snapshots, and so on. But when it comes to fixing it when it goes
wrong? It is a goddamn Choose Your Own Adventure book. It's way, way
more complicated than any other file system I'm aware of.


> If btrfs isn't able to serve as a general purpose file system for
> Linux going forward, which file system(s) would you suggest can fill
> that role? (I can't think of any that are clearly all-around better
> than btrfs now, or that will be in the next few years.)

ext4 and XFS are clearly the file systems to beat. They almost always
recover from crashes with just a normal journal replay at mount time,
file system repair is not often needed. When it is needed, it usually
works, and there is just the one option to repair and go with it.
Btrfs has piles of repair options, mount time options, btrfs check has
options, btrfs rescue has options, it's a bit nutty honestly. And
there's zero guidance in the available docs what order to try things
in, not least of which some of these repair tools are still considered
dangerous at least in the man page text, and the order depends on the
failure. The user is burdened with way too much.

Even as much as I know about Btrfs having used it since 2008 and my
list activity, I routinely have WTF moments when people post problems,
what order to try to get things going again. Easy to admin? Yeah for
the most part. But stability is still a problem, and it's coming up on
a 10 year anniversary soon.

If I were equally familiar with ZFS on Linux as I am with Btrfs, I'd
use ZoL hands down. But I'm not, I'm much more familiar with Btrfs and
where the bodies are buried, so I continue to use Btrfs.



-- 
Chris Murphy
