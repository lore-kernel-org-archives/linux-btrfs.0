Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:38333 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752023AbdHLWlX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 18:41:23 -0400
Received: by mail-lf0-f53.google.com with SMTP id y15so27766123lfd.5
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Aug 2017 15:41:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
References: <21234.192.168.42.222.1502253143.squirrel@mail>
 <CAJCQCtRNT_WL41j7ZBsO3N_=5xAkj4=j7djrh+Ryg3gAV5qyZg@mail.gmail.com>
 <22169.183.88.87.49.1502260598.squirrel@mail> <CAJCQCtTpE26mxLq7ufUxCin37sajcXhnM3QsgjXjVd8x_Pw9PA@mail.gmail.com>
 <27218.183.88.87.49.1502426431.squirrel@mail> <13031.192.168.42.222.1502431206.squirrel@mail>
 <CAJCQCtRY-693NH7qYFX2E3uEWX_b-xhq0_Z+avsRZMqWBJe-ww@mail.gmail.com>
 <1243.49.228.123.163.1502505534.squirrel@mail> <CAJCQCtQ2exGHj3zq0221aXDqMAok+_G6vwpaiQVfy8_1ybJKYQ@mail.gmail.com>
 <1420.49.228.123.163.1502514511.squirrel@mail> <CAJCQCtRqkigHcGLorR3EN5TbGSRCJG3YkdGE_BG80SBXFes7vA@mail.gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Sun, 13 Aug 2017 00:41:06 +0200
Message-ID: <CANznX5HUCXZFFUXGdD23cE59tP1LM2SDEXwdsjG13Jh+OeaZYQ@mail.gmail.com>
Subject: Re: btrfs issue with mariadb incremental backup
To: Chris Murphy <lists@colorremedies.com>
Cc: siranee.ja@tpc.co.th, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        voravat@tpcorp.co.th
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 12, 2017 at 11:34 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Aug 11, 2017 at 11:08 PM,  <siranee.ja@tpc.co.th> wrote:
>
> I think the problem is that the script does things so fast that the
> snapshot is not always consistent on disk before btrfs send starts.
> It's just a guess though. If I'm right, this means the rsync mismaches
> mean the destination snapshots are bad.

Hmm. I was wondering about this exact issue the other day when I
fiddled with my own backup script.
- Should I issue a sync between creating a snapshot and starting to
rsync (or send/receive) the content of that fresh snapshot to an
external backup storage?
I dismissed the thought because I figured rsync should see the proper
state regardless if some data is still waiting in the system
write-back cache.
Now I am confused again. Is it only for send/receive? (I don't use
that feature yet but thought about switching to it from rsync.)
