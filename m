From: cwillu <cwillu@cwillu.com>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Fri, 18 Mar 2011 10:25:49 -0600
Message-ID: <AANLkTimx2BrXuSpKzcjV3EC3MO0YFAWFszg5hJDhKjgJ@mail.gmail.com>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net>
	<4D5203E5.7000902@cn.fujitsu.com>
	<4D822FB6.7020901@gmx.net>
	<1300458780-sup-7019@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Arne Jansen <sensille@gmx.net>, miaox <miaox@cn.fujitsu.com>,
	josef <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300458780-sup-7019@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2011 at 8:40 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> I think that filling all the devices fully is more important than the
> initial spread. =A0Miao is correct that the administrator will
> probably complain if all the devices aren't used for the initial stri=
pes.
> But, over the long term the admin does expect that if he gives us 350=
GB
> of drives in any config, we find try our best to use all 350GB. =A0I'=
d
> rather meet that expectation than worry about initial performance in =
a
> mixed drive setup.

There's no reason why you can't get optimal distribution from the
start while still having complete usage.  And it's preferable to do
that, so that you get optimal distribution even as you add capacity;
otherwise front-loading the worst cases makes sure you run into them,
even if the administrator would have added more disks before you
needed to handle them.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
