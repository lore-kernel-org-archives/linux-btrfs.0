Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:47915 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaHDV1h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 17:27:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 7D27340044
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Aug 2014 07:27:36 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 19754-05 for <linux-btrfs@vger.kernel.org>;
 Tue,  5 Aug 2014 07:27:36 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-9ddd-740d-de8b-0d3a.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:9ddd:740d:de8b:d3a])
	by csamuel.org (Postfix) with ESMTPSA id 191904000D
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Aug 2014 07:27:36 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 05 Aug 2014 07:27:35 +1000
Message-ID: <3047313.sJ59hp0tng@quad>
In-Reply-To: <CAFChkqsnRvO9h=kxO8LVnchEN3k5oXUFhsCgGw0qPpaT9ipnjw@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <6565984.JHVfJyxURt@quad> <CAFChkqsnRvO9h=kxO8LVnchEN3k5oXUFhsCgGw0qPpaT9ipnjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

On Mon, 4 Aug 2014 11:59:19 AM Peter Waller wrote:

> On 4 August 2014 11:50, Chris Samuel <chris@csamuel.org> wrote:
>
> > To be honest I'm not sure I'd suggest btrfs for production use at all at
> > present, it's only recently been unmarked as experimental and to be honest
> > I feel that was premature.
> 
> Thanks for the honest answer.

That's OK, I am enthusiastic about btrfs (being a pre-mainline merge user), 
but I don't think it serves it well to signal that it's more ready than it 
actually is.

> There are very positive signals out there which I had perhaps taken
> too literally. I'd love to see it become ready, there are a lot of things
> about BTRFS which appeal greatly. So I hope I'm helping by trying
> to make it clear the problems that I encountered.

Oh indeed, please don't take my brief replies as being anything other than 
brief due to preparing to do some astronomy! :-)

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


