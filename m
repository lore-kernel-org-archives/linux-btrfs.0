Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:49170 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbdGVBNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 21:13:23 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53918)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dYiyu-0001AZ-Nz
        for linux-btrfs@vger.kernel.org; Sat, 22 Jul 2017 02:13:20 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dYiyo-0001UK-Kb
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jul 2017 02:13:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22898.42666.281306.537876@tree.ty.sabi.co.uk>
Date: Sat, 22 Jul 2017 02:13:14 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel btrfs file system wedged -- is it toast?
In-Reply-To: <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
        <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
        <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
        <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
        <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk>
        <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] announce loudly and clearly to any potential users, in
> multiple places (perhaps a key announcement in a few places
> and links to that announcement from many places,

https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow

> ... DO expect to first have to learn, the hard way, of
> ... whatever special mitigations might apply in ones
> ... particular circumstances, before considering deploying
> ... btrfs into a production environment where this, or other
> ... (what other?) surprising limitations of btrfs may apply.

In computer jargon that is called "being a system engineer".

> All the prominent places that respond to the question of
> whether btrfs is ready for production use (spanning several
> years now) should if possible display this warning.

https://btrfs.wiki.kernel.org/index.php/Status
  "The table below aims to serve as an overview for the stability
  status of the features BTRFS supports. While a feature may be
  functionally safe and reliable, it does not necessarily mean
  that its useful, for example in meeting your performance
  expectations for your specific workload."

> [ ... ] Back in my day, such a performance bug would have made
> the software containing it unreleasable, _especially_ in
> software such as a major file system that is expected to
> provide reliable service, where "reliable" means both
> preserving data integrity and doing so within an order of
> magnitude of a reasonably expected time.

For the past several decades, since perhaps the Manchester MARK I
(or the ZUSE probably), it has been known to "system engineers"
and "programmers" that most features of "hardware" and "software"
have very anisotropic performance envelopes, both as to speed and
usability and reliability, and not all potentially syntactically
valid combinations of features are equally robust and excellent
under every possible workload, and indeed very few are, and it is
part of "being a system engineer" or "being a programmer" to
develop insight and experience, leading to knowledge ideally, as
to what combinations work well and which work badly.

Considering somewhat imprecise car analogies, jet engines on cars
tend not to be wholly desirable, even if syntactically valid, and
using cars to plow fields does not necessarily yield the highest
productivity, even if also syntactically valid.

General introduction about anisotropy and performance:

  http://www.sabi.co.uk/blog/15-two.html?151023#151023

In storage system and filesystems "system engineers" often have
to confront a large number of pathological cases of anisotropy,
some examples I can find quickly in my links:

  http://www.sabi.co.uk/blog/1005May.html?100520#100520
  http://www.sabi.co.uk/blog/16-one.html?160322#160322
  http://www.sabi.co.uk/blog/15-one.html?150203#150203
  http://www.sabi.co.uk/blog/12-fou.html?121218#121218
  http://www.sabi.co.uk/blog/0802feb.html?080210#080210
  http://www.sabi.co.uk/blog/0802feb.html?080216#080216

I try to keep lists of "known pathologies" of various types here:

  http://www.sabi.co.uk/Notes/linuxStor.html
  http://www.sabi.co.uk/Notes/linuxFS.html#fsHints

Even "legendary" 'ext3' has/had pathological (and common) cases:

  https://lwn.net/Articles/328370/
  https://lwn.net/Articles/328363/
  https://bugzilla.kernel.org/show_bug.cgi?id=12309
  https://news.ycombinator.com/item?id=7376750
  https://news.ycombinator.com/item?id=7377315

  https://lkml.org/lkml/2009/4/6/331
    the difference between the occasional 5+ second pause and the
    occasional 10+ second pause wasn't really all that
    interesting. They were both unusuable, and both made me kill
    the background writer almost immediately

Wisely L Torvalds writes:

  https://lkml.org/lkml/2010/11/10/233
    ext3 [f]sync sucks. We know. All filesystems suck.
    They just tend to do it in different dimensions.
