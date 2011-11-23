From: Blair Zajac <blair@orcaware.com>
Subject: Re: fsck with "err is 1"
Date: Wed, 23 Nov 2011 08:48:26 -0800
Message-ID: <5ED58F1E-368C-414F-BA60-9C8E240338F6@orcaware.com>
References: <EB38FBF9-9284-4902-ABC6-B6FB6B6D4E50@orcaware.com> <CAG1y0sc3w1wWdTYNLgTFEtmF3x+sooZX6dpjJWMoKxV==Bce4A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sc3w1wWdTYNLgTFEtmF3x+sooZX6dpjJWMoKxV==Bce4A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 22, 2011, at 10:02 PM, Fajar A. Nugraha wrote:

> On Wed, Nov 23, 2011 at 12:33 PM, Blair Zajac <blair@orcaware.com> wrote:
>> Hello,
>> 
>> I'm trying btrfs in a VirtualBox VM running Ubuntu 11.10 with kernel 3.0.0.  Running fsck I get a message with "err is 1".
> 
>> Does this mean there's an error?  Is err either always 0 or 1, or does err increment beyond 1?
> 
> I can't answer that, but I can tell you that fsck for btrfs right now
> is almost useless. It can't fix anyting.

Thank you, I've read that fsck doesn't fix anything.  I was curious if doing the scrub would resolve it.

Blair

