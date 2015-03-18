Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35622 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbbCRVj3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 17:39:29 -0400
Received: by pabyw6 with SMTP id yw6so54288148pab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 14:39:29 -0700 (PDT)
Subject: Re: syntax for deleting subvolumes?
To: Chris Murphy <lists@colorremedies.com>
references: <5509E34F.6010504@graphitesystems.com>
 <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: K Richard Pixley <rpixley@graphitesystems.com>
message-id: <5509F08E.6070702@graphitesystems.com>
Date: Wed, 18 Mar 2015 14:39:26 -0700
mime-version: 1.0
in-reply-to: <CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/18/15 14:06 , Chris Murphy wrote:
> The Fedora/RHEL/CentOS installer creates two subvolumes: root and 
> home. If you check out fstab, those subvolumes are mounted at / and 
> /home. Therefore the top level subvolume (id 5) is not mounted by 
> default, so there's no way to delete subvolumes in the top level. 
Ah!  Thank you.  That's the piece I was missing.

IMO, someone needs to take a clue-by-four to the heads of the 
Fedora/RHEL/CentOS installer folks.  I see no reason for this with btrfs.

--rich
