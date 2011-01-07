From: cwillu <cwillu@cwillu.com>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Fri, 7 Jan 2011 14:18:47 -0600
Message-ID: <AANLkTimpci_RHZ2p82DfKCP3n1DBtRVVj+yQzC7v4EWb@mail.gmail.com>
References: <4D276899.7000702@wpkg.org>
	<AANLkTik3GZVTwco+4PNFriB0+t_U=e+dH0UOgK_3P9D5@mail.gmail.com>
	<4D27711B.4090606@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D27711B.4090606@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 2:01 PM, Tomasz Chmielewski <mangoo@wpkg.org> wr=
ote:
> On 07.01.2011 20:46, cwillu wrote:
>
>>> However, I don't see the tool when I clone the latest git - am I mi=
ssing
>>> something?
>>
>> It's not built by the makefile by default; =A0"make btrfs-select-sup=
er"
>> as stated above will make it.
>
> $ grep select Makefile
> $ grep super Makefile
> $ grep -r select-super *
> $ grep -r selects-super *
>
>
> I used:
>
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unsta=
ble.git
> next

You checked out the master branch into a folder called next.  "-b
next" is the option to checkout a specific branch.  From your existing
checkout, "git checkout -t origin/next" will switch to that branch.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
