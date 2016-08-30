Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:50117 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbcH3ROm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 13:14:42 -0400
Date: Tue, 30 Aug 2016 13:14:39 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
Subject: Re: does btrfs-receive use/compare the checksums from the btrfs-send
 side?
Message-ID: <20160830171439.GA1529@coach.home>
References: <1472355960.16760.9.camel@scientia.net>
 <CAJCQCtQ9fv9ewj_E7W69d9UR1YzdE87ZSPrSWmjJJhN3cwtb1g@mail.gmail.com>
 <1472406642.7253.1.camel@scientia.net>
 <20160828201908.GA19993@angband.pl>
 <1472415932.7253.9.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472415932.7253.9.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 28, 2016 at 10:25:32PM +0200, Christoph Anton Mitterer wrote:
> On Sun, 2016-08-28 at 22:19 +0200, Adam Borowski wrote:
> > Transports over which you're likely to send a filesystem stream
> > already
> > protect against corruption.
> Well... in some cases,... but not always... just consider a plain old
> netcat...

Netcat uses TCP by default, so there is error correction and a
guaranteed-correct stream transfer there.

--Sean
