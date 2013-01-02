Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:50317 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABWTq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jan 2013 17:19:46 -0500
Date: Wed, 2 Jan 2013 22:19:19 +0000
From: junlion@tormail.org
To: linux-btrfs@vger.kernel.org
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: Incremental btrfs receive in opposite direction fails
References: <1ToibV-0001fD-SN@internal.tormail.org>
 <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com>
 <1TpCWu-000Fz2-6t@internal.tormail.org>
 <50E466FC.1070802@jan-o-sch.net>
 <20130102205351.GA2242@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130102205351.GA2242@localhost>
Message-Id: <1TqWcc-0003FU-1J@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>     # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
>     # !! Now we've made it look as if mp1/foo.1 was received from !!
>     # !! mp2/foo.1 when actually it was the other way around.     !!
>     # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Better just ignore what I wrote there, it's not completely correct.
(Because we do not modify mp1/foo.1 but snapshot it to mp1/foo.1rw
and modify that one.)
