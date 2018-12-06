Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CB2C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 20:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED9732064D
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 20:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED9732064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lip6.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbeLFUPv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 15:15:51 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:35565
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbeLFUPv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 15:15:51 -0500
X-IronPort-AV: E=Sophos;i="5.56,323,1539640800"; 
   d="scan'208";a="288191127"
Received: from abo-91-111-68.mrs.modulonet.fr (HELO hadrien) ([85.68.111.91])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2018 21:15:48 +0100
Date:   Thu, 6 Dec 2018 21:15:47 +0100 (CET)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Johannes Thumshirn <jthumshirn@suse.de>
cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [RFC PATCH 3/3] coccinelle: api: add offset_in_page.cocci
In-Reply-To: <e5f96762-d85f-72c0-8c16-696c2f3ae896@suse.de>
Message-ID: <alpine.DEB.2.21.1812062105180.2464@hadrien>
References: <20181205142305.15361-1-jthumshirn@suse.de> <20181205142305.15361-4-jthumshirn@suse.de> <alpine.DEB.2.20.1812051542530.3726@hadrien> <e5f96762-d85f-72c0-8c16-696c2f3ae896@suse.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On Thu, 6 Dec 2018, Johannes Thumshirn wrote:

> On 05/12/2018 15:46, Julia Lawall wrote:
> [...]
> >> +@r_patch depends on !context && patch && !org && !report@
> >> +expression E;
> >> +type T;
> >> +@@
> >> +
> >> +(
> >> +- E & ~PAGE_MASK
> >> ++ offset_in_page(E)
> >> +|
> >> +- E & (PAGE_SIZE - 1)
> >> ++ offset_in_page(E)
> >
> > The two lines above should be subsumed by the two lines below.  When there
> > is a type metavariable that has no other dependencies, an isomorphism will
> > consider that it is either present or absent.
>
> Oh OK, I'm sorry I'm not really into cocinelle so I guessed it might
> take some iterations.
>
> Do you have an example for this?

Expanation 1:

Coccinelle as a file standard.iso that shows the isomorphisms (rewrite
rules) that may be applied to semantic patches.  One of the rules is:

Expression
@ not_ptr1 @
expression *X;
@@
 !X => X == NULL

So if you have a pointer typed expression X and you write a transformation
on !X, it will also apply to occurrences of X == NULL in the source code.
In this way, you don't have to write so many variants.

Likewise there is an isomorphism:

Expression
@ drop_cast @
expression E;
pure type T;
@@

 (T)E => E

That is, if you have a semantic patch with (T)X, then it will also apply
to code that matches just X, without the cast.  The word pure means that
this isomorphism metavariable has to match a semantic patch term that is a
metavariable and this metavariable can't be used elsewhere.  If you wrote

- (char)x

Then you would probably not want that to apply without the (char) cast.
But if you have just

- (T)x

for some randome unbound metavariable T, then perhaps you don't case about
the cast to T.  If you actually do, then you can put disable drop_cast in
the header of your rule.



Explanation 2:

To see what your semantic patch is really doing, you can run

spatch --parse-cocci sp.cocci

Here is what I get for your patch rule, with some annotations added:

@@
expression E;
type T;
@@


(
-E
  >>> offset_in_page(E)
 -& -~-PAGE_MASK
|
-~
  >>> offset_in_page(E)
-PAGE_MASK -& -E
|

// the following come from
// - E & (PAGE_SIZE - 1)
// + offset_in_page(E)

-E                           // 1
  >>> offset_in_page(E)
 -& -(-PAGE_SIZE -- -1-)
|
-E                           // 2
  >>> offset_in_page(E)
 -& -PAGE_SIZE -- -1
|
-(                           // 3
    >>> offset_in_page(E)
  -PAGE_SIZE -- -1-) -& -E
|
-PAGE_SIZE                   // 4
  >>> offset_in_page(E)
 -- -1 -& -E
|

// the following come from:
// - E & ((T)PAGE_SIZE - 1)
// + offset_in_page(E)

-E
  >>> offset_in_page(E)
 -& -(-(-T -)-PAGE_SIZE -- -1-)
|
-E                           // same as 1
  >>> offset_in_page(E)
 -& -(-PAGE_SIZE -- -1-)
|
-E
  >>> offset_in_page(E)
 -& -(-T -)-PAGE_SIZE -- -1
|
-E                           // same as 2
  >>> offset_in_page(E)
 -& -PAGE_SIZE -- -1
|
-(
    >>> offset_in_page(E)
  -(-T -)-PAGE_SIZE -- -1-) -& -E
|
-(                           // same as 3
    >>> offset_in_page(E)
  -PAGE_SIZE -- -1-) -& -E
|
-(
    >>> offset_in_page(E)
  -T -)-PAGE_SIZE -- -1 -& -E
|
-PAGE_SIZE                   // same as 4
  >>> offset_in_page(E)
 -- -1 -& -E
)

So all the transformation generated by

- E & (PAGE_SIZE - 1)
+ offset_in_page(E)

are also generated by

- E & ((T)PAGE_SIZE - 1)
+ offset_in_page(E)

I hope that is helpful.

julia
