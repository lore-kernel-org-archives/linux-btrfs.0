Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:38690 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbcHZGZp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 02:25:45 -0400
Date: Fri, 26 Aug 2016 07:59:59 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Lutz Vieweg <lvml@5t9.de>, Ronan Chagas <ronisbr@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
Message-ID: <20160826055959.GD2471@torres.zugschlus.de>
References: <1471023419.16857.9.camel@gmail.com>
 <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com>
 <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
 <57BF15AF.40406@5t9.de>
 <CAJCQCtT=X4bU42RUQfY3ogjvpd65YZKQ7_R+PEj8vO-e91n4FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtT=X4bU42RUQfY3ogjvpd65YZKQ7_R+PEj8vO-e91n4FQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On Thu, Aug 25, 2016 at 05:56:18PM -0600, Chris Murphy wrote:
> Anyway it's a known problem, I don't think it's fixed still. There's a
> lot of enospc work in 4.8 so eventually it'll make sense to give it a
> shot with that kernel.

assuming that I'm willing to try that, will a successful rebalance
with 4.8 fix a filesystem, or is the recommended way still "backup,
format, restore, lose all snapshots"?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
