Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51865 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbdILL4j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:56:39 -0400
Date: Tue, 12 Sep 2017 13:55:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Alberto Bursi <alberto.bursi@outlook.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dead links in wiki about why not using lz4
Message-ID: <20170912115509.GK14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <AM3PR08MB0642E6253ECA0099AEC6E06A92690@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <CAGqmi770dyjmX_0JjqNvVn_g+Pd+XhDxssRz3fxrtD2b2YWfRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi770dyjmX_0JjqNvVn_g+Pd+XhDxssRz3fxrtD2b2YWfRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 12:33:21PM +0300, Timofey Titovets wrote:
> 2017-09-12 12:19 GMT+03:00 Alberto Bursi <alberto.bursi@outlook.it>:
> > Since zstd was added in btrfs there are people wondering why not lz4 too.
> >
> > The wiki paragraph [1] cites a couple dead links as explanations on why
> > it's not a good idea to have lz4 in btrfs.
> >
> > I think it would be nice if someone can write that information back in
> > the wiki, or for the very least write them in a mailing list message
> > that can be linked there.
> >
> >
> > -Alberto
> >
> >
> > 1. https://btrfs.wiki.kernel.org/index.php/FAQ#Will_btrfs_support_LZ4.3F
> >
> 
> AFAIK Problem description:
> https://marc.info/?l=linux-btrfs&m=140181084426296&w=2

Yeah that's the response. And the reason for not adding lz4 still
stands, there's no measurable benefit over lzo under the implementation
constraints we have in btrfs now.
