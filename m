Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:54090 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755073AbdKGHCP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 02:02:15 -0500
Received: by mail-wm0-f51.google.com with SMTP id r196so1512146wmf.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 23:02:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <CAH=dxU4MOWGZ0JSZ-ZV004p5EnH_aOnZ7XEo2rSOmbXJZJmwBA@mail.gmail.com> <CAJCQCtTOefBfRpfb0h1H6SQxzGd9j-7ZSM07iA37xhy3+Lm=fw@mail.gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Tue, 7 Nov 2017 02:01:53 -0500
Message-ID: <CAH=dxU61J94HCnr+UUokBsxqNMjKQBdz8xE2WNbWAHOtKP4w0w@mail.gmail.com>
Subject: Re: Problem with file system
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 4, 2017 at 1:25 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Nov 4, 2017 at 1:26 AM, Dave <davestechshop@gmail.com> wrote:
> > On Mon, Oct 30, 2017 at 5:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
> >>
> >> That is not a general purpose file system. It's a file system for admins who understand where the bodies are buried.
> >
> > I'm not sure I understand your comment...
> >
> > Are you saying BTRFS is not a general purpose file system?
>
> I'm suggesting that any file system that burdens the user with more
> knowledge to stay out of trouble than the widely considered general
> purpose file systems of the day, is not a general purpose file system.
>
> And yes, I'm suggesting that Btrfs is at risk of being neither general
> purpose, and not meeting its design goals as stated in Btrfs
> documentation. It is not easy to admin *when things go wrong*. It's
> great before then. It's a butt ton easier to resize, replace devices,
> take snapshots, and so on. But when it comes to fixing it when it goes
> wrong? It is a goddamn Choose Your Own Adventure book. It's way, way
> more complicated than any other file system I'm aware of.

It sounds like a large part of that could be addressed with better
documentation. I know that documentation such as what you are
suggesting would be really valuable to me!

> > If btrfs isn't able to serve as a general purpose file system for
> > Linux going forward, which file system(s) would you suggest can fill
> > that role? (I can't think of any that are clearly all-around better
> > than btrfs now, or that will be in the next few years.)
>
> ext4 and XFS are clearly the file systems to beat. They almost always
> recover from crashes with just a normal journal replay at mount time,
> file system repair is not often needed. When it is needed, it usually
> works, and there is just the one option to repair and go with it.
> Btrfs has piles of repair options, mount time options, btrfs check has
> options, btrfs rescue has options, it's a bit nutty honestly. And
> there's zero guidance in the available docs what order to try things
> in, not least of which some of these repair tools are still considered
> dangerous at least in the man page text, and the order depends on the
> failure. The user is burdened with way too much.

Neither one of those file systems offers snapshots. (And when I
compared LVM snapshots vs BTRFS snapshots, I got the impression BTRFS
is the clear winner.)

Snapshots and volumes have a lot of value to me and I would not enjoy
going back to a file system without those features.

> Even as much as I know about Btrfs having used it since 2008 and my
> list activity, I routinely have WTF moments when people post problems,
> what order to try to get things going again. Easy to admin? Yeah for
> the most part. But stability is still a problem, and it's coming up on
> a 10 year anniversary soon.
>
> If I were equally familiar with ZFS on Linux as I am with Btrfs, I'd
> use ZoL hands down.

Might it be the case that if you were equally familiar with ZFS, you
would become aware of more of its pitfalls? And that greater knowledge
could always lead to a different decision (such as favoring BTRFS)..
In my experience the grass is always greener when I am less familiar
with the field.
