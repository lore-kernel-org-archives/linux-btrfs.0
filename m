Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:54358 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab2GWRBX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 13:01:23 -0400
Message-ID: <500D835D.6060105@inwind.it>
Date: Mon, 23 Jul 2012 19:01:17 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Wendy Cheng <s.wendy.cheng@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is
 a ssd V2
References: <1342811743-8748-1-git-send-email-jbacik@fusionio.com> <5009B323.3040607@libero.it> <CABgxfbFUQn0F4LDpUH=xcmwL_YTGK4HbU2-z0+3iW5uk=+xp_A@mail.gmail.com> <20120723124620.GI2118@localhost.localdomain>
In-Reply-To: <20120723124620.GI2118@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/2012 02:46 PM, Josef Bacik wrote:
> On Fri, Jul 20, 2012 at 04:38:59PM -0600, Wendy Cheng wrote:

>> However, this should have been a task for the admin (or whoever types
>> this mkfs command). It is not a filesystem's job to assume how the
>> firmware works and silently ignore the DUP request, *unless* there is
>> a standard specification clearly describes linux devices that claim to
>> be not "rotational" should behave this way.
>>
> 
> The admin can still use -m dup if he wants the added possiblity of protection,
> this just makes the default not dup.  

Josef,

this was clear to us with the the code at hand. However, what was
pointed out is that is change of a well established behaviour without
documenting it not informing it.

I don't arguing about the rationale, what I am telling is : ok to the
change but you have to inform the user.

Saying "but the user can revert the change passing '-m dup'" is not a
valid response, because the user *could* revert the change if he *would*
be informed about the change.

BR
G.Baroncelli



>Thanks,
> 
> Josef
> .
> 

