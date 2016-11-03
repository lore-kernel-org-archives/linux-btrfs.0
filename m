Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:16621 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758184AbcKCSYn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 14:24:43 -0400
Subject: Re: [PATCH] btrfs: Remove some dead code
To: Tobias Klauser <tklauser@distanz.ch>
References: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
 <20161103124349.GA819@distanz.ch>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <db80cda8-0d26-48cb-7ca6-a61b91b0f3be@wanadoo.fr>
Date: Thu, 3 Nov 2016 19:24:33 +0100
MIME-Version: 1.0
In-Reply-To: <20161103124349.GA819@distanz.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 03/11/2016 à 13:43, Tobias Klauser a écrit :
> On 2016-11-01 at 11:26:06 +0100, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
>> 'btrfs_iget()' can not return an error pointer, so this test can be
>> removed.
> This descrption does not match what the patch actually does. Shouldn't
> it say "...can not return NULL, so this test can be removed."?
>
You are obviously correct. Cut'n'Paste error while sending other patches.
I will send a V2 with an updated description.

Thanks for the review.

CJ
