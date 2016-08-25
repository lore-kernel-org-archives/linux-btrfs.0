Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35101 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756082AbcHYTuf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 15:50:35 -0400
Received: by mail-oi0-f50.google.com with SMTP id 4so82115423oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 12:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 25 Aug 2016 13:50:30 -0600
Message-ID: <CAJCQCtRuQvgTj-jj=k8Ehsnq0uEkbbzJJwRR6T16H+R4d6SeTw@mail.gmail.com>
Subject: Re: Switch raid mode without rebalance?
To: Gert Menke <gert@menke.ac>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 12:16 PM, Gert Menke <gert@menke.ac> wrote:

> However, I know that btrfs can have different raid modes on the same
> filesystem at the same time.

It's incidental right now. It's not something controllable or intended
to have enduring mixed profile block groups.

>So I was hoping I could just tell it to "switch
> to single mode for all new data", but I don't have a clue how to do that.

Such a switch doesn't exist, there's no way to define what files,
directories, or subvolumes, have what profiles.


>I
> *could* rebalance, of course, but is that really necessary?

Yes.

> How does btrfs
> find out which raid mode to use when writing new data?

That's kindof an interesting question. If you were to do 'btrfs
balance start -dconvert=single -mconvert=raid1' and very soon after
that do 'btrfs balance cancel' you'll end up with one or a few new
chunks with those profiles. When data is allocated to those chunks,
they will have those profile characteristics. When data is allocated
to old chunks that are still raid0, it will be raid0. The thing is,
you can't really tell or control what data will be placed in what
chunk. So it's plausible that some new data goes in old raid0 chunk,
and some old data goes in new single/raid1 chunks.


-- 
Chris Murphy
