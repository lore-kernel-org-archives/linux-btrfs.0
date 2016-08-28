Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35483 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcH1UTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 16:19:12 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.84_2)
        (envelope-from <kilobyte@angband.pl>)
        id 1be6Xs-0005Zh-Nj
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 22:19:08 +0200
Date: Sun, 28 Aug 2016 22:19:08 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: does btrfs-receive use/compare the checksums from the btrfs-send
 side?
Message-ID: <20160828201908.GA19993@angband.pl>
References: <1472355960.16760.9.camel@scientia.net>
 <CAJCQCtQ9fv9ewj_E7W69d9UR1YzdE87ZSPrSWmjJJhN3cwtb1g@mail.gmail.com>
 <1472406642.7253.1.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472406642.7253.1.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 28, 2016 at 07:50:42PM +0200, Christoph Anton Mitterer wrote:
> On Sun, 2016-08-28 at 11:35 -0600, Chris Murphy wrote:
> > I don't see evidence of them in the btrfs send file, so I don't think
> > csums are in the stream.
> 
> hmm... isn't that kinda unfortunate not to make use of the information
> that's already there?

Transports over which you're likely to send a filesystem stream already
protect against corruption.

It'd still be nice to have something for those which don't, of course.

-- 
An imaginary friend squared is a real enemy.
