Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:40994 "EHLO
        mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbcHZTDD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 15:03:03 -0400
Date: Fri, 26 Aug 2016 21:02:59 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: linux 4.7.2 & btrfs & rsync & OOM gone crazy
Message-ID: <20160826190259.GB1470521@mother.pipebreaker.pl>
References: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 26, 2016 at 03:00:48PM -0400, E V wrote:
> Just upgraded from 4.6.5 to 4.7.2 for my btrfs backup server with 32GB
> of ram. Only thing that run's on it is an rsync of an NFS filesystem
> to the local btrfs. Cached mem tends to hang out around 26-30GB, but
> with 4.7.2 the OOM is now going crazy and trying to kill whatever it
> can including my ssh and rsync process. Anyone seen anything similar?

  That's probably OOM regression in 4.7. Could you please test this patch:
https://lkml.org/lkml/2016/8/23/145

-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

