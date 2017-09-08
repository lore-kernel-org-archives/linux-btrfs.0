Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755770AbdIHQ3S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 12:29:18 -0400
Date: Fri, 8 Sep 2017 18:27:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908162748.GR31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 04:25:55PM +0100, Tomasz Kłoczko wrote:
> On 8 September 2017 at 14:10, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> > > How can I test if a subvolume is a snapshot?
> >
> > The inode number is 256 on a btrfs filesystem:
> >
> > if [ stat -f --format=%T $path = btrfs -a stat --format=%i $path = 256 ]; ...
> 
> This oneliner shows how much really basic btrfs tools commands syntax
> is broken by design :(

I could have been more explicit that it's a shell snippet that
implements the check, but the original mail contained some commands so I
expected that replying in shell is appropriate.

> Looking on how so freakishly overcomplicated btrfs command syntax is
> that command like above is completely unintuitive and unreadable
> sometimes I'm really thinking about start rewrite btrfs-progs to make
> btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
> zpool and zdb commands on using which in +90% cases you can guess how
> necessary syntax must look like without looking on man pages.

Do you have examples of overcomplicated commands? The command hierarchy
is similar to what I know about /bin/zfs, sometimes it's deeper that
adds some typing but the shortcuts are allowed so it's IMO not that bad.
Also the features do not map 1:1.

A rewrite gives a lot of space to do the interface right, but effectly
means end of backward compatibility. In the past new commands have been
put anywhere the authors saw fit, now it's the opposite when new
commands do not appear.

Starting a new tool could be useful to gather feedback what commands are
actually desired, though not everything could be implemented in progs.
