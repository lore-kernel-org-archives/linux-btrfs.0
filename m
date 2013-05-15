Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35692 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab3EOQpV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 12:45:21 -0400
Received: by mail-la0-f41.google.com with SMTP id ee20so627768lab.28
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 09:45:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF95473-B35B-4B3B-9437-24448B279AB1@colorremedies.com>
References: <201305151525.27913.russell@coker.com.au> <kmve61$cqe$1@ger.gmane.org>
 <4BF95473-B35B-4B3B-9437-24448B279AB1@colorremedies.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 15 May 2013 18:44:59 +0200
Message-ID: <CAFWF=ak7tJnaCdUst7gBLpCPj8s2z0iOnXMDR63AVjiYX8X6dQ@mail.gmail.com>
Subject: Re: subvol copying
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 15, 2013 at 6:43 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On May 15, 2013, at 1:40 AM, Gabriel de Perthuis <g2p.code@gmail.com> wrote:
>
>>
>> You can move subvolumes at any time, as if they were regular directories.
>
> In the example case, the subvolumes are read-only. So is it possible to make a read-only subvolume (snapshot) read-writable? And is it possible to make a read-writeable snapshot of a read-only subvolume?
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You make a ro snapshot rw by creating a snapshot of it that is rw. So
yes to both questions, by doing the same thing in both cases.
