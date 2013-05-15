Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:62647 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab3EORal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 13:30:41 -0400
Received: by mail-la0-f48.google.com with SMTP id fs12so2012586lab.7
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 10:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9E8AFAF6-ACA6-44BB-A4CF-89B6E50E8BCB@colorremedies.com>
References: <201305151525.27913.russell@coker.com.au> <kmve61$cqe$1@ger.gmane.org>
 <4BF95473-B35B-4B3B-9437-24448B279AB1@colorremedies.com> <CAFWF=ak7tJnaCdUst7gBLpCPj8s2z0iOnXMDR63AVjiYX8X6dQ@mail.gmail.com>
 <9E8AFAF6-ACA6-44BB-A4CF-89B6E50E8BCB@colorremedies.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 15 May 2013 19:30:19 +0200
Message-ID: <CAFWF=amBKr9SFm1R6fggWJHrf5B4b4BReewVxEzJGiEBcPE6mg@mail.gmail.com>
Subject: Re: subvol copying
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 15, 2013 at 7:28 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On May 15, 2013, at 10:44 AM, Harald Glatt <mail@hachre.de> wrote:
>
>>
>> You make a ro snapshot rw by creating a snapshot of it that is rw. So
>> yes to both questions, by doing the same thing in both cases.
>
> In other words, a normal snapshot (without -r) of a read-only snapshot will create a rw snapshot?

Yes
