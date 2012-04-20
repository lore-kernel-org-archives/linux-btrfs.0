From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: An issue when mounting the dd-copied partition and the original
 one together
Date: Fri, 20 Apr 2012 09:40:01 +0200
Message-ID: <4F9112D1.8080905@jan-o-sch.net>
References: <CAOLNCyrvxNi-wKYdPaUX9Qvpzi7RhVjDgmig-Mr1_M5HmXza2Q@mail.gmail.com> <201204201720.44788.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201204201720.44788.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 20.04.2012 09:20, Chris Samuel wrote:
> Jan Schmidt was working on a "btrfs send" type command to help with 
> this, but I've not heard anything recently (last December he posted 
> that he was distracted by the backref-walking code which was a 
> necessary precursor for the send/receive code).

I still have that in my work queue. Backref walking can be considered
quite stable by now, however it's not guaranteed to be consistent in
every situation when used on live trees. There's only a few corner cases
where it's breaking, but for the qgroup patches, we need to get rid of
those.

btrfs send would operate on read-only snapshots, where I consider
backref walking stable by now. Someone has to push that backref
resolving thing on live trees forward, though. So send/receive is by no
means forgotten about, but further delayed.

-Jan
