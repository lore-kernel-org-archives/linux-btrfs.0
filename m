Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:15435 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FDUHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 16:07:35 -0400
Message-ID: <51AE4969.8050709@gmx.net>
Date: Tue, 04 Jun 2013 22:09:13 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
References: <1370280485-10047-1-git-send-email-joern@logfs.org> <20130603204930.GA28299@infradead.org> <20130603193647.GB10200@logfs.org> <20130603195555.GC10200@logfs.org> <20130604144856.GA12302@infradead.org> <20130604145322.4088.78915@localhost.localdomain>
In-Reply-To: <20130604145322.4088.78915@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/04/13 16:53, Chris Mason wrote:
> Quoting Christoph Hellwig (2013-06-04 10:48:56)
>> On Mon, Jun 03, 2013 at 03:55:55PM -0400, J??rn Engel wrote:
>>> Actually, when I compare the two invocations, I prefer the
>>> list_for_each_entry_del() variant over list_pop_entry().
>>>
>>>         while ((ref = list_pop_entry(&prefs, struct __prelim_ref, list))) {
>>>         list_for_each_entry_del(ref, &prefs, list) {
>>>
>>> Christoph?
>>
>> I really don't like something that looks like an iterator (*for_each*)
>> to modify a list.  Maybe it's just me, so I'd love to hear others chime
>> in.
> 
> Have to agree with Christoph.  I just couldn't put my finger on why I
> didn't like it until I saw the list_pop_entry suggestion.

list_pop_each_entry?

> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

